unit ACBrLibNFeTestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry;

const
  CLibNFeNome = 'ACBrLibNFE';

type

  { TTestACBrNFeLib }

  TTestACBrNFeLib = class(TTestCase)
  published
    procedure Test_NFE_Inicializar_Com_DiretorioInvalido;
    procedure Test_NFE_Inicializar;
    procedure Test_NFE_Inicializar_Ja_Inicializado;
    procedure Test_NFE_Finalizar;
    procedure Test_NFE_Finalizar_Ja_Finalizado;
    procedure Test_NFE_Nome_Obtendo_LenBuffer;
    procedure Test_NFE_Nome_Lendo_Buffer_Tamanho_Identico;
    procedure Test_NFE_Nome_Lendo_Buffer_Tamanho_Maior;
    procedure Test_NFE_Nome_Lendo_Buffer_Tamanho_Menor;
    procedure Test_NFE_Versao;
    procedure Test_NFE_ConfigLerValor;
  end;

implementation

uses
  ACBrLibNFeStaticImport, ACBrLibNFeConsts, ACBrLibConsts;

procedure TTestACBrNFeLib.Test_NFE_Inicializar_Com_DiretorioInvalido;
begin
  NFE_Finalizar();
  AssertEquals(ErrDiretorioNaoExiste, NFE_Inicializar('C:\NAOEXISTE\ACBrLib.ini',''));
end;

procedure TTestACBrNFeLib.Test_NFE_Inicializar;
begin
  AssertEquals(ErrOk, NFE_Inicializar('',''));
end;

procedure TTestACBrNFeLib.Test_NFE_Inicializar_Ja_Inicializado;
begin
  AssertEquals(ErrOk, NFE_Inicializar('',''));
end;

procedure TTestACBrNFeLib.Test_NFE_Finalizar;
begin
  AssertEquals(ErrOk, NFE_Finalizar());
end;

procedure TTestACBrNFeLib.Test_NFE_Finalizar_Ja_Finalizado;
begin
  AssertEquals(ErrOk, NFE_Finalizar());
end;

procedure TTestACBrNFeLib.Test_NFE_Nome_Obtendo_LenBuffer;
var
  Bufflen: Integer;
begin
  // Obtendo o Tamanho //
  Bufflen := 0;
  AssertEquals(ErrOk, NFE_Nome(Nil, Bufflen));
  AssertEquals(Length(CLibNFeNome), Bufflen);
end;

procedure TTestACBrNFeLib.Test_NFE_Nome_Lendo_Buffer_Tamanho_Identico;
var
  AStr: String;
  Bufflen: Integer;
begin
  Bufflen := Length(CLibNFeNome);
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, NFE_Nome(PChar(AStr), Bufflen));
  AssertEquals(Length(CLibNFeNome), Bufflen);
  AssertEquals(CLibNFeNome, AStr);
end;

procedure TTestACBrNFeLib.Test_NFE_Nome_Lendo_Buffer_Tamanho_Maior;
var
  AStr: String;
  Bufflen: Integer;
begin
  Bufflen := Length(CLibNFeNome)*2;
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, NFE_Nome(PChar(AStr), Bufflen));
  AStr := copy(AStr, 1, Bufflen);
  AssertEquals(Length(CLibNFeNome), Bufflen);
  AssertEquals(CLibNFeNome, AStr);
end;

procedure TTestACBrNFeLib.Test_NFE_Nome_Lendo_Buffer_Tamanho_Menor;
var
  AStr: String;
  Bufflen: Integer;
begin
  Bufflen := 4;
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, NFE_Nome(PChar(AStr), Bufflen));
  AssertEquals(Length(CLibNFeNome), Bufflen);
  AssertEquals(copy(CLibNFeNome,1,4), AStr);
end;

procedure TTestACBrNFeLib.Test_NFE_Versao;
var
  Bufflen: Integer;
  AStr: String;
begin
  // Obtendo o Tamanho //
  Bufflen := 0;
  AssertEquals(ErrOk, NFE_Versao(Nil, Bufflen));
  Assert(Bufflen > 0);

  // Lendo a resposta //
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, NFE_Versao(PChar(AStr), Bufflen));
  Assert(Bufflen > 0);
  Assert(AStr <> '');
end;

procedure TTestACBrNFeLib.Test_NFE_ConfigLerValor;
var
  Bufflen: Integer;
  AStr: String;
begin
  // Obtendo o Tamanho //
  Bufflen := 255;
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, NFE_ConfigLerValor(CSessaoVersao, CACBrLib, PChar(AStr), Bufflen));
  AStr := copy(AStr,1,Bufflen);
  AssertEquals(CACBrLibVersaoConfig, AStr);

  NFE_ConfigGravarValor('DFe', 'DadosPFX', );
end;

initialization
  RegisterTest(TTestACBrNFeLib);

end.

