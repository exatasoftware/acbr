{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
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

unit pcteModeloCTe;

interface

uses
  SysUtils, Classes,
{$IFNDEF VER130}
  Variants,
{$ENDIF}
  pcnAuxiliar, pcnConversao, pcteCTe, pcteCTeW, pcteConversaoCTe, ACBrUtil;

procedure ModeloCTe;

implementation

procedure ModeloCTe;
var
  CTe: TCTe;
  CTeW: TCTeW;
  i{, j, k}: Integer;
//  s: String;
  ReferenciadaTipoCTe: Boolean;
  Opcao1: Boolean;
begin

  // IMPORTANTE: Os la�os For - Next codificados nesses modelo s�o meramente descritivos.
  //             Esse arquivo � apenas um modelo e deve ser adaptado conforme as suas necessidades.

  Opcao1 := True;      // Esta variavel esta sendo usada nesse modelo para indicar os locais onde
                       // devem ser tomadas deciss�es por parte do programador conforme a regras
                       // de negocio de cada cliente.

  CTe := TCTe.create;

//  s := CTe.infCTe.ID;  // ATEN��O: Esse campo representa a chave da CTe
                       //          N�o utilize esse campo para escrita (apenas para leitura)
                       //          pois a chave � gerada automaticamente no momento da gera��o do arquivo

  (* ----------------------------------------------------------------------------------------------------------------- *)
  (* TAG de grupo das informa��es de identifica��o do CT-e  - <ide> - Ocorr�ncia 1-1                                   *)
  (* ----------------------------------------------------------------------------------------------------------------- *)

  CTe.Ide.cUF := 0;                     // - C�digo da UF do emitente do Documento Fiscal - Tabela do IBGE
                                        //     Voc� pode utilizar a fun��o UFparaCodigo caso n�o s�iba o c�digo da UF
                                        //     ex: CTe.Ide.cUF := UFparaCodigo(MinhaUF);
  CTe.Ide.cCT := -1;                    // - C�digo Num�rico que comp�e a Chave de Acesso
                                        //     Se nenhum valor for informado ser� atribuido um valor aleat�rio
                                        //     Se for informado o valor -1; ser� gerado um valor baseado no numero da CTe
  CTe.ide.CFOP := 0;                    // - C�digo Fiscal de Opera��es e Presta��es
  CTe.Ide.natOp := '';                  // - Descri��o da Natureza da Opera��o
  CTe.Ide.forPag := fpPago;             // - Indicador da forma de pagamento (*)
                                        //         (0)=fpPago
                                        //         (1)=fpAPagar
                                        //         (2)=fpOutras
  CTe.Ide.modelo := 57;                 // - C�digo do Modelo do Documento Fiscal Utilizar o c�digo 57 para identifica��o do CT-e.
  CTe.Ide.serie := 0;                   // - S�rie do Documento Fiscal, informar 0 (zero) para s�rie �nica.
  CTe.Ide.nCT := 0;                     // - N�mero do Documento Fiscal
  CTe.Ide.dhEmi := now;                 // - Data e Hora de emiss�o do Documento Fiscal
  CTe.Ide.tpImp := tiRetrato;           // - Formato de Impress�o do DACTe (*)
                                        //         (1)=tiRetrato
                                        //         (2)=tiPaisagem
  CTe.Ide.tpEmis := teNormal;           // - Forma de Emiss�o do CT-e (*)
                                        //         (1)=teNormal
                                        //         (4)=teEPEC
                                        //         (5)=teFSDA
                                        //         (7)=teSVCRS
                                        //         (8)=teSVCSP
  CTe.Ide.tpAmb := taProducao;          // - Identifica��o do Ambiente (*)
                                        //         (1)=Produ��o
                                        //         (2)=Homologa��o
  CTe.Ide.tpCTe := tcNormal;            // - Tipo do Documento Fiscal (*)
                                        //         (0)=tcNormal
                                        //         (1)=tcComplemento
                                        //         (2)=tcAnulacao
                                        //         (3)=tcSubstituto
  CTe.Ide.procEmi :=                    // - Processo de emiss�o do CT-e (*)
    peAplicativoContribuinte;           //         (0)=peAplicativoContribuinte      - emiss�o do CT-e com aplicativo do contribuinte;
                                        //         (1)=peAvulsaFisco                 - emiss�o do CT-e avulsa pelo Fisco;
                                        //         (2)=peAvulsaContribuinte          - emiss�o do CT-e avulsa, pelo contribuinte com seu certificado digital, atrav�s do site do Fisco;
                                        //         (3)=peContribuinteAplicativoFisco - emiss�o do CT-e pelo contribuinte com aplicativo fornecido pelo Fisco.
  CTe.Ide.verProc := '';                // - Vers�o do Processo de emiss�o do CT-e
  ReferenciadaTipoCTe := True;          // TAG - Informa��o das NF/NF-e referenciadas - <NFref> - Ocorr�ncia 0-N ********
  if ReferenciadaTipoCTe then
  begin                                 // Se a nota referenciada for um CTe preencher o campo abaixo:
    CTe.Ide.refCTe := '';               // - Chave de acesso do CT-e referenciado
  end;
  CTe.Ide.cMunEnv := 0;                 // - C�digo do Municipio de Envio
  CTe.Ide.xMunEnv := '';                // - Nome do Municipio de Envio
  CTe.Ide.UFEnv   := '';                // - UF do Municipio de Envio
  CTe.Ide.modal   := mdRodoviario;      // - Modal
                                        //   mdRodoviario
                                        //   mdAereo
                                        //   mdAquaviario
                                        //   mdFerroviario
                                        //   mdDutoviario
  CTe.Ide.tpServ := tsNormal;           // - Tipo de Servi�o
                                        //   tsNormal
                                        //   tsSubcontratacao
                                        //   tsRedespacho
                                        //   tsIntermediario
  CTe.Ide.cMunIni := 0;                 // - C�digo do Municipio de Inicio da Presta��o
  CTe.Ide.xMunIni := '';                // - Nome do Municipio de Inicio da Presta��o
  CTe.Ide.UFIni   := '';                // - UF do Municipio de Inicio da Presta��o
  CTe.Ide.cMunFim := 0;                 // - C�digo do Municipio de Fim da Presta��o
  CTe.Ide.xMunFim := '';                // - Nome do Municipio de Fim da Presta��o
  CTe.Ide.UFFim   := '';                // - UF do Municipio de Fim da Presta��o
  CTe.Ide.retira  := rtSim;             // - Indica se o Destinat�rio vai retirar a caraga ou n�o
                                        //   rtSim
                                        //   rtNao
  CTe.Ide.xdetretira := '';             // - Detalhamento da retirada da carga

  if Opcao1 then
  begin
    // Se o Tomador do Servi�o do CTe for <> de Outros
    CTe.Ide.Toma03.Toma := tmRemetente;   // - Indica que � o tomador do Servi�o
                                          //   tmRemetente
                                          //   tmExpedidor
                                          //   tmRecebedor
                                          //   tmDestinatario
  end
  else
  begin
    // Se o Tomador do Servi�o do CTe for = a Outros
    CTe.Ide.Toma4.Toma := tmOutros;
    CTe.Ide.Toma4.CNPJCPF := '';
    CTe.Ide.Toma4.IE := '';
    CTe.Ide.Toma4.xNome := '';
    CTe.Ide.Toma4.xFant := '';
    CTe.Ide.Toma4.fone := '';
    CTe.Ide.Toma4.EnderToma.xLgr := '';
    CTe.Ide.Toma4.EnderToma.nro := '';
    CTe.Ide.Toma4.EnderToma.xCpl := '';
    CTe.Ide.Toma4.EnderToma.xBairro := '';
    CTe.Ide.Toma4.EnderToma.cMun := 0;
    CTe.Ide.Toma4.EnderToma.xMun := '';
    CTe.Ide.Toma4.EnderToma.CEP := 0;
    CTe.Ide.Toma4.EnderToma.UF := '';
    CTe.Ide.Toma4.EnderToma.cPais := 0;
    CTe.Ide.Toma4.EnderToma.xPais := '';
  end;

  if Opcao1 then
  begin
    CTe.Ide.dhCont := Now;
    CTe.Ide.xJust  := '';
  end;

  CTe.compl.xCaracAd  := '';
  CTe.compl.xCaracSer := '';
  CTe.compl.xEmi      := '';
  CTe.compl.fluxo.xOrig := '';

  if Opcao1 then
  begin
    with CTe.compl.fluxo.pass.New do
    begin
      xPass := '';
    end;
  end;
  CTe.compl.fluxo.xDest := '';
  CTe.compl.fluxo.xRota := '';

  CTe.compl.Entrega.TipoData := tdSemData;
  case CTe.compl.Entrega.TipoData of
    tdSemData: CTe.compl.Entrega.semData.tpPer := tdSemData;
    tdNaData,
    tdAteData,
    tdApartirData: begin
                     CTe.compl.Entrega.comData.tpPer := CTe.compl.Entrega.TipoData;
                     CTe.compl.Entrega.comData.dProg := Date;
                   end;
    tdNoPeriodo: begin
                   CTe.compl.Entrega.noPeriodo.tpPer := tdNoPeriodo;
                   CTe.compl.Entrega.noPeriodo.dIni  := Date;
                   CTe.compl.Entrega.noPeriodo.dFim  := Date;
                 end;
  end;

  CTe.compl.Entrega.TipoHora := thSemHorario;
  case CTe.compl.Entrega.TipoHora of
    thSemHorario: CTe.compl.Entrega.semHora.tpHor := thSemHorario;
    thNoHorario,
    thAteHorario,
    thApartirHorario: begin
                        CTe.compl.Entrega.comHora.tpHor := CTe.compl.Entrega.TipoHora;
                        CTe.compl.Entrega.comHora.hProg := Time;
                      end;
    thNoIntervalo: begin
                     CTe.compl.Entrega.noInter.tpHor := thNoIntervalo;
                     CTe.compl.Entrega.noInter.hIni  := Time;
                     CTe.compl.Entrega.noInter.hFim  := Time;
                   end;
  end;

  CTe.compl.origCalc := '';
  CTe.compl.destCalc := '';
  CTe.compl.xObs     := '';

  if Opcao1 then
  begin
    with CTe.compl.ObsCont.New do
    begin
      xCampo := '';
      xTexto := '';
    end;
  end;

  (* ----------------------------------------------------------------------------------------------------------------- *)
  (* TAG de grupo de identifica��o do emitente do CT-e  - <emit> - Ocorr�ncia 1-1                                      *)
  (* ----------------------------------------------------------------------------------------------------------------- *)
  CTe.Emit.CNPJ := '';              // - CNPJ do emitente
  CTe.Emit.xNome := '';             // - Raz�o Social ou Nome do emitente
  CTe.Emit.xFant := '';             // - Nome fantasia
  CTe.Emit.IE := '';                // - Inscri��o Estadual do emitente
  CTe.Emit.enderEmit.xLgr := '';    // - Logradouro
  CTe.Emit.enderEmit.nro := '';     // - N�mero
  CTe.Emit.enderEmit.xCpl := '';    // - Complemento
  CTe.Emit.enderEmit.xBairro := ''; // - Bairro
  CTe.Emit.enderEmit.cMun := 0;     // - C�digo do munic�pio (Tabela do IBGE - '9999999' para opera��es com o exterior))
  CTe.Emit.enderEmit.xMun := '';    // - Nome do munic�pio   ('EXTERIOR' para opera��es com o exterior)
  CTe.Emit.enderEmit.UF := '';      // - Sigla da UF         ('EX' para opera��es com o exterior.)
  CTe.Emit.enderEmit.CEP := 0;      // - C�digo do CEP
  CTe.Emit.enderEmit.fone := '';    // - Telefone            ( C�digo DDD + n�mero do telefone. )

  (* ----------------------------------------------------------------------------------------------------------------- *)
  (* TAG de grupo de identifica��o do remetente do CT-e  - <rem> - Ocorr�ncia 0-1                                      *)
  (* ----------------------------------------------------------------------------------------------------------------- *)
  CTe.Rem.CNPJCPF := '';           // - CNPJ/CPF do remetente
  CTe.Rem.xNome := '';             // - Raz�o Social ou Nome
  CTe.Rem.xFant := '';             // - Nome fantasia
  CTe.Rem.IE := '';                // - Inscri��o Estadual
  CTe.Rem.fone := '';              // - Telefone            ( C�digo DDD + n�mero do telefone. )
  CTe.Rem.email := '';             // - e-mail
  CTe.Rem.enderReme.xLgr := '';    // - Logradouro
  CTe.Rem.enderReme.nro := '';     // - N�mero
  CTe.Rem.enderReme.xCpl := '';    // - Complemento
  CTe.Rem.enderReme.xBairro := ''; // - Bairro
  CTe.Rem.enderReme.cMun := 0;     // - C�digo do munic�pio (Tabela do IBGE - '9999999' para opera��es com o exterior))
  CTe.Rem.enderReme.xMun := '';    // - Nome do munic�pio   ('EXTERIOR' para opera��es com o exterior)
  CTe.Rem.enderReme.UF := '';      // - Sigla da UF         ('EX' para opera��es com o exterior.)
  CTe.Rem.enderReme.CEP := 0;      // - C�digo do CEP

  (* ----------------------------------------------------------------------------------------------------------------- *)
  (* TAG de grupo de identifica��o do Local de coleta - <locColeta> - Ocorr�ncia 0-1                                   *)
  (* ----------------------------------------------------------------------------------------------------------------- *)

                              // Informar os valores desse grupo somente se o  endere�o de
                              // retirada for diferente do endere�o do remetente.
                              // Assim se locColeta.xLgr <> '' o gerador grava o grupo no XML

  CTe.Rem.locColeta.CNPJCPF := ''; // - CNPJ/CPF
  CTe.Rem.locColeta.xNome := '';   // - Nome
  CTe.Rem.locColeta.xLgr := '';    // - Logradouro
  CTe.Rem.locColeta.nro := '';     // - N�mero
  CTe.Rem.locColeta.xCpl := '';    // - Complemento
  CTe.Rem.locColeta.xBairro := ''; // - Bairro
  CTe.Rem.locColeta.cMun := 0;     // - C�digo do munic�pio (Tabela do IBGE - '9999999' para opera��es com o exterior))
  CTe.Rem.locColeta.xMun := '';    // - Nome do munic�pio   ('EXTERIOR' para opera��es com o exterior)
  CTe.Rem.locColeta.UF := '';      // - Sigla da UF         ('EX' para opera��es com o exterior.)

  (* ----------------------------------------------------------------------------------------------------------------- *)
  (* TAG de grupo de identifica��o do destinat�rio do CT-e  - <dest> - Ocorr�ncia 0-1                                  *)
  (* ----------------------------------------------------------------------------------------------------------------- *)
  CTe.Dest.CNPJCPF := '';           // - CNPJ/CPF do Destinat�rio
  CTe.Dest.xNome := '';             // - Raz�o Social ou Nome
  CTe.Dest.IE := '';                // - Inscri��o Estadual
  CTe.Dest.fone := '';              // - Telefone            ( C�digo DDD + n�mero do telefone. )
  CTe.Dest.email := '';             // - e-mail
  CTe.Dest.ISUF := '';              // - Inscri��o no SUFRAMA
  CTe.Dest.enderDest.xLgr := '';    // - Logradouro
  CTe.Dest.enderDest.nro := '';     // - N�mero
  CTe.Dest.enderDest.xCpl := '';    // - Complemento
  CTe.Dest.enderDest.xBairro := ''; // - Bairro
  CTe.Dest.enderDest.cMun := 0;     // - C�digo do munic�pio (Tabela do IBGE - '9999999' para opera��es com o exterior))
  CTe.Dest.enderDest.xMun := '';    // - Nome do munic�pio   ('EXTERIOR' para opera��es com o exterior)
  CTe.Dest.enderDest.UF := '';      // - Sigla da UF         ('EX' para opera��es com o exterior.)
  CTe.Dest.enderDest.CEP := 0;      // - C�digo do CEP

  (* ----------------------------------------------------------------------------------------------------------------- *)
  (* TAG de grupo de identifica��o do Local de Entrega - <locEnt> - Ocorr�ncia 0-1                                   *)
  (* ----------------------------------------------------------------------------------------------------------------- *)

                              // Informar os valores desse grupo somente se o  endere�o de
                              // Entrega for diferente do endere�o do Destinat�rio.
                              // Assim se locEnt.xLgr <> '' o gerador grava o grupo no XML

  CTe.Dest.locEnt.CNPJCPF := ''; // - CNPJ/CPF
  CTe.Dest.locEnt.xNome := '';   // - Nome
  CTe.Dest.locEnt.xLgr := '';    // - Logradouro
  CTe.Dest.locEnt.nro := '';     // - N�mero
  CTe.Dest.locEnt.xCpl := '';    // - Complemento
  CTe.Dest.locEnt.xBairro := ''; // - Bairro
  CTe.Dest.locEnt.cMun := 0;     // - C�digo do munic�pio (Tabela do IBGE - '9999999' para opera��es com o exterior))
  CTe.Dest.locEnt.xMun := '';    // - Nome do munic�pio   ('EXTERIOR' para opera��es com o exterior)
  CTe.Dest.locEnt.UF := '';      // - Sigla da UF         ('EX' para opera��es com o exterior.)

  (* ----------------------------------------------------------------------------------------------------------------- *)
  (* TAG de grupo de identifica��o do Expedidor do CT-e  - <Exped> - Ocorr�ncia 0-1                                  *)
  (* ----------------------------------------------------------------------------------------------------------------- *)
  CTe.Exped.CNPJCPF := '';           // - CNPJ/CPF do Expedidor
  CTe.Exped.xNome := '';             // - Raz�o Social ou Nome
  CTe.Exped.IE := '';                // - Inscri��o Estadual
  CTe.Exped.fone := '';              // - Telefone            ( C�digo DDD + n�mero do telefone. )
  CTe.Exped.email := '';             // - e-mail
  CTe.Exped.enderExped.xLgr := '';    // - Logradouro
  CTe.Exped.enderExped.nro := '';     // - N�mero
  CTe.Exped.enderExped.xCpl := '';    // - Complemento
  CTe.Exped.enderExped.xBairro := ''; // - Bairro
  CTe.Exped.enderExped.cMun := 0;     // - C�digo do munic�pio (Tabela do IBGE - '9999999' para opera��es com o exterior))
  CTe.Exped.enderExped.xMun := '';    // - Nome do munic�pio   ('EXTERIOR' para opera��es com o exterior)
  CTe.Exped.enderExped.UF := '';      // - Sigla da UF         ('EX' para opera��es com o exterior.)
  CTe.Exped.enderExped.CEP := 0;      // - C�digo do CEP

  (* ----------------------------------------------------------------------------------------------------------------- *)
  (* TAG de grupo de identifica��o do Recebedor do CT-e  - <Receb> - Ocorr�ncia 0-1                                  *)
  (* ----------------------------------------------------------------------------------------------------------------- *)
  CTe.Receb.CNPJCPF := '';           // - CNPJ/CPF do Recebedor
  CTe.Receb.xNome := '';             // - Raz�o Social ou Nome
  CTe.Receb.IE := '';                // - Inscri��o Estadual
  CTe.Receb.fone := '';              // - Telefone            ( C�digo DDD + n�mero do telefone. )
  CTe.Receb.email := '';             // - e-mail
  CTe.Receb.enderReceb.xLgr := '';    // - Logradouro
  CTe.Receb.enderReceb.nro := '';     // - N�mero
  CTe.Receb.enderReceb.xCpl := '';    // - Complemento
  CTe.Receb.enderReceb.xBairro := ''; // - Bairro
  CTe.Receb.enderReceb.cMun := 0;     // - C�digo do munic�pio (Tabela do IBGE - '9999999' para opera��es com o exterior))
  CTe.Receb.enderReceb.xMun := '';    // - Nome do munic�pio   ('EXTERIOR' para opera��es com o exterior)
  CTe.Receb.enderReceb.UF := '';      // - Sigla da UF         ('EX' para opera��es com o exterior.)
  CTe.Receb.enderReceb.CEP := 0;      // - C�digo do CEP

  //
  //  Valores da Presta��o de Servi�o
  //
  CTe.vPrest.vTPrest := 0.0;
  CTe.vPrest.vRec    := 0.0;

  //
  // Rela��o dos Componentes da Presta��o de Servi�o
  //
  for i := 0 to 1 do
  begin
    with CTe.vPrest.comp.New do
    begin
      xNome := '';
      vComp := 0.0;
    end;
  end;

  //
  //  Valores dos Impostos
  //
  CTe.Imp.ICMS.SituTrib := cst00;
  case CTe.Imp.ICMS.SituTrib of
   cst00: begin
            CTe.Imp.ICMS.SituTrib     := cst00;
            CTe.Imp.ICMS.ICMS00.CST   := cst00; // Tributa��o Normal ICMS
            CTe.Imp.ICMS.ICMS00.vBC   := 0.0;
            CTe.Imp.ICMS.ICMS00.pICMS := 0.0;
            CTe.Imp.ICMS.ICMS00.vICMS := 0.0;
          end;
   cst20: begin
            CTe.Imp.ICMS.SituTrib      := cst20;
            CTe.Imp.ICMS.ICMS20.CST    := cst20; // Tributa��o com BC reduzida do ICMS
            CTe.Imp.ICMS.ICMS20.pRedBC := 0.0;
            CTe.Imp.ICMS.ICMS20.vBC    := 0.0;
            CTe.Imp.ICMS.ICMS20.pICMS  := 0.0;
            CTe.Imp.ICMS.ICMS20.vICMS  := 0.0;
          end;
   cst40: begin
            CTe.Imp.ICMS.SituTrib  := cst40;
            CTe.Imp.ICMS.ICMS45.CST := cst40; // ICMS Isento
          end;
   cst41: begin
            CTe.Imp.ICMS.SituTrib  := cst41;
            CTe.Imp.ICMS.ICMS45.CST := cst41; // ICMS n�o Tributada
          end;
   cst51: begin
            CTe.Imp.ICMS.SituTrib  := cst51;
            CTe.Imp.ICMS.ICMS45.CST := cst51; // ICMS diferido
          end;
   cst60: begin
            CTe.Imp.ICMS.SituTrib          := cst60;
            CTe.Imp.ICMS.ICMS60.CST        := cst60; // Tributa��o atribuida ao tomador ou 3. por ST
            CTe.Imp.ICMS.ICMS60.vBCSTRet   := 0.0;
            CTe.Imp.ICMS.ICMS60.pICMSSTRet := 0.0;
            CTe.Imp.ICMS.ICMS60.vICMSSTRet := 0.0;
            CTe.Imp.ICMS.ICMS60.vCred      := 0.0;
          end;
   cst90: begin
            CTe.Imp.ICMS.SituTrib      := cst90;
            CTe.Imp.ICMS.ICMS90.CST    := cst90; // ICMS Outros
            CTe.Imp.ICMS.ICMS90.pRedBC := 0.0;
            CTe.Imp.ICMS.ICMS90.vBC    := 0.0;
            CTe.Imp.ICMS.ICMS90.pICMS  := 0.0;
            CTe.Imp.ICMS.ICMS90.vICMS  := 0.0;
            CTe.Imp.ICMS.ICMS90.vCred  := 0.0;
          end;
  end;

  // Valor Total dos Tributos
  CTe.imp.vTotTrib := 0.0;

  // Obs do Contribuinte
  if (CTe.imp.vTotTrib <> 0.0) then
  begin
    with CTe.compl.ObsCont.New do
    begin
      xCampo := 'Lei da Transparencia';
      xTexto := 'O valor aproximado de tributos incidentes sobre o pre�o deste servico e de R$ ' +
                FormatFloat(',0.00', CTe.imp.vTotTrib) + ' (' +
                FormatFloat(',0.00', 0.0) + '%) ' +
                'Fonte: IBPT';
    end;
  end;

  case CTe.Ide.tpCTe of
    tcNormal,
    tcSubstituto: begin
                    //  Informa��es da Carga
                    CTe.infCTeNorm.infCarga.vCarga  := 0.0;
                    CTe.infCTeNorm.infCarga.proPred := '';
                    CTe.infCTeNorm.infCarga.xOutCat := '';
                    // UnidMed = (uM3,uKG, uTON, uUNIDADE, uLITROS);
                    with CTe.infCTeNorm.infCarga.InfQ.New do
                    begin
                      cUnid  := uKg;
                      tpMed  := 'Kg';
                      qCarga := 0.0;
                    end;
                    //  Informa��es da Seguradora
                    with CTe.infCTeNorm.seg.New do
                    begin
                      respSeg := rsRemetente;
                      //respSeg := rsExpedidor;
                      //respSeg := rsRecebedor;
                      //respSeg := rsDestinatario;
                      //respSeg := rsEmitenteCTe;
                      //respSeg := rsTomadorServico;
                      xSeg  := '';
                      nApol := '';
                      nAver := '';
                    end;
                    //  Dados do Modal Rodovi�rio
                    CTe.infCTeNorm.rodo.RNTRC := '';
                    CTe.infCTeNorm.Rodo.dPrev := Date;
                    CTe.infCTeNorm.Rodo.Lota := ltNao;
                    //CTe.infCTeNorm.Rodo.Lota := ltSim;
                    CTe.infCTeNorm.Rodo.CIOT := '';
                  end;
    tcComplemento: begin
                     CTe.infCteComp.chave := '';
                   end;
    tcAnulacao: begin
                  CTe.infCTeAnu.chCTe := '';
                  CTe.infCTeAnu.dEmi  := Date;
                end;
  end;

  for i := 0 to 1 do
  begin
    with CTe.autXML.New do
    begin
      CNPJCPF := '';
    end;
  end;

  (* ----------------------------------------------------------------------------------------------------------------- *)
  (* TAG do Assinatura - <signature>                                                                                   *)
  (* ----------------------------------------------------------------------------------------------------------------- *)

  // Opcionalmente pode gerar o template da assinatura - Isso n�o sginifica assinar o arquivo!

  CTe.signature.URI := CTe.infCTe.Id;

  (****************************************************************************)
  (*                                                                          *)
  (*                G E R A R   O   A R Q U I V O   X M L                     *)
  (*                                                                          *)
  (****************************************************************************)

  // Criar a class TCTeW para a gera��o do arquivo conforme os dados inseridos
  // em CTe passar o objeto que cont�m os dados para a gera��o do arquivo xml

  CTeW := TCTeW.Create(CTe);

  // Informa as op��es especificas de TCTeW

  CTeW.Opcoes.NormatizarMunicipios := False;                     // Realiza a normatiza��o do nome do municipio conforme a tabela do IBGE
  CTeW.Opcoes.PathArquivoMunicipios := 'C:\meuCaminho\MunIBGE\'; // Indicar para aonde est�o os arquivo com os nomes dos municipios
  CTeW.Opcoes.GerarTagAssinatura := taNunca;                     // Op��o de gerar o template da assinature em branco
  CTeW.Opcoes.ValidarInscricoes := False;                        // Valida as Inscri��es. (� melhor quando essa valida��o � feita no ERP)

  // Informar as op��es comuns ao gerador ( Abaixo opc�es Default)

  CTeW.Gerador.Opcoes.IdentarXML := False;                                                   // Os arquivos que ser�o enviados para o SEFAZ n�o devem estar identados
  CTeW.Gerador.Opcoes.TamanhoIdentacao := 3;                                                 // Tamanho da identa��o do arquivo
  CTeW.Gerador.Opcoes.FormatoAlerta := 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.'; // Formato em que a mensagem vai ser gravada a ListaDeAlertas
  CTeW.Gerador.Opcoes.RetirarEspacos := True;                                                // Retira os espa�os em branco duplos nas tag do xml
  CTeW.Gerador.Opcoes.SuprimirDecimais := False;                                             // Ignora valores n�o significativos nas casa decimais
  CTeW.Gerador.Opcoes.SomenteValidar := False;                                               // N�o gera o arquivo apenas valida as informa��es

  // Gerar o arquivo XML

  CTeW.GerarXml;

  // Carrega erros

  // if CTeW.Gerador.ListaDeAlertas.Count > 0 then
  //  memo1.Lines.Add(CTeW.gerador.ListaDeAlertas.Text);

  // Gravar o arquivo no HD

  if CTeW.Gerador.ListaDeAlertas.Count = 0 then // Se n�o contiver nenhum erro, grava
  begin
    CTeW.gerador.SalvarArquivo('C:\Meu-Caminho\' + OnlyNumber(CTeW.CTe.infCTe.Id) + '-cte.xml'); // N�o � necess�rio informar o parametro fpXML pois ele � default
  end;

  CTeW.Free;
  CTe.Free;

end;

end.

