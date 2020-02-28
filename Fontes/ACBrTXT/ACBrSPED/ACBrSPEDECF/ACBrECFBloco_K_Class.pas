{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Juliomar Marchetti e Isaque Pinheiro            }
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

{******************************************************************************
|* Historico
|*
|* --/--/2015: Juliomar Marchetti
|*  - Cria��o.
|* 12/08/2015: Isaque Pinheiro
|*  - Distribui��o da primeira vers�o.
|* 18/08/2015: Ariel Guareschi
|*  - Alterado a gera��o do arquivo.
|* 20/08/2015: Lutzem Massao Aihara
|*  - Reestrurada a gera��o do arquivo e implementado fun��es "RegistroJXXXNew".
|* 11/09/2015 - Ariel Guareschi - Identar no padrao utilizado pela ACBr
*******************************************************************************}

{$I ACBr.inc}

unit ACBrECFBloco_K_Class;

interface

uses
  SysUtils, Classes, DateUtils, ACBrSped, ACBrECFBloco_K, ACBrECFBlocos,
  ACBrTXTClass, ACBrECFBloco_0_Class;

type
  /// TBloco_K -
  TBloco_K = class(TACBrSPED)
  private
    FBloco_0: TBloco_0;

    FRegistroK001: TRegistroK001;
    FRegistroK990: TRegistroK990;

    FRegistroK030Count: Integer;
    FRegistroK155Count: Integer;
    FRegistroK156Count: Integer;
    FRegistroK355Count: Integer;
    FRegistroK356Count: Integer;
    FRegistroK915Count: Integer;
    FRegistroK935Count: Integer;

    procedure WriteRegistroK030(RegK001: TRegistroK001);
    procedure WriteRegistroK155(RegK030: TRegistroK030);
    procedure WriteRegistroK156(RegK155: TRegistroK155);
    procedure WriteRegistroK355(RegK030: TRegistroK030);
    procedure WriteRegistroK356(RegK355: TRegistroK355);
    procedure WriteRegistroK915(RegK001: TRegistroK001);
    procedure WriteRegistroK935(RegK001: TRegistroK001);

    procedure CriaRegistros;
    procedure LiberaRegistros;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LimpaRegistros; override;

    function RegistroK001New: TRegistroK001;
    function RegistroK030New: TRegistroK030;
    function RegistroK155New: TRegistroK155;
    function RegistroK156New: TRegistroK156;
    function RegistroK355New: TRegistroK355;
    function RegistroK356New: TRegistroK356;
    function RegistroK915New: TRegistroK915;
    function RegistroK935New: TRegistroK935;

    procedure WriteRegistroK001;
    procedure WriteRegistrok990;

    property Bloco_0: TBloco_0 read FBloco_0 write FBloco_0;
    property RegistroK001: TRegistroK001     read FRegistroK001 write FRegistroK001;
    property RegistroK990: TRegistroK990     read FRegistroK990 write FRegistroK990;

    property RegistroK030Count: Integer read FRegistroK030Count write FRegistroK030Count;
    property RegistroK155Count: Integer read FRegistroK155Count write FRegistroK155Count;
    property RegistroK156Count: Integer read FRegistroK156Count write FRegistroK156Count;
    property RegistroK355Count: Integer read FRegistroK355Count write FRegistroK355Count;
    property RegistroK356Count: Integer read FRegistroK356Count write FRegistroK356Count;
    property RegistroK915Count: Integer read FRegistroK915Count write FRegistroK915Count;
    property RegistroK935Count: Integer read FRegistroK935Count write FRegistroK935Count;
  end;


implementation

uses
  ACBrTXTUtils, StrUtils;

{ TBloco_K }

constructor TBloco_K.Create;
begin
  inherited Create;
  CriaRegistros;
end;

procedure TBloco_K.CriaRegistros;
begin
   FRegistroK001 := TRegistroK001.Create;
   FRegistroK990 := TRegistroK990.Create;

   FRegistroK030Count := 0;
   FRegistroK155Count := 0;
   FRegistroK156Count := 0;
   FRegistroK355Count := 0;
   FRegistroK356Count := 0;

   FRegistrok990.QTD_LIN := 0;
end;

destructor TBloco_K.Destroy;
begin
   LiberaRegistros;
   inherited;
end;

procedure TBloco_K.LiberaRegistros;
begin
   FRegistroK001.Free;
   FRegistroK990.Free;
end;

procedure TBloco_K.LimpaRegistros;
begin
  /// Limpa os Registros
  LiberaRegistros;
  Conteudo.Clear;

  /// Recriar os Registros Limpos
  CriaRegistros;
end;

function TBloco_K.RegistroK001New: TRegistroK001;
begin
  Result := FRegistroK001;
end;

function TBloco_K.RegistroK030New: TRegistroK030;
begin
  Result := FRegistroK001.RegistroK030.New()
end;

function TBloco_K.RegistroK155New: TRegistroK155;
var
  UK030: TRegistroK030;
  UK030Count: Integer;
begin
  UK030Count := FRegistroK001.RegistroK030.Count -1;
  if UK030Count = -1 then
    raise Exception.Create('O registro K155 deve ser filho do registro K030, e n�o existe nenhum K030 pai!');

  UK030  := FRegistroK001.RegistroK030.Items[UK030Count];
  Result := UK030.RegistroK155.New(UK030);
end;

function TBloco_K.RegistroK156New: TRegistroK156;
var
  UK155: TRegistroK155;
  UK030Count: integer;
  UK155Count: integer;
begin
  UK030Count := FRegistroK001.RegistroK030.Count -1;
  UK155Count := FRegistroK001.RegistroK030.Items[UK030Count].RegistroK155.Count -1;
  if UK155Count = -1 then
    raise Exception.Create('O registro 1110 deve ser filho do registro 1105, e n�o existe nenhum 1105 pai!');

  UK155  := FRegistroK001.RegistroK030.Items[UK030Count].RegistroK155.Items[UK155Count];
  Result := UK155.RegistroK156.New();
end;

function TBloco_K.RegistroK355New: TRegistroK355;
var
  UK030: TRegistroK030;
  UK030Count: Integer;
begin
  UK030Count := FRegistroK001.RegistroK030.Count -1;
  if UK030Count = -1 then
    raise Exception.Create('O registro K355 deve ser filho do registro K030, e n�o existe nenhum K030 pai!');

  UK030  := FRegistroK001.RegistroK030.Items[UK030Count];
  Result := UK030.RegistroK355.New(UK030);

end;

function TBloco_K.RegistroK356New: TRegistroK356;
var
  UK355: TRegistroK355;
  UK030Count: integer;
  UK355Count: integer;
begin
  UK030Count := FRegistroK001.RegistroK030.Count -1;
  UK355Count := FRegistroK001.RegistroK030.Items[UK030Count].RegistroK355.Count -1;
  if UK355Count = -1 then
    raise Exception.Create('O registro 1110 deve ser filho do registro 1105, e n�o existe nenhum 1105 pai!');

  UK355  := FRegistroK001.RegistroK030.Items[UK030Count].RegistroK355.Items[UK355Count];
  Result := UK355.RegistroK356.New();
end;

function TBloco_K.RegistroK915New: TRegistroK915;
begin
  Result := FRegistroK001.RegistroK915.New();
end;

function TBloco_K.RegistroK935New: TRegistroK935;
begin
  Result := FRegistroK001.RegistroK935.New();
end;

procedure TBloco_K.WriteRegistroK001;
begin
  if Assigned(RegistroK001) then
  begin
    with RegistroK001 do
    begin
      Check(((IND_DAD = idComDados) or (IND_DAD = idSemDados)), '(K-K001) Na abertura do bloco, deve ser informado o n�mero 0 ou 1!');

      Add( LFill('K001') +
           LFill( Integer(IND_DAD), 1) );

      if (IND_DAD = idComDados) then
      begin
        WriteRegistroK030(RegistroK001);
        WriteRegistroK915(RegistroK001);
        WriteRegistroK935(RegistroK001);
      end;

      FRegistroK990.QTD_LIN:= FRegistroK990.QTD_LIN + 1;
    end;
  end;
end;

procedure TBloco_K.WriteRegistroK030(RegK001: TRegistroK001);
var
  intFor: integer;
begin
  if Assigned(RegK001.RegistroK030) then
  begin
    for intFor := 0 to RegK001.RegistroK030.Count - 1 do
    begin
      with RegK001.RegistroK030.Items[intFor] do
      begin
        Add( LFill('K030') +
             LFill(DT_INI) +
             LFill(DT_FIN) +
             LFill(PER_APUR) );
      end;

      WriteRegistroK155(RegK001.RegistroK030.Items[intFor]);
      WriteRegistroK355(RegK001.RegistroK030.Items[intFor]);

      FRegistroK990.QTD_LIN := FRegistroK990.QTD_LIN + 1;
    end;

    FRegistroK030Count := FRegistroK030Count + RegK001.RegistroK030.Count
  end;
end;

procedure TBloco_K.WriteRegistroK155(RegK030: TRegistroK030);
var
  intFor: integer;
begin
  if Assigned(RegK030.RegistroK155) then
  begin
    for intFor := 0 to RegK030.RegistroK155.Count - 1 do
    begin
      with RegK030.RegistroK155.Items[intFor] do
      begin
        Add( LFill('K155') +
             LFill(COD_CTA) +
             LFill(COD_CCUS) +
             LFill(VL_SLD_INI, 19, 2) +
             LFill(IND_VL_SLD_INI,0) +
             LFill(VL_DEB, 19, 2) +
             LFill(VL_CRED, 19, 2) +
             LFill(VL_SLD_FIN, 19, 2) +
             LFill(IND_VL_SLD_FIN,0) );
      end;
      WriteRegistroK156(RegK030.RegistroK155.Items[intFor]);

      FRegistroK990.QTD_LIN := FRegistroK990.QTD_LIN + 1;
    end;

    FRegistroK155Count := FRegistroK155Count + RegK030.RegistroK155.Count;
  end;
end;

procedure TBloco_K.WriteRegistroK156(RegK155: TRegistroK155);
var
  intFor: integer;
begin
  if Assigned(RegK155.RegistroK156) then
  begin
    for intFor := 0 to RegK155.RegistroK156.Count - 1 do
    begin
      with RegK155.RegistroK156.Items[intFor] do
      begin
        Add( LFill('K156') +
             LFill(COD_CTA_REF) +
             LFill(VL_SLD_INI, 19, 2) +
             LFill(IND_VL_SLD_INI,0) +
             LFill(VL_DEB, 19, 2) +
             LFill(VL_CRED, 19, 2) +
             LFill(VL_SLD_FIN, 19, 2) +
             LFill(IND_VL_SLD_FIN,0) );
      end;
      FRegistroK990.QTD_LIN := FRegistroK990.QTD_LIN + 1;

    end;
    FRegistroK156Count := FRegistroK156Count + RegK155.RegistroK156.Count;

  end;
end;

procedure TBloco_K.WriteRegistroK355(RegK030: TRegistroK030);
var
  intFor: integer;
begin
  if Assigned(RegK030.Registrok355) then
  begin
    for intFor := 0 to RegK030.Registrok355.Count - 1 do
    begin
      with RegK030.Registrok355.Items[intFor] do
      begin
        Add( LFill('K355') +
             LFill(COD_CTA) +
             LFill(COD_CCUS) +
             LFill(VL_SLD_FIN, 19, 2) +
             LFill(IND_VL_SLD_FIN,0) );
      end;
      // Registros Filhos
      WriteRegistroK356(RegK030.Registrok355.Items[intFor]);

      FRegistroK990.QTD_LIN := FRegistroK990.QTD_LIN + 1;
    end;

    FRegistrok355Count := FRegistrok355Count + RegK030.Registrok355.Count;
  end;
end;

procedure TBloco_K.WriteRegistroK356(RegK355: TRegistroK355);
var
  intFor: integer;
begin
  if Assigned(RegK355.RegistroK356) then
  begin
    for intFor := 0 to RegK355.RegistroK356.Count - 1 do
    begin
      with RegK355.RegistroK356.Items[intFor] do
      begin
        Add( LFill('K356') +
             LFill(COD_CTA_REF) +
             LFill(VL_SLD_FIN, 19, 2) +
             LFill(IND_VL_SLD_FIN,0) );
      end;

      FRegistroK990.QTD_LIN := FRegistroK990.QTD_LIN + 1;
    end;

    FRegistroK356Count := FRegistroK356Count + RegK355.RegistroK356.Count;
  end;
end;

procedure TBloco_K.WriteRegistroK915(RegK001: TRegistroK001);
var
  intFor: integer;
begin
  if Assigned(RegK001.RegistroK915) then
  begin
    for intFor := 0 to RegK001.RegistroK915.Count - 1 do
    begin
      with RegK001.RegistroK915.Items[intFor] do
      begin
        Add( LFill('K915') +
             LFill(PER_APUR) +
             LFill(COD_CTA) +
             LFill(COD_CCUS) +
             LFill(ID_REGRA) +
             LFill(VL_SLD_INI_ESP, 19, 2) +
             LFill(IND_VL_SLD_INI_ESP,0) +
             LFill(VL_DEB_ESP, 19, 2) +
             LFill(VL_CRED_ESP, 19, 2) +
             LFill(VL_SLD_FIN_ESP, 19, 2) +
             LFill(IND_VL_SLD_FIN_ESP,0) +
             LFill(SLD_INI_PRE, 19, 2) +
             LFill(IND_SLD_INI_PRE,0) +
             LFill(VL_DEB_PRE, 19, 2) +
             LFill(VL_CRED_PRE, 19, 2) +
             LFill(SLD_FIN_PRE, 19, 2) +
             LFill(IND_SLD_FIN_PRE,0) +
             LFill(JUSTIFICATIVA) );
      end;
      FRegistroK990.QTD_LIN := FRegistroK990.QTD_LIN + 1;
    end;
    FRegistroK915Count := FRegistroK915Count + RegK001.RegistroK915.Count
  end;
end;

procedure TBloco_K.WriteRegistroK935(RegK001: TRegistroK001);
var
  intFor: integer;
begin
  if Assigned(RegK001.RegistroK935) then
  begin
    for intFor := 0 to RegK001.RegistroK935.Count - 1 do
    begin
      with RegK001.RegistroK935.Items[intFor] do
      begin
        Add( LFill('K935') +
             LFill(PER_APUR) +
             LFill(COD_CTA) +
             LFill(COD_CCUS) +
             LFill(ID_REGRA) +
             LFill(VL_SLD_FIN_ESP, 19, 2) +
             LFill(IND_VL_SLD_FIN_ESP,0) +
             LFill(SLD_FIN_PRE, 19, 2) +
             LFill(IND_SLD_FIN_PRE,0) +
             LFill(JUSTIFICATIVA) );
      end;
      FRegistroK990.QTD_LIN := FRegistroK990.QTD_LIN + 1;
    end;
    FRegistroK935Count := FRegistroK935Count + RegK001.RegistroK935.Count
  end;
end;

procedure TBloco_K.WriteRegistrok990;
begin
  if Assigned(FRegistroK990) then
  begin
    with FRegistroK990 do
    begin
      QTD_LIN := QTD_LIN + 1;

      Add( LFill('K990') +
           LFill(QTD_LIN, 0) );
    end;
  end;
end;

end.
