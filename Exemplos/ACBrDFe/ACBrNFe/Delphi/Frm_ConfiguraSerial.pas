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

unit Frm_ConfiguraSerial;

interface

uses
  ACBrDevice, ACBrDeviceSerial, 
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TfrConfiguraSerial }

  TfrmConfiguraSerial = class(TForm)
    Label5: TLabel;
    cmbBaudRate: TComboBox;
    Label6: TLabel;
    cmbDataBits: TComboBox;
    Label7: TLabel;
    cmbParity: TComboBox;
    Label11: TLabel;
    cmbStopBits: TComboBox;
    Label8: TLabel;
    cmbHandShaking: TComboBox;
    Label4: TLabel;
    cmbPortaSerial: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    chHardFlow: TCheckBox;
    chSoftFlow: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure cmbPortaSerialChange(Sender: TObject);
    procedure cmbBaudRateChange(Sender: TObject);
    procedure cmbDataBitsChange(Sender: TObject);
    procedure cmbParityChange(Sender: TObject);
    procedure cmbStopBitsChange(Sender: TObject);
    procedure cmbHandShakingChange(Sender: TObject);
    procedure chHardFlowClick(Sender: TObject);
    procedure chSoftFlowClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure VerificaFlow;
  public
    { Public declarations }
    Device : TACBrDevice;
  end;

var
  frmConfiguraSerial: TfrmConfiguraSerial;

implementation

{$R *.dfm}

{ TfrConfiguraSerial }

procedure TfrmConfiguraSerial.FormCreate(Sender: TObject);
begin
  Device := TACBrDevice.Create(self);
end;

procedure TfrmConfiguraSerial.FormDestroy(Sender: TObject);
begin
  Device.Free;
end;

procedure TfrmConfiguraSerial.FormShow(Sender: TObject);
begin
  cmbBaudRate.ItemIndex    := cmbBaudRate.Items.IndexOf(IntToStr( Device.Baud ));
  cmbDataBits.ItemIndex    := cmbDataBits.Items.IndexOf(IntToStr( Device.Data ));
  cmbParity.ItemIndex      := Integer( Device.Parity );
  cmbStopBits.ItemIndex    := Integer( Device.Stop );
  chHardFlow.Checked       := Device.HardFlow;
  chSoftFlow.Checked       := Device.SoftFlow;
  cmbHandShaking.ItemIndex := Integer( Device.HandShake );
end;

procedure TfrmConfiguraSerial.cmbPortaSerialChange(Sender: TObject);
begin
  Device.Porta := cmbPortaSerial.Text;
end;

procedure TfrmConfiguraSerial.cmbBaudRateChange(Sender: TObject);
begin
  Device.Baud := StrToInt(cmbBaudRate.Text);
end;

procedure TfrmConfiguraSerial.cmbDataBitsChange(Sender: TObject);
begin
  Device.Data := StrToInt(cmbDataBits.Text);
end;

procedure TfrmConfiguraSerial.cmbParityChange(Sender: TObject);
begin
  Device.Parity := TACBrSerialParity( cmbParity.ItemIndex );
end;

procedure TfrmConfiguraSerial.cmbStopBitsChange(Sender: TObject);
begin
  Device.Stop := TACBrSerialStop( cmbStopBits.ItemIndex );
end;

procedure TfrmConfiguraSerial.cmbHandShakingChange(Sender: TObject);
begin
  Device.HandShake := TACBrHandShake( cmbHandShaking.ItemIndex );
  VerificaFlow;
end;

procedure TfrmConfiguraSerial.chHardFlowClick(Sender: TObject);
begin
  Device.HardFlow := chHardFlow.Checked;
  VerificaFlow;
end;

procedure TfrmConfiguraSerial.chSoftFlowClick(Sender: TObject);
begin
  Device.SoftFlow := chSoftFlow.Checked;
  VerificaFlow;
end;

procedure TfrmConfiguraSerial.VerificaFlow;
begin
  cmbHandShaking.ItemIndex := Integer( Device.HandShake );
  chHardFlow.Checked := Device.HardFlow;
  chSoftFlow.Checked := Device.SoftFlow;
end;

end.

