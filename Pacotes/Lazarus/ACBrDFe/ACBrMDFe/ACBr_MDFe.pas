{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit ACBr_MDFe;

interface

uses
  ACBrMDFe, ACBrMDFeConfiguracoes, ACBrMDFeManifestos, ACBrMDFeReg, 
  ACBrMDFeWebServices, pmdfeConsMDFeNaoEnc, pmdfeConsReciMDFe, 
  pmdfeConsSitMDFe, pmdfeConsStatServ, pmdfeConversaoMDFe, pmdfeEnvEventoMDFe, 
  pmdfeEventoMDFe, pmdfeMDFe, pmdfeMDFeR, pmdfeMDFeW, pmdfeProcMDFe, 
  pmdfeRetConsMDFeNaoEnc, pmdfeRetConsReciMDFe, pmdfeRetConsSitMDFe, 
  pmdfeRetConsStatServ, pmdfeRetEnvEventoMDFe, pmdfeRetEnvMDFe, 
  pmdfeSignature, ACBrMDFeDAMDFeClass, pmdfeConsts, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ACBrMDFeReg', @ACBrMDFeReg.Register);
end;

initialization
  RegisterPackage('ACBr_MDFe', @Register);
end.
