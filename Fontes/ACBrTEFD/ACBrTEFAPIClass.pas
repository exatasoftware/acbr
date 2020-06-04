{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }

{ Direitos Autorais Reservados (c) 2004 Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo:                                                 }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }

{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }

{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }

{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrTEFAPIClass;

interface

uses
  Classes, SysUtils,
  ACBrBase, ACBrTEFComum;

type

  { EACBrTEFAPIException }

  EACBrTEFAPIException = class(Exception)
  public
    constructor CreateAnsiStr(const msg: String);
  end;

  { TACBrTEFAPIResp }

  TACBrTEFAPIResp = class(TACBrTEFResp)
  public
    function VerificarSequenciaInformacao(const Identificacao: Integer): Boolean; virtual;
    procedure GravaInformacao(const Identificacao: Integer; const Informacao: AnsiString);
  end;

  { TACBrTEFAPIClass }

  TACBrTEFAPIClass = class(TComponent)
  private
    procedure ErroAbstract(const NomeProcedure: String);
  protected
    fpOwner: TComponent;

    function GetModeloStr: String; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;

    procedure CancelarTransacaoPendente;

    procedure Inicializar; virtual;
    procedure DesInicializar; virtual;

    property ModeloStr: String read GetModeloStr;
  end;

implementation

uses
  ACBrTEFAPI, ACBrUtil;

{ TACBrTEFAPIResp }

function TACBrTEFAPIResp.VerificarSequenciaInformacao(const Identificacao: Integer): Boolean;
begin
  Result := False;
end;

procedure TACBrTEFAPIResp.GravaInformacao(const Identificacao: Integer; const Informacao: AnsiString);
var
  Sequencia: Integer;
  AsString: String;
begin
  if VerificarSequenciaInformacao(Identificacao) then
  begin
    Sequencia := 1;
    while (Trim(LeInformacao(Identificacao, Sequencia).AsString) <> '') do // J� Existe ?
      Inc(Sequencia);
  end
  else
    Sequencia := 0;

  AsString := BinaryStringToString(Informacao);  // Converte #10 para "\x0A"
  fpConteudo.GravaInformacao(Identificacao, Sequencia, AsString);
end;

{ EACBrTEFAPIException }

constructor EACBrTEFAPIException.CreateAnsiStr(const msg: String);
begin
  inherited Create(ACBrStr(msg));
end;

{ TACBrTEFAPIClass }

constructor TACBrTEFAPIClass.Create(AOwner: TComponent);
begin
  if not (AOwner is TACBrTEFAPI) then
    raise EACBrTEFAPIException.CreateAnsiStr(sACBrTEFAPIErrClassCreateException);

  inherited Create(AOwner);

  fpOwner := AOwner;
end;

destructor TACBrTEFAPIClass.Destroy;
begin
  inherited Destroy;
end;

procedure TACBrTEFAPIClass.CancelarTransacaoPendente;
begin
  ErroAbstract('CancelarTransacaoPendente');
end;

procedure TACBrTEFAPIClass.Inicializar;
begin
  {}
end;

procedure TACBrTEFAPIClass.DesInicializar;
begin
  {}
end;

procedure TACBrTEFAPIClass.ErroAbstract(const NomeProcedure: String);
begin
  raise EACBrTEFAPIException.Create( Format(sACBrTEFAPIErrNaoImplementado, [NomeProcedure, ModeloStr]) );
end;

function TACBrTEFAPIClass.GetModeloStr: String;
begin
  Result := 'N�o Definido';
end;

end.


case Identificacao of
  141, 142,            // 141 - Data Parcela, 142 - Valor Parcela
  600..607, 611..624:  // Dados do Corresp. Banc�rio
  begin

