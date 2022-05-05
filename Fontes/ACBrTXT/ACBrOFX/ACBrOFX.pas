{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Victor Hugo Gonzales - Panda,                   }
{  Tiago Passarella, weberdepaula@gmail.com, Leonardo Gregianin                }
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
unit ACBrOFX;

interface

uses
  SysUtils,
  Classes;

type
  TOFXItem = class
    MovType: String;
    MovDate: TDateTime;
    Value: Currency;
    ID: string;
    Document: string;
    Description: string;
  end;

type
  TACBrOFX = class(TComponent)
  private
    FOFXFile: string;
    FListItems: TList;
    procedure Clear;
    procedure Delete(iIndex: integer);
    function Add: TOFXItem;
    function InfLine(sLine: string): string;
    function FindString(sSubString, sString: string): Boolean;
    function FirstWord(S: String): String;
  protected

  public
    BankID: String;
    BranchID: string;
    AccountID: string;
    AccountType: string;
    BankName: string;
    DateStart: string;
    DateEnd: string;
    FinalBalance: String;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Import: Boolean;
    function Get(iIndex: integer): TOFXItem;
    function Count: integer;
  published
    property FileOFX: string read FOFXFile write FOFXFile;

  end;

CONST
  FILE_NOT_FOUND = 'Arquivo n�o encontrado!';

implementation

{ TACBrOFX }

function TACBrOFX.FirstWord(S: String): String;
var
  i: integer;
begin
  i := Pos('\', S);
  if i > 0 then
    Result := Copy(S, 1, i - 1)
  else
    Result := S;
end;

function TACBrOFX.Add: TOFXItem;
var
  oItem: TOFXItem;
begin
  oItem := TOFXItem.Create;
  FListItems.Add(oItem);
  Result := oItem;
end;

procedure TACBrOFX.Clear;
begin
  while FListItems.Count > 0 do
    Delete(0);
  FListItems.Clear;
end;

function TACBrOFX.Count: integer;
begin
  Result := FListItems.Count;
end;

constructor TACBrOFX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FListItems := TList.Create;
end;

procedure TACBrOFX.Delete(iIndex: integer);
begin
  TOFXItem(FListItems.Items[iIndex]).Free;
  FListItems.Delete(iIndex);
end;

destructor TACBrOFX.Destroy;
begin
  Clear;
  FListItems.Free;
  inherited Destroy;
end;

function TACBrOFX.FindString(sSubString, sString: string): Boolean;
begin
  Result := Pos(UpperCase(sSubString), UpperCase(sString)) > 0;
end;

function TACBrOFX.Get(iIndex: integer): TOFXItem;
begin
  Result := TOFXItem(FListItems.Items[iIndex]);
end;

function TACBrOFX.Import: Boolean;
var
  oFile: TStringList;
  i: integer;
  bOFX: Boolean;
  oItem: TOFXItem;
  sLine: string;
  Amount: string;
begin
  Clear;
  DateStart := '';
  DateEnd   := '';
  bOFX      := false;

  if not FileExists(FOFXFile) then
    raise Exception.Create(FILE_NOT_FOUND);

  oFile := TStringList.Create;

  try
    oFile.LoadFromFile(FOFXFile);
    i := 0;

    while i < oFile.Count do
    begin
      sLine := oFile.Strings[i];
      if FindString('<OFX>', sLine) or FindString('<OFC>', sLine) then
        bOFX := true;
      if bOFX then
      begin
        // Bank
        if FindString('<BANKID>', sLine) then
          BankID := InfLine(sLine);
        // Bank Name
        if FindString('<ORG>', sLine) then
          BankName := InfLine(sLine);
        // Agency
        if FindString('<BRANCHID>', sLine) then
          BranchID := InfLine(sLine);
        // Account
        if FindString('<ACCTID>', sLine) then
          AccountID := InfLine(sLine);
        // Account type
        if FindString('<ACCTTYPE>', sLine) then
          AccountType := InfLine(sLine);
        // Date Start
        if FindString('<DTSTART>', sLine) then
        begin
          if Trim(sLine) <> '' then
            DateStart := DateToStr(EncodeDate(StrToIntDef(Copy(InfLine(sLine), 1, 4), 0), StrToIntDef(Copy(InfLine(sLine), 5, 2), 0),
              StrToIntDef(Copy(InfLine(sLine), 7, 2), 0)));
        end;
        // Date End
        if FindString('<DTEND>', sLine) then
        begin
          if Trim(sLine) <> '' then
            DateEnd := DateToStr(EncodeDate(StrToIntDef(Copy(InfLine(sLine), 1, 4), 0), StrToIntDef(Copy(InfLine(sLine), 5, 2), 0),
              StrToIntDef(Copy(InfLine(sLine), 7, 2), 0)));
        end;
        // Final
        if FindString('<LEDGER>', sLine) or FindString('<BALAMT>', sLine) then
          FinalBalance := InfLine(sLine);
        // Movement
        if FindString('<STMTTRN>', sLine) then
        begin
          oItem := Add;
          while not FindString('</STMTTRN>', sLine) do
          begin
            Inc(i);
            sLine := oFile.Strings[i];
            if FindString('<TRNTYPE>', sLine) then
            begin
              if (InfLine(sLine) = '0') or (InfLine(sLine) = 'CREDIT') OR (InfLine(sLine) = 'DEP') then
                oItem.MovType := 'C'
              else if (InfLine(sLine) = '1') or (InfLine(sLine) = 'DEBIT') OR (InfLine(sLine) = 'XFER') then
                oItem.MovType := 'D'
              else
                oItem.MovType := 'OTHER';
            end;
            if FindString('<DTPOSTED>', sLine) then
              oItem.MovDate := EncodeDate(StrToIntDef(Copy(InfLine(sLine), 1, 4), 0), StrToIntDef(Copy(InfLine(sLine), 5, 2), 0),
                StrToIntDef(Copy(InfLine(sLine), 7, 2), 0));
            if FindString('<FITID>', sLine) then
              oItem.ID := InfLine(sLine);
            if FindString('<CHKNUM>', sLine) or FindString('<CHECKNUM>', sLine) then
              oItem.Document := InfLine(sLine);
            if FindString('<MEMO>', sLine) then
              oItem.Description := InfLine(sLine);
            if FindString('<TRNAMT>', sLine) then
            begin
              Amount := InfLine(sLine);
              Amount := StringReplace(Amount,'.',',',[rfReplaceAll]);
              oItem.Value := StrToFloat(Amount);
            end;
            if oItem.Document = '' then
              oItem.Document := FirstWord(oItem.ID);
          end;
        end;
      end;
      Inc(i);
    end;
    Result := bOFX;
  finally
    oFile.Free;
  end;
end;

function TACBrOFX.InfLine(sLine: string): string;
var
  iTemp: integer;
begin
  Result := '';
  sLine := Trim(sLine);
  if FindString('>', sLine) then
  begin
    sLine := Trim(sLine);
    iTemp := Pos('>', sLine);
    if Pos('</', sLine) > 0 then
      Result := Copy(sLine, iTemp + 1, Pos('</', sLine) - iTemp - 1)
    else
      Result := Copy(sLine, iTemp + 1, length(sLine));
  end;
end;

end.
