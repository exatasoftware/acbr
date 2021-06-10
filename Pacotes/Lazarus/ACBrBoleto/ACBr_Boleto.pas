{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit ACBr_Boleto;

{$warn 5023 off : no warning about unused units}
interface

uses
  ACBrBoleto, ACBrBancoBradesco, ACBrBancoBrasil, ACBrBancoItau, 
  ACBrBancoSicredi, ACBrBancoMercantil, ACBrBancoBanrisul, ACBrBancoSantander, 
  ACBrBancoBancoob, ACBrBancoHSBC, ACBrBancoNordeste, ACBrBancoBRB, 
  ACBrBancoBic, ACBrBancoBanestes, ACBrBancoCecred, ACBrBancoCaixa, 
  ACBrBancoCaixaSICOB, ACBrBancoBrasilSicoob, ACBrBancoCitiBank, 
  ACBrBancoPine, ACBrBancoPineBradesco, ACBrBoletoReg, ACBrBoletoWS, 
  ACBrBoletoConversao, ACBrBoletoPcnConsts, ACBrBoletoW_Caixa, 
  ACBrBoletoRet_Caixa, ACBrBoletoRetorno, ACBrBoletoW_BancoBrasil, 
  ACBrBoletoRet_BancoBrasil, ACBrBoletoW_BancoBrasil_API, ACBrBoletoRet_BancoBrasil_API,
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ACBrBoletoReg', @ACBrBoletoReg.Register);
end;

initialization
  RegisterPackage('ACBr_Boleto', @Register);
end.
