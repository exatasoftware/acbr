﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Runtime.ConstrainedExecution;
using System.Runtime.ExceptionServices;
using System.Runtime.InteropServices;
using System.Text;

namespace ACBrLib.Core
{
    /// <inheritdoc />
    public abstract class ACBrLibHandle : SafeHandle
    {
        #region InnerTypes

        private class LibLoader
        {
            #region Constructors

            static LibLoader()
            {
                switch (Environment.OSVersion.Platform)
                {
                    case PlatformID.Win32S:
                    case PlatformID.Win32Windows:
                    case PlatformID.Win32NT:
                    case PlatformID.WinCE:
                        IsWindows = true;
                        break;

                    case PlatformID.Unix:
                        try
                        {
                            var num = Marshal.AllocHGlobal(8192);
                            if (uname(num) == 0 && Marshal.PtrToStringAnsi(num) == "Darwin")
                                IsOSX = true;

                            Marshal.FreeHGlobal(num);
                            break;
                        }
                        catch
                        {
                            break;
                        }

                    case PlatformID.MacOSX:
                        IsOSX = true;
                        break;

                    default:
                        throw new ArgumentOutOfRangeException();
                }
            }

            #endregion Constructors

            #region Exports

            [DllImport("libc")]
            private static extern int uname(IntPtr buf);

            #endregion Exports

            #region InnerTypes

            private static class Windows
            {
                [DllImport("kernel32", CharSet = CharSet.Ansi, SetLastError = true)]
                public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);

                [DllImport("kernel32", CharSet = CharSet.Unicode, SetLastError = true)]
                public static extern IntPtr LoadLibraryW(string lpszLib);

                [DllImport("kernel32", SetLastError = true)]
                public static extern bool FreeLibrary(IntPtr hModule);
            }

            private static class Linux
            {
                [DllImport("libdl.so.2")]
                public static extern IntPtr dlopen(string path, int flags);

                [DllImport("libdl.so.2")]
                public static extern IntPtr dlsym(IntPtr handle, string symbol);

                [DllImport("libdl.so.2")]
                public static extern int dlclose(IntPtr handle);
            }

            private static class OSX
            {
                [DllImport("/usr/lib/libSystem.dylib")]
                public static extern IntPtr dlopen(string path, int flags);

                [DllImport("/usr/lib/libSystem.dylib")]
                public static extern IntPtr dlsym(IntPtr handle, string symbol);

                [DllImport("/usr/lib/libSystem.dylib")]
                public static extern int dlclose(IntPtr handle);
            }

            #endregion InnerTypes

            #region Properties

            public static readonly bool IsWindows;

            public static readonly bool IsOSX;

            #endregion Properties

            #region Methods

            public static IntPtr LoadLibrary(string libname)
            {
                if (IsWindows) return Windows.LoadLibraryW(libname);
                return IsOSX ? OSX.dlopen(libname, 1) : Linux.dlopen(libname, 1);
            }

            public static bool FreeLibrary(IntPtr library)
            {
                if (IsWindows) return Windows.FreeLibrary(library);
                return (IsOSX ? OSX.dlclose(library) : Linux.dlclose(library)) == 0;
            }

            public static IntPtr GetProcAddress(IntPtr library, string function)
            {
                var num = !IsWindows
                    ? !IsOSX ? Linux.dlsym(library, function) : OSX.dlsym(library, function)
                    : Windows.GetProcAddress(library, function);
                return num;
            }

            public static T LoadFunction<T>(IntPtr procaddress) where T : class
            {
                if (procaddress == IntPtr.Zero || procaddress == MinusOne) return null;
                var functionPointer = Marshal.GetDelegateForFunctionPointer(procaddress, typeof(T));

                return functionPointer as T;
            }

            #endregion Methods
        }

        #endregion InnerTypes

        #region Fields

        protected readonly Dictionary<Type, string> methodList;
        protected readonly Dictionary<string, Delegate> methodCache;
        protected readonly string className;
        protected const int BUFFER_LEN = 256;

        #endregion Fields

        #region Constructors

        static ACBrLibHandle()
        {
            MinusOne = new IntPtr(-1);
        }

        protected ACBrLibHandle(string dllName64, string dllName32) :
            this(Environment.Is64BitProcess ? dllName64 : dllName32)
        {
        }

        protected ACBrLibHandle(string dllName)
            : base(IntPtr.Zero, true)
        {
            var uri = new Uri(Assembly.GetExecutingAssembly().CodeBase);
            var path = Path.GetDirectoryName(!uri.IsFile ? uri.ToString() : uri.LocalPath + Uri.UnescapeDataString(uri.Fragment));
            path += Environment.Is64BitProcess ? "\\ACBrLib\\x64\\" : "\\ACBrLib\\x86\\";
            Environment.SetEnvironmentVariable("PATH", path);

            methodCache = new Dictionary<string, Delegate>();
            methodList = new Dictionary<Type, string>();
            className = GetType().Name;

            var pNewSession = LibLoader.LoadLibrary(dllName);
            if (pNewSession == IntPtr.Zero || pNewSession == MinusOne)
                throw CreateException("Não foi possivel carregar a biblioteca.");

            SetHandle(pNewSession);
            InitializeMethods();
        }

        #endregion Constructors

        #region Properties

        /// <summary>
        /// </summary>
        public static IntPtr MinusOne { get; }

        /// <inheritdoc />
        public override bool IsInvalid
        {
            get
            {
                if (handle != IntPtr.Zero) return handle == MinusOne;

                return true;
            }
        }

        public static bool IsWindows => LibLoader.IsWindows;

        public static bool IsOSX => LibLoader.IsOSX;

        public static bool IsLinux => !LibLoader.IsOSX && LibLoader.IsWindows;

        #endregion Properties

        #region Methods

        /// <inheritdoc />
        [ReliabilityContract(Consistency.WillNotCorruptState, Cer.Success)]
        protected override bool ReleaseHandle()
        {
            if (IsInvalid) return true;

            FinalizeLib();

            var ret = LibLoader.FreeLibrary(handle);

            if (ret)
                SetHandleAsInvalid();

            return ret;
        }

        protected abstract void InitializeMethods();

        protected abstract string GetUltimoRetorno(int iniBufferLen = 0);

        protected abstract void FinalizeLib();

        protected virtual T ConvertValue<T>(string value)
        {
            if (typeof(T).IsEnum) return (T)Enum.ToObject(typeof(T), Convert.ToInt32(value));
            if (typeof(T) == typeof(bool)) return (T)(object)Convert.ToBoolean(Convert.ToInt32(value));
            if (typeof(T) == typeof(byte[])) return (T)(object)Convert.FromBase64String(value);
            if (typeof(T) == typeof(Stream))
            {
                var dados = Convert.FromBase64String(value);
                var ms = new MemoryStream();
                ms.Write(dados, 0, dados.Length);
                return (T)(object)ms;
            }

            return (T)Convert.ChangeType(value, typeof(T));
        }

        protected virtual string ConvertValue(object value)
        {
            var type = value.GetType();
            var propValue = value.ToString();
            if (type.IsEnum) propValue = ((int)value).ToString();
            if (type == typeof(bool)) propValue = Convert.ToInt32(value).ToString();
            if (type == typeof(byte[])) propValue = Convert.ToBase64String((byte[])value);
            if (type == typeof(Stream))
            {
                using (var ms = new MemoryStream())
                {
                    ((Stream)value).CopyTo(ms);
                    propValue = Convert.ToBase64String(ms.ToArray());
                }
            }

            return propValue;
        }

        /// <summary>
        ///     Adiciona um delegate a lista para a função informada.
        /// </summary>
        /// <param name="functionName">Nome da função para exportar</param>
        /// <typeparam name="T">Delegate da função</typeparam>
        protected virtual void AddMethod<T>(string functionName) where T : class
        {
            methodList.Add(typeof(T), functionName);
        }

        /// <summary>
        ///     Retorna o delegate para uso.
        /// </summary>
        /// <typeparam name="T">Delegate</typeparam>
        /// <returns></returns>
        /// <exception cref="ArgumentNullException"></exception>
        protected virtual T GetMethod<T>() where T : class
        {
            if (!methodList.ContainsKey(typeof(T)))
                throw CreateException($"Função não adicionada para o [{nameof(T)}].");

            var method = methodList[typeof(T)];
            if (methodCache.ContainsKey(method)) return methodCache[method] as T;

            var mHandler = LibLoader.GetProcAddress(handle, method);

            if (mHandler == IntPtr.Zero || mHandler == MinusOne)
                throw new ArgumentNullException("Função não encontrada: " + method);

            var methodHandler = LibLoader.LoadFunction<T>(mHandler);

            methodCache.Add(method, methodHandler as Delegate);
            return methodHandler;
        }

        /// <summary>
        ///     Executa a função e trata erros nativos.
        /// </summary>
        /// <param name="method"></param>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        /// <exception cref="ApplicationException"></exception>
        [HandleProcessCorruptedStateExceptions]
        protected virtual T ExecuteMethod<T>(Func<T> method)
        {
            try
            {
                return method();
            }
            catch (Exception exception)
            {
                throw ProcessException(exception);
            }
        }

        [HandleProcessCorruptedStateExceptions]
        protected virtual void ExecuteMethod(Action method)
        {
            try
            {
                method();
            }
            catch (Exception exception)
            {
                throw ProcessException(exception);
            }
        }

        /// <summary>
        ///     Cria e dispara uma <see cref="ApplicationException" /> com a mensagem informada.
        /// </summary>
        /// <param name="errorMessage">Mensagem de erro.</param>
        /// <returns>
        ///     <see cref="ApplicationException" />
        /// </returns>
        protected virtual ApplicationException CreateException(string errorMessage)
        {
            return new ApplicationException(errorMessage);
        }

        /// <summary>
        ///     Tatar uma <see cref="Exception" /> e dispara uma <see cref="ApplicationException" /> com a mensagem da mesma.
        /// </summary>
        /// <param name="exception">Exception</param>
        /// <returns>
        ///     <see cref="ApplicationException" />
        /// </returns>
        protected virtual ApplicationException ProcessException(Exception exception)
        {
            return new ApplicationException(exception.Message, exception);
        }

        protected static string ToUTF8(string value)
        {
            return string.IsNullOrEmpty(value) ? value : Encoding.Default.GetString(Encoding.UTF8.GetBytes(value));
        }

        protected static string FromUTF8(StringBuilder value)
        {
            if (value == null) return null;
            return value.Length == 0
                ? string.Empty
                : Encoding.UTF8.GetString(Encoding.Default.GetBytes(value.ToString()));
        }

        protected string ProcessResult(StringBuilder buffer, int bufferLen)
        {
            return bufferLen > BUFFER_LEN ? GetUltimoRetorno(bufferLen) : FromUTF8(buffer);
        }

        protected void CheckResult(int ret)
        {
            if (ret >= 0) return;

            var message = GetUltimoRetorno();

            switch (ret)
            {
                case -6:
                    throw new DirectoryNotFoundException(message);

                case -5:
                    throw new FileNotFoundException(message);

                default:
                    throw new ApplicationException(message);
            }
        }

        #endregion Methods
    }
}