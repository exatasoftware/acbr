{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit ACBr_SAT;

interface

uses
  ACBrSATReg, ACBrSAT, ACBrSATClass, ACBrSATDinamico_cdecl, pcnCFe, pcnCFeR, 
  pcnCFeW, pcnCFeCanc, pcnCFeCancR, pcnCFeCancW, pcnRede, pcnRedeR, pcnRedeW, 
  ACBrSATDinamico_stdcall, ACBrSATMFe_integrador, ACBrSATExtratoClass, 
  ACBrSATExtratoReportClass, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ACBrSATReg', @ACBrSATReg.Register);
end;

initialization
  RegisterPackage('ACBr_SAT', @Register);
end.
