{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}
unit ACBrConsultaCNPJ.WS;

interface
uses
  ACBrJSON, SysUtils, ACBrValidador, httpsend,
  Classes;
type
  EACBrConsultaCNPJWSException = class ( Exception );
  TACBrConsultaCNPJWSResposta = class (TObject)
    NaturezaJuridica     : String ;
    EmpresaTipo          : String;
    Abertura             : TDateTime;
    RazaoSocial          : String;
    Fantasia             : String;
    Porte                : String;
    CNAE1                : String;
    CNAE2                : TStringList;
    Endereco             : String;
    Numero               : String;
    Complemento          : String;
    CEP                  : String;
    Bairro               : String;
    Cidade               : String;
    UF                   : String;
    Situacao             : String;
    SituacaoEspecial     : String;
    CNPJ                 : String;
    DataSituacao         : TDateTime;
    DataSituacaoEspecial : TDateTime;
    EndEletronico        : String;
    Telefone             : String;
    EFR                  : string;
    MotivoSituacaoCad    : string;
    CodigoIBGE           : String;
  end;
  { TACBrConsultaCNPJWS }
  TACBrConsultaCNPJWS = class( TObject )
    FCNPJ : string;
    FUsuario : String;
    FSenha : String;
    FResposta : TACBrConsultaCNPJWSResposta;
  private
    FHTTPSend: THTTPSend;
    public
      constructor create(const ACNPJ : string; AUsuario : string = ''; ASenha: string = '');
      destructor Destroy; override;
      function Executar : boolean; virtual;
      property HTTPSend: THTTPSend read FHTTPSend write FHTTPSend;
  end;
implementation

{ TACBrConsultaCNPJWS }

constructor TACBrConsultaCNPJWS.create(const ACNPJ : string; AUsuario : string = ''; ASenha: string = '');
begin
  FCNPJ     :=  ACNPJ;
  FUsuario  := AUsuario;
  FSenha    := ASenha;
  FResposta := TACBrConsultaCNPJWSResposta.Create;
  FResposta.CNAE2     := TStringList.Create;
end;

destructor TACBrConsultaCNPJWS.Destroy;
begin
  FResposta.CNAE2.Free;
  FResposta.Free;
  inherited;
end;

function TACBrConsultaCNPJWS.Executar: boolean;
var LErro : String;
begin
  Result := False;
  LErro := ValidarCNPJ( FCNPJ ) ;
  if LErro <> '' then
    raise EACBrConsultaCNPJWSException.Create(LErro);
end;

end.
