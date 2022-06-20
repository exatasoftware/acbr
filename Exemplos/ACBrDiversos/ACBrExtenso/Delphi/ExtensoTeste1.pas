{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{																			   }
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

unit ExtensoTeste1;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  ACBrExtenso, StdCtrls, Buttons, ExtCtrls, ACBrBase;

type

  { TfrExtenso }

  TfrExtenso = class(TForm)
    ACBrExtenso1: TACBrExtenso;
    btExtenso: TButton;
    cbFormato: TComboBox;
    cbIdioma: TComboBox;
    cbZeroAEsquerda: TCheckBox;
    edInteiroSingular: TEdit;
    edInteiroPlural: TEdit;
    edDecimalSingular: TEdit;
    edDecimalPlural: TEdit;
    edValor: TEdit;
    lbValor: TLabel;
    lbFormato: TLabel;
    lbInteiroSingular: TLabel;
    lbIdioma: TLabel;
    lbInteiroPlural: TLabel;
    lbDecimalSingular: TLabel;
    lbDecimalPlural: TLabel;
    mExtenso: TMemo;
    pnCabecalho: TPanel;
    pnCustomStr: TPanel;
    procedure btExtensoClick(Sender: TObject);
    procedure cbFormatoChange(Sender: TObject);
    procedure cbIdiomaChange(Sender: TObject);
    procedure edValorKeyPress(Sender: TObject; var Key: Char);
    procedure cbZeroAEsquerdaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure AvaliarInterface;
    procedure PreencherInfoDefault;
  public
  end;

var
  frExtenso: TfrExtenso;

implementation

{$R *.dfm}

uses
  ACBrUtil.Base, ACBrUtil.Strings, TypInfo;


procedure TfrExtenso.btExtensoClick(Sender: TObject);
begin
  with ACBrExtenso1 do
  begin
    if (Idioma = idiCustom) then
    begin
      StrMoeda    := edInteiroSingular.Text;
      StrMoedas   := edInteiroPlural.Text;
      StrCentavo  := edDecimalSingular.Text;
      StrCentavos := edDecimalPlural.Text;
    end;
    
    Valor := StringToFloat(edValor.Text);
    mExtenso.Text := Texto;
  end;
end;

procedure TfrExtenso.cbFormatoChange(Sender: TObject);
begin
  ACBrExtenso1.Formato := TACBrExtensoFormato(cbFormato.ItemIndex);
  AvaliarInterface;
end;

procedure TfrExtenso.cbIdiomaChange(Sender: TObject);
begin
  ACBrExtenso1.Idioma := TACBrExtensoIdioma(cbIdioma.ItemIndex);
  AvaliarInterface;
end;

procedure TfrExtenso.edValorKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',',','.',#13,#8]) then
    Key := #0
  else if Key in [',','.'] then
    Key := {$IFDEF HAS_FORMATSETTINGS}FormatSettings.{$ENDIF}DecimalSeparator;
end;

procedure TfrExtenso.cbZeroAEsquerdaClick(Sender: TObject);
begin
  ACBrExtenso1.ZeroAEsquerda := cbZeroAEsquerda.Checked;
end;

procedure TfrExtenso.FormCreate(Sender: TObject);
var
  I: TACBrExtensoIdioma;
  J: TACBrExtensoFormato;
begin
  cbIdioma.Items.Clear;
  for I := Low(TACBrExtensoIdioma) to High(TACBrExtensoIdioma) do
     cbIdioma.Items.Add(GetEnumName(TypeInfo(TACBrExtensoIdioma), Integer(I)));

  cbFormato.Items.Clear;
  for J := Low(TACBrExtensoFormato) to High(TACBrExtensoFormato) do
     cbFormato.Items.Add(GetEnumName(TypeInfo(TACBrExtensoFormato), Integer(J)));

  PreencherInfoDefault;
  AvaliarInterface;
end;

procedure TfrExtenso.AvaliarInterface;
begin
  with ACBrExtenso1 do
  begin
    edInteiroSingular.Text := StrMoeda;
    edInteiroPlural.Text   := StrMoedas;
    edDecimalSingular.Text := StrCentavo;
    edDecimalPlural.Text   := StrCentavos;

    pnCustomStr.Enabled := (Idioma = idiCustom);
    lbFormato.Enabled := (Idioma <> idiCustom);
    cbFormato.Enabled := (Idioma <> idiCustom);
  end;
end;

procedure TfrExtenso.PreencherInfoDefault;
begin
  with ACBrExtenso1 do
  begin
    cbIdioma.ItemIndex := Ord(Idioma);
    cbFormato.ItemIndex := Ord(Formato);

    edInteiroSingular.Text := StrMoeda;
    edInteiroPlural.Text := StrMoedas;
    edDecimalSingular.Text := StrCentavo;
    edDecimalPlural.Text := StrCentavos;
  end;
end;

end.
