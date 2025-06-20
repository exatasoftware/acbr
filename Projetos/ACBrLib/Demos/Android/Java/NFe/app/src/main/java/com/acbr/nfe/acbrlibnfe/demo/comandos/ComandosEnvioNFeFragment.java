package com.acbr.nfe.acbrlibnfe.demo.comandos;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.pdf.PdfRenderer;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.ParcelFileDescriptor;
import android.util.Base64;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import com.acbr.nfe.acbrlibnfe.demo.utils.ACBrLibHelper;
import com.acbr.nfe.acbrlibnfe.demo.R;
import com.acbr.nfe.acbrlibnfe.demo.utils.NfeApplication;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.file.Files;
import java.text.ParseException;
import java.util.Arrays;
import java.util.Date;

import br.com.acbr.lib.comum.dfe.CSOSNIcms;
import br.com.acbr.lib.comum.dfe.CSTCofins;
import br.com.acbr.lib.comum.dfe.CSTIBSCBS;
import br.com.acbr.lib.comum.dfe.CSTIcms;
import br.com.acbr.lib.comum.dfe.CSTPIS;
import br.com.acbr.lib.comum.dfe.IndicadorIE;
import br.com.acbr.lib.comum.dfe.OrigemMercadoria;
import br.com.acbr.lib.comum.dfe.TcCredPres;
import br.com.acbr.lib.comum.dfe.TipoAmbiente;
import br.com.acbr.lib.comum.dfe.TipoEnteGov;
import br.com.acbr.lib.comum.dfe.TipoOperGov;
import br.com.acbr.lib.comum.dfe.cClassTribIBSCBS;
import br.com.acbr.lib.nfe.ACBrLibNFe;
import br.com.acbr.lib.nfe.Ambiente;
import br.com.acbr.lib.nfe.CRT;
import br.com.acbr.lib.nfe.ModeloDF;
import br.com.acbr.lib.nfe.TipoCredPresIBSZFM;
import br.com.acbr.lib.nfe.TipoDANFE;
import br.com.acbr.lib.nfe.TipoEmissao;
import br.com.acbr.lib.nfe.TipoNFe;
import br.com.acbr.lib.nfe.TipoNFeCredito;
import br.com.acbr.lib.nfe.TipoNFeDebito;
import br.com.acbr.lib.nfe.notafiscal.CSTIS;
import br.com.acbr.lib.nfe.notafiscal.ConsumidorFinal;
import br.com.acbr.lib.nfe.notafiscal.DestinoOperacao;
import br.com.acbr.lib.nfe.notafiscal.DeterminacaoBaseIcms;
import br.com.acbr.lib.nfe.notafiscal.FinalidadeNFe;
import br.com.acbr.lib.nfe.notafiscal.FormaPagamento;
import br.com.acbr.lib.nfe.notafiscal.IdentificacaoNFe;
import br.com.acbr.lib.nfe.notafiscal.IndBemMovelUsado;
import br.com.acbr.lib.nfe.notafiscal.IndIntermed;
import br.com.acbr.lib.nfe.notafiscal.IndicadorPagamento;
import br.com.acbr.lib.nfe.notafiscal.IndicadorTotal;
import br.com.acbr.lib.nfe.notafiscal.NotaFiscal;
import br.com.acbr.lib.nfe.notafiscal.PagamentoNFe;
import br.com.acbr.lib.nfe.notafiscal.PresencaComprador;
import br.com.acbr.lib.nfe.notafiscal.ProcessoEmissao;
import br.com.acbr.lib.nfe.notafiscal.ProdutoNFe;
import br.com.acbr.lib.nfe.notafiscal.TipoClassTribIS;
import br.com.acbr.lib.nfe.notafiscal.TpIntegra;

public class ComandosEnvioNFeFragment extends Fragment {

    private NfeApplication application;
    private ACBrLibNFe ACBrNFe;

    private EditText txtNFeINI;
    private EditText txtNFeXML;
    private EditText txtRespostaEnvio;
    private EditText txtDestinatario;
    private Button btnLimparLista;
    private Button btnEnviarNFe;
    private Button btnEnviarNFeClasseAltoNivel;
    private Button btnImprimirNFCe;
    private Button btnImprimirPDFNFCe;
    private Button btnConverterDANFCePDFemBMP;
    private Button btnLimparRespostaEnvio;
    private Button btnEnviarEmailNFCe;

    private Spinner cmbModeloDocumento;
    private Spinner cmbAmbiente;
    private Spinner cmbFormaEmissao;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_comandos_envio_nfe, container, false);

        this.application = (NfeApplication)view.getContext().getApplicationContext();

        ACBrNFe = ACBrLibHelper.getInstance("ACBrLib.ini");

        txtNFeINI = view.findViewById(R.id.txtNFeINI);
        txtNFeXML = view.findViewById(R.id.txtNFeXML);
        txtDestinatario = view.findViewById(R.id.txtDestinatario);
        txtRespostaEnvio = view.findViewById(R.id.txtRespostaEnvio);
        btnLimparLista = view.findViewById(R.id.btnLimparLista);
        btnEnviarNFe = view.findViewById(R.id.btnEnviarNFe);
        btnEnviarNFeClasseAltoNivel = view.findViewById(R.id.btnEnviarNFeClasseAltoNivel);
        btnEnviarEmailNFCe = view.findViewById(R.id.btnEnviarEmailNFCe);
        btnImprimirNFCe = view.findViewById(R.id.btnImprimirNFCe);
        btnImprimirPDFNFCe = view.findViewById(R.id.btnImprimirPDFNFCe);
        btnConverterDANFCePDFemBMP = view.findViewById(R.id.btnConverterDANFCePDFemBMP);
        btnLimparRespostaEnvio = view.findViewById(R.id.btnLimparRespostaEnvio);

        btnLimparLista.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                limparListaNFe();
            }
        });

        btnEnviarNFe.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                enviarNFe();
            }
        });

        btnEnviarNFeClasseAltoNivel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                    enviarNFeClasseAltoNivel();
            }
        });

        btnEnviarEmailNFCe.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                enviarEmailNFCe();
            }
        });

        btnImprimirNFCe.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                imprimirNFCe();
            }
        });

        btnImprimirPDFNFCe.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                imprimirPDFNFCe();
            }
        });

        btnConverterDANFCePDFemBMP.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                converterNFCePDFemBMP();
            }
        });

        btnLimparRespostaEnvio.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                LimparRespostaEnvio();
            }
        });

        return view;
    }

    public void onViewCreated(View view, Bundle savedInstanceState){
        super.onViewCreated(view, savedInstanceState);

        Spinner cmbModeloDocumento = getView().findViewById(R.id.cmbModeloDocumento);
        if (cmbModeloDocumento != null) {
            ModeloDF modeloDFSelecionado = (ModeloDF) cmbModeloDocumento.getSelectedItem();
            NotaFiscal notaFiscal = new NotaFiscal();
            notaFiscal.Identificacao.setModelo(modeloDFSelecionado);
        } else {
            Log.e("Erro", "Spinner cmbModeloDocumento não encontrado.");
        }

        Spinner cmbAmbiente = getView().findViewById(R.id.cmbAmbiente);
        if (cmbAmbiente != null) {
            TipoAmbiente ambienteSelecionado = (TipoAmbiente) cmbAmbiente.getSelectedItem();
            NotaFiscal notaFiscal = new NotaFiscal();
            notaFiscal.Identificacao.setTpAmb(ambienteSelecionado);
        } else {
            Log.e("Erro", "Spinner cmbAmbiente não encontrado.");
        }

        Spinner cmbFormaEmissao = getView().findViewById(R.id.cmbFormaEmissao);
        if (cmbFormaEmissao != null) {
            TipoEmissao formaEmissaoSelecionada = (TipoEmissao) cmbFormaEmissao.getSelectedItem();
            NotaFiscal notaFiscal = new NotaFiscal();
            notaFiscal.Identificacao.setTpEmis(formaEmissaoSelecionada);
        } else {
            Log.e("Erro", "Spinner cmbFormaEmissao não encontrado.");
        }
    }

    public void limparListaNFe() {
        txtRespostaEnvio.setText("");
        try {
            ACBrNFe.LimparLista();
            txtRespostaEnvio.setText("Método executado com sucesso !!");
        } catch (Exception ex) {
            Log.e("Erro ao Limpar Lista NFe", ex.getMessage());
            txtRespostaEnvio.setText(ex.getMessage());
        }
    }

    public void enviarNFe() {
        txtRespostaEnvio.setText("");
        String result = "";
        String NFeIni = txtNFeINI.getText().toString();
        try {
            ACBrNFe.CarregarINI(NFeIni);
            ACBrNFe.ObterXml(0);
            result = ACBrNFe.Enviar(1, false, false, false);
        } catch (Exception ex) {
            Log.e("Erro ao Enviar NFe", ex.getMessage());
            result = ex.getMessage();
        } finally {
            txtRespostaEnvio.setText(result);
        }
    }

    private String AlimentarDados() {
        NotaFiscal notaFiscal = new NotaFiscal();

        //infNFe
        notaFiscal.InfNFe.setVersao("4.0");

        //Identificação
        notaFiscal.Identificacao.setcUF(35);
        notaFiscal.Identificacao.setcNF(19456927);
        notaFiscal.Identificacao.setNatOp("VENDA");

        IndicadorPagamento indPagIde = IndicadorPagamento.ipVista;
        notaFiscal.Identificacao.setIndPag(indPagIde);

        if (cmbModeloDocumento != null) {
            ModeloDF modeloDFSelecionado = (ModeloDF) cmbModeloDocumento.getSelectedItem();
            notaFiscal.Identificacao.setModelo(modeloDFSelecionado);
        }

        notaFiscal.Identificacao.setSerie("1");
        notaFiscal.Identificacao.setnNF(1);

        notaFiscal.Identificacao.setDhEmi(new Date());
        notaFiscal.Identificacao.setDhSaiEnt(new Date());

        TipoNFe tipoNFe = TipoNFe.tnSaida;
        notaFiscal.Identificacao.setTpNF(tipoNFe);

        DestinoOperacao idDest = DestinoOperacao.doInterna;
        notaFiscal.Identificacao.setIdDest(idDest);

        if (cmbAmbiente != null){
            TipoAmbiente ambienteSelecionado = (TipoAmbiente) cmbAmbiente.getSelectedItem();
            notaFiscal.Identificacao.setTpAmb(ambienteSelecionado);
        }

        TipoDANFE tipoDANFE = TipoDANFE.tiRetrato;
        notaFiscal.Identificacao.setTpImp(tipoDANFE);

        if (cmbFormaEmissao != null){
            TipoEmissao formaEmissaoSelecionada = (TipoEmissao) cmbFormaEmissao.getSelectedItem();
            notaFiscal.Identificacao.setTpEmis(formaEmissaoSelecionada);
        }

        FinalidadeNFe finNFe = FinalidadeNFe.fnNormal;
        notaFiscal.Identificacao.setFinNFe(finNFe);

        ConsumidorFinal consumidorFinal = ConsumidorFinal.cfConsumidorFinal;
        notaFiscal.Identificacao.setIndFinal(consumidorFinal);

        PresencaComprador presencaComprador = PresencaComprador.pcPresencial;
        notaFiscal.Identificacao.setIndPres(presencaComprador);

        ProcessoEmissao processoEmissao = ProcessoEmissao.peAplicativoContribuinte;
        notaFiscal.Identificacao.setProcEmi(processoEmissao);

        IndIntermed indIntermed = IndIntermed.iiSemOperacao;
        notaFiscal.Identificacao.setIndIntermed(indIntermed);

        notaFiscal.Identificacao.setVerProc("ACBrNFe");

        //Reforma Tributária
//        notaFiscal.Identificacao.setcMunFGIBS(3554003);
//
//        TipoNFeCredito tipoNFeCredito = TipoNFeCredito.tcNenhum;
//        notaFiscal.Identificacao.setTpNFCredito(tipoNFeCredito);
//
//        TipoNFeDebito tipoNFeDebito = TipoNFeDebito.tdAnulacao;
//        notaFiscal.Identificacao.setTpNFDebito(tipoNFeDebito);
//
//        TipoEnteGov tipoEnteGov = TipoEnteGov.tcgEstados;
//        notaFiscal.Identificacao.setTpEnteGov(tipoEnteGov);
//
//        notaFiscal.Identificacao.setpRedutor(BigDecimal.valueOf(2.5));
//
//        TipoOperGov tipoOperGov = TipoOperGov.togFornecimento;
//        notaFiscal.Identificacao.setTpOperGov(tipoOperGov);
        //--------------

        //Emitente
        CRT crt = CRT.crtRegimeNormal;
        notaFiscal.Emitente.setCrt(crt);
        notaFiscal.Emitente.setCnpjCpf("99999999999999");
        notaFiscal.Emitente.setxNome("Razao Social Emitente");
        notaFiscal.Emitente.setxFant("Fantasia");
        notaFiscal.Emitente.setIe("111111111111");
        notaFiscal.Emitente.setIest("");
        notaFiscal.Emitente.setIm("");
        notaFiscal.Emitente.setCnae("");
        notaFiscal.Emitente.setxLgr("Logradouro, do emitente");
        notaFiscal.Emitente.setNro("S/N");
        notaFiscal.Emitente.setxCpl("");
        notaFiscal.Emitente.setxBairro("Bairro");
        notaFiscal.Emitente.setcMun(3550308);
        notaFiscal.Emitente.setxMun("São Paulo");
        notaFiscal.Emitente.setcUF("35");
        notaFiscal.Emitente.setUf("SP");
        notaFiscal.Emitente.setCep("11111111");
        notaFiscal.Emitente.setcPais(1058);
        notaFiscal.Emitente.setxPais("BRASIL");
        notaFiscal.Emitente.setFone("11111111111111");

        //Destinatario
        // Observação -> Obrigatório o preenchimento para o modelo 55.
        notaFiscal.Destinatario.setCNPJCPF("99999999999999");
        notaFiscal.Destinatario.setXNome("Razao Social Destinatário");
        IndicadorIE indIE = IndicadorIE.inNaoContribuinte;
        notaFiscal.Destinatario.setIndIEDest(indIE);
        notaFiscal.Destinatario.setIE("111111111111");
        notaFiscal.Destinatario.setISUF("");
        notaFiscal.Destinatario.setEmail("emaildest@mail.com.br");
        notaFiscal.Destinatario.setXLgr("Logradouro, do destinatario");
        notaFiscal.Destinatario.setNro("123");
        notaFiscal.Destinatario.setXCpl("");
        notaFiscal.Destinatario.setXBairro("Centro");
        notaFiscal.Destinatario.setCMun(3550308);
        notaFiscal.Destinatario.setXMun("São Paulo");
        notaFiscal.Destinatario.setUF("SP");
        notaFiscal.Destinatario.setCEP("00000000");
        notaFiscal.Destinatario.setCPais(1058);
        notaFiscal.Destinatario.setXPais("BRASIL");
        notaFiscal.Destinatario.setFone("11111111111111");

        //Produto
        ProdutoNFe produto = new ProdutoNFe();
        produto.setnItem(1);
        produto.setcProd("123456");
        produto.setcEAN("7896523206646");
        produto.setxProd("Descrição do Produto");

        IndicadorTotal indTot = IndicadorTotal.itSomaTotalNFe;
        produto.setIndTot(indTot);

        produto.setNCM("85395200");
        produto.setCEST("1111111");
        produto.setCFOP("5101");
        produto.setuCom("UN");
        produto.setqCom(1);
        produto.setvUnCom(100);
        produto.setcEANTrib("7896523206646");
        produto.setcBarraTrib("ABC123456");
        produto.setuTrib("UN");
        produto.setqTrib(1);
        produto.setvUnTrib(100);

        // Calculando o total do produto corretamente
        BigDecimal totalProdutos = BigDecimal.valueOf(produto.getvUnCom() * produto.getqCom());
        produto.setvProd(totalProdutos.doubleValue());

        //Reforma Tributária
//        IndBemMovelUsado indBemMovelUsado = IndBemMovelUsado.tieNenhum;
//        produto.setIndBemMovelUsado(indBemMovelUsado);
//        produto.setvItem(BigDecimal.valueOf(100));
        //--------------

        //Reforma Tributária
//        produto.getDFeReferenciado().setnItem(100);
//        produto.getDFeReferenciado().setChaveAcesso("35250518760540000139550010000000011374749890");
        //--------------

        // Tributação
        CSOSNIcms csosn = CSOSNIcms.csosnVazio;
        produto.getICMS().setCSOSN(csosn);

        CSTIcms cstIcms = CSTIcms.cst00;
        produto.getICMS().setCST(cstIcms);

        DeterminacaoBaseIcms determinacaoBaseIcms = DeterminacaoBaseIcms.dbiValorOperacao;
        produto.getICMS().setModBC(determinacaoBaseIcms);

        produto.getICMS().setvBC(BigDecimal.valueOf(produto.getvProd()));
        produto.getICMS().setpICMS(BigDecimal.valueOf(18));

        BigDecimal vBC = produto.getICMS().getvBC();
        BigDecimal pICMS = produto.getICMS().getpICMS();
        BigDecimal cem = BigDecimal.valueOf(100);
        BigDecimal vICMS = vBC.multiply(pICMS).divide(cem, 2, RoundingMode.HALF_UP);
        produto.getICMS().setvICMS(vICMS);

        // Cálculos de PIS e COFINS
        CSTPIS cstpis = CSTPIS.pis04;
        produto.getPIS().setCST(cstpis);

        CSTCofins cofins = CSTCofins.cof04;
        produto.getCOFINS().setCst(cofins);

        // Campos adicionais
        produto.setvFrete(0);
        produto.setvSeg(0);
        produto.setvDesc(0);
        produto.setvOutro(0);

        produto.setInfAdProd("Informação adicional do produto");

        //Reforma Tributária
//        CSTIS cstis = CSTIS.cstis000;
//        produto.getIS().setCSTIS(cstis);
//
//        TipoClassTribIS tipoClassTribIS = TipoClassTribIS.ctis000001;
//        produto.getIS().setcClassTribIS(tipoClassTribIS);
//
//        produto.getIS().setvBCIS(BigDecimal.valueOf(100));
//        produto.getIS().setpIS(BigDecimal.valueOf(5));
//        produto.getIS().setpISEspec(BigDecimal.valueOf(5));
//        produto.getIS().setuTrib("UNIDAD");
//        produto.getIS().setqTrib(BigDecimal.valueOf(10));
//        produto.getIS().setvIS(BigDecimal.valueOf(100));
//
//        CSTIBSCBS cstIBSCBS = CSTIBSCBS.cst000;
//        produto.getIBSCBS().setCST(cstIBSCBS);
//
//        cClassTribIBSCBS cClassTrib = cClassTribIBSCBS.cct000001;
//        produto.getIBSCBS().setcClassTrib(cClassTrib);
//
//        produto.getIBSCBS().getgIBSCBS().setvBC(BigDecimal.valueOf(100));
//
//        produto.getIBSCBS().getgIBSCBS().getgIBSUF().setpIBSUF(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBS().getgIBSUF().setvIBSUF(BigDecimal.valueOf(100));
//        produto.getIBSCBS().getgIBSCBS().getgIBSUF().setpDif(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBS().getgIBSUF().setvDif(BigDecimal.valueOf(100));
//        produto.getIBSCBS().getgIBSCBS().getgIBSUF().setvDevTrib(BigDecimal.valueOf(100));
//        produto.getIBSCBS().getgIBSCBS().getgIBSUF().setpRedAliq(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBS().getgIBSUF().setpAliqEfet(BigDecimal.valueOf(5));
//
//        produto.getIBSCBS().getgIBSCBS().getgIBSMun().setpIBSMun(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBS().getgIBSMun().setvIBSMun(BigDecimal.valueOf(100));
//        produto.getIBSCBS().getgIBSCBS().getgIBSMun().setpDif(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBS().getgIBSMun().setvDif(BigDecimal.valueOf(100));
//        produto.getIBSCBS().getgIBSCBS().getgIBSMun().setvDevTrib(BigDecimal.valueOf(100));
//        produto.getIBSCBS().getgIBSCBS().getgIBSMun().setpRedAliq(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBS().getgIBSMun().setpAliqEfet(BigDecimal.valueOf(5));
//
//        produto.getIBSCBS().getgIBSCBS().getgCBS().setpCBS(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBS().getgCBS().setvCBS(BigDecimal.valueOf(100));
//        produto.getIBSCBS().getgIBSCBS().getgCBS().setpDif(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBS().getgCBS().setvDif(BigDecimal.valueOf(100));
//        produto.getIBSCBS().getgIBSCBS().getgCBS().setvDevTrib(BigDecimal.valueOf(100));
//        produto.getIBSCBS().getgIBSCBS().getgCBS().setpRedAliq(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBS().getgCBS().setpAliqEfet(BigDecimal.valueOf(5));
//
//        CSTIBSCBS cstIBSCBSRegular = CSTIBSCBS.cst000;
//        produto.getIBSCBS().getgIBSCBS().getgTribRegular().setCSTReg(cstIBSCBSRegular);
//
//        cClassTribIBSCBS cClassTribIBSCBSRegular = cClassTribIBSCBS.cct000001;
//        produto.getIBSCBS().getgIBSCBS().getgTribRegular().setcClassTribReg(cClassTribIBSCBSRegular);
//
//        produto.getIBSCBS().getgIBSCBS().getgTribRegular().setpAliqEfetRegIBSUF(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBS().getgTribRegular().setvTribRegIBSUF(BigDecimal.valueOf(100));
//        produto.getIBSCBS().getgIBSCBS().getgTribRegular().setpAliqEfetRegIBSMun(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBS().getgTribRegular().setvTribRegIBSMun(BigDecimal.valueOf(100));
//        produto.getIBSCBS().getgIBSCBS().getgTribRegular().setpAliqEfetRegCBS(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBS().getgTribRegular().setvTribRegCBS(BigDecimal.valueOf(100));
//
//        TcCredPres tcCredPres = TcCredPres.cp01;
//        produto.getIBSCBS().getgIBSCBS().getgIBSCredPres().setcCredPres(tcCredPres);
//
//        produto.getIBSCBS().getgIBSCBS().getgIBSCredPres().setvCredPresCondSus(BigDecimal.valueOf(100));
//
//        TcCredPres ibstcCredPres = TcCredPres.cp01;
//        produto.getIBSCBS().getgIBSCBS().getgIBSCredPres().setcCredPres(ibstcCredPres);
//
//        produto.getIBSCBS().getgIBSCBS().getgIBSCredPres().setpCredPres(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBS().getgIBSCredPres().setvCredPres(BigDecimal.valueOf(100));
//        //produto.getIBSCBS().getgIBSCBS().getgIBSCredPres().setvCredPresCondSus(BigDecimal.valueOf(100));
//
//        TcCredPres cbstcCredPres = TcCredPres.cp01;
//        produto.getIBSCBS().getgIBSCBS().getgCBSCredPres().setcCredPres(cbstcCredPres);
//
//        produto.getIBSCBS().getgIBSCBS().getgCBSCredPres().setpCredPres(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBS().getgCBSCredPres().setvCredPres(BigDecimal.valueOf(100));
//        produto.getIBSCBS().getgIBSCBS().getgCBSCredPres().setvCredPresCondSus(BigDecimal.valueOf(100));
//
//        produto.getIBSCBS().getgIBSCBS().getgTribCompraGov().setpAliqIBSUF(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBS().getgTribCompraGov().setvTribIBSUF(BigDecimal.valueOf(50));
//        produto.getIBSCBS().getgIBSCBS().getgTribCompraGov().setpAliqIBSMun(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBS().getgTribCompraGov().setvTribIBSMun(BigDecimal.valueOf(50));
//        produto.getIBSCBS().getgIBSCBS().getgTribCompraGov().setpAliqCBS(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBS().getgTribCompraGov().setvTribCBS(BigDecimal.valueOf(50));
//
//        produto.getIBSCBS().getgIBSCBSMono().setqBCMono(BigDecimal.valueOf(1));
//        produto.getIBSCBS().getgIBSCBSMono().setAdRemIBS(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBSMono().setAdRemCBS(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBSMono().setvIBSMono(BigDecimal.valueOf(100));
//        produto.getIBSCBS().getgIBSCBSMono().setvCBSMono(BigDecimal.valueOf(100));
//
//        produto.getIBSCBS().getgIBSCBSMono().setqBCMonoReten(BigDecimal.valueOf(1));
//        produto.getIBSCBS().getgIBSCBSMono().setAdRemCBSReten(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBSMono().setvIBSMonoReten(BigDecimal.valueOf(100));
//        produto.getIBSCBS().getgIBSCBSMono().setvCBSMonoReten(BigDecimal.valueOf(100));
//
//        produto.getIBSCBS().getgIBSCBSMono().setqBCMonoRet(BigDecimal.valueOf(1));
//        produto.getIBSCBS().getgIBSCBSMono().setAdRemIBSRet(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBSMono().setvIBSMonoRet(BigDecimal.valueOf(100));
//        produto.getIBSCBS().getgIBSCBSMono().setvCBSMonoRet(BigDecimal.valueOf(100));
//
//        produto.getIBSCBS().getgIBSCBSMono().setpDifIBS(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBSMono().setvIBSMonoDif(BigDecimal.valueOf(100));
//        produto.getIBSCBS().getgIBSCBSMono().setpDifCBS(BigDecimal.valueOf(5));
//        produto.getIBSCBS().getgIBSCBSMono().setvCBSMonoDif(BigDecimal.valueOf(100));
//
//        produto.getIBSCBS().getgIBSCBSMono().setvTotIBSMonoItem(BigDecimal.valueOf(100));
//        produto.getIBSCBS().getgIBSCBSMono().setvTotCBSMonoItem(BigDecimal.valueOf(100));
//
//        produto.getIBSCBS().getgTransfCred().setvIBS(BigDecimal.valueOf(100));
//        produto.getIBSCBS().getgTransfCred().setvCBS(BigDecimal.valueOf(100));
//
//        TipoCredPresIBSZFM tpCredPresIBSZFM = TipoCredPresIBSZFM.tcpBensInformaticaOutros;
//        produto.getIBSCBS().getgCredPresIBSZFM().setTpCredPresIBSZFM(tpCredPresIBSZFM);
//
//        produto.getIBSCBS().getgCredPresIBSZFM().setvCredPresIBSZFM(BigDecimal.valueOf(100));
        //--------------

        notaFiscal.Produtos.add(produto);

        notaFiscal.Total.setVBC(BigDecimal.valueOf(produto.getvProd()));
        notaFiscal.Total.setVICMS(produto.getICMS().getvICMS());
        notaFiscal.Total.setVProd(BigDecimal.valueOf(produto.getvProd()));
        notaFiscal.Total.setVNF(BigDecimal.valueOf(produto.getvProd()));

        //Reforma Tributária
//        notaFiscal.Total.getISTot().setvIS(BigDecimal.valueOf(100));
//
//        notaFiscal.Total.getIBSCBSTot().setvBCIBSCBS(100);
//
//        notaFiscal.Total.getIBSCBSTot().getgIBS().setvIBS(BigDecimal.valueOf(100));
//        notaFiscal.Total.getIBSCBSTot().getgIBS().setvCredPres(BigDecimal.valueOf(100));
//        notaFiscal.Total.getIBSCBSTot().getgIBS().setvCredPresCondSus(BigDecimal.valueOf(100));
//
//        notaFiscal.Total.getIBSCBSTot().getgIBS().getgIBSUF().setvDif(BigDecimal.valueOf(100));
//        notaFiscal.Total.getIBSCBSTot().getgIBS().getgIBSUF().setvDevTrib(BigDecimal.valueOf(100));
//        notaFiscal.Total.getIBSCBSTot().getgIBS().getgIBSUF().setvIBSUF(BigDecimal.valueOf(100));
//
//        notaFiscal.Total.getIBSCBSTot().getgIBS().getgIBSMun().setvDif(BigDecimal.valueOf(100));
//        notaFiscal.Total.getIBSCBSTot().getgIBS().getgIBSMun().setvDevTrib(BigDecimal.valueOf(100));
//        notaFiscal.Total.getIBSCBSTot().getgIBS().getgIBSMun().setvIBSMun(BigDecimal.valueOf(100));
//
//        notaFiscal.Total.getIBSCBSTot().getgCBS().setvDif(BigDecimal.valueOf(100));
//        notaFiscal.Total.getIBSCBSTot().getgCBS().setvDevTrib(BigDecimal.valueOf(100));
//        notaFiscal.Total.getIBSCBSTot().getgCBS().setvCBS(BigDecimal.valueOf(100));
//        notaFiscal.Total.getIBSCBSTot().getgCBS().setvCredPres(BigDecimal.valueOf(100));
//        notaFiscal.Total.getIBSCBSTot().getgCBS().setvCredPresCondSus(BigDecimal.valueOf(100));
//
//        notaFiscal.Total.getIBSCBSTot().getgMono().setvIBSMono(BigDecimal.valueOf(100));
//        notaFiscal.Total.getIBSCBSTot().getgMono().setvCBSMono(BigDecimal.valueOf(100));
//        notaFiscal.Total.getIBSCBSTot().getgMono().setvIBSMonoReten(BigDecimal.valueOf(100));
//        notaFiscal.Total.getIBSCBSTot().getgMono().setvCBSMonoReten(BigDecimal.valueOf(100));
//        notaFiscal.Total.getIBSCBSTot().getgMono().setvIBSMonoRet(BigDecimal.valueOf(100));
//        notaFiscal.Total.getIBSCBSTot().getgMono().setvCBSMonoRet(BigDecimal.valueOf(100));
//
//        notaFiscal.Total.setvNFTot(BigDecimal.valueOf(100));
        //--------------

        PagamentoNFe pagamento = new PagamentoNFe();
        TpIntegra tpIntegra = TpIntegra.tiNaoInformado;
        pagamento.setTpIntegra(tpIntegra);

        IndicadorPagamento indPag = IndicadorPagamento.ipVista;
        pagamento.setIndPag(indPag);

        FormaPagamento tPag = FormaPagamento.fpDinheiro;
        pagamento.settPag(tPag);

        pagamento.setvPag(BigDecimal.valueOf(100.0));
        pagamento.setdPag(new Date());
        notaFiscal.Pagamentos.add(pagamento);

        //Exemplos de integração dos meios de pagamento aos documentos fiscais eletrônicos mencionados na aula
        //https://acbr.nutror.com/curso/8d575bd8a7c0ac0fda312f9b12b1eb521e606446/aula/9286660
        //Disponível no curso Integração dos Meios de Pagamento aos Documentos Fiscais Eletrônicos

        //-------> Exemplo pagamento cartão débito/crédito para o Mato Grosso.
        //PagamentoNFe pagtoCartaoMT = new PagamentoNFe();
        //FormaPagamento tPagCartaoMT = FormaPagamento.fpCartaoCredito;
        //pagtoCartaoMT.settPag(tPagCartaoMT);
        //pagtoCartaoMT.setvPag(BigDecimal.valueOf(100.00));
        //TpIntegra tpIntegraCartaoMT = TpIntegra.tiPagIntegrado;
        //pagtoCartaoMT.setTpIntegra(tpIntegraCartaoMT);
        //pagtoCartaoMT.setCNPJ("99999999999999");
        //pagtoCartaoMT.setcAut("123456789012345678901234567890");
        //pagtoCartaoMT.setCNPJReceb("123456789101234");
        //pagtoCartaoMT.setIdTermPag("12345678901234567890");
        //notaFiscal.Pagamentos.add(pagtoCartaoMT);

        //-------> Exemplo pagamento PIX para o Mato Grosso.
        //PagamentoNFe pagtoPIXMT = new PagamentoNFe();
        //FormaPagamento tPagPIXMT = FormaPagamento.fpPagamentoInstantaneo;
        //pagtoPIXMT.settPag(tPagPIXMT);
        //pagtoPIXMT.setvPag(BigDecimal.valueOf(100.00));
        //TpIntegra tpIntegraPIXMT = TpIntegra.tiPagIntegrado;
        //pagtoPIXMT.setTpIntegra(tpIntegraPIXMT);
        //pagtoPIXMT.setCNPJ("99999999999999");
        //pagtoPIXMT.setcAut("123456789012345678901234657890123456789012346578901234567890123456789012345678901234567980");
        //pagtoPIXMT.setCNPJReceb("12345678901234");
        //pagtoPIXMT.setIdTermPag("12345678901234567890");
        //notaFiscal.Pagamentos.add(pagtoPIXMT);

        //-------> Exemplo pagamento cartão débito/crédito para o Rio Grande do Sul.
        //PagamentoNFe pagtoCartaoRS = new PagamentoNFe();
        //FormaPagamento tpagCartaoRS = FormaPagamento.fpCartaoCredito;
        //pagtoCartaoRS.settPag(tpagCartaoRS);
        //pagtoCartaoRS.setvPag(BigDecimal.valueOf(100.00));
        //TpIntegra tpIntegraCartaoRS = TpIntegra.tiPagIntegrado;
        //pagtoCartaoRS.setTpIntegra(tpIntegraCartaoRS);
        //pagtoCartaoRS.setcAut("123456789012345678901234567890");
        //notaFiscal.Pagamentos.add(pagtoCartaoRS);

        //-------> Exemplo pagamento PIX para o Rio Grande do Sul.
        //PagamentoNFe pagtoPIXRS = new PagamentoNFe();
        //FormaPagamento tPagPIXRS = FormaPagamento.fpPagamentoInstantaneo;
        //pagtoPIXRS.settPag(tPagPIXRS);
        //pagtoPIXRS.setvPag(BigDecimal.valueOf(100.00));
        //TpIntegra tpIntegraPIXRS = TpIntegra.tiPagIntegrado;
        //pagtoPIXRS.setTpIntegra(tpIntegraPIXRS);
        //pagtoPIXRS.setCNPJ("99999999999999");
        //pagtoPIXRS.setcAut("123456789012345678901234657890123456789012346578901234567890123456789012345678901234567980");
        //pagtoPIXRS.setCNPJReceb("13245678901234");
        //pagtoPIXRS.setIdTermPag("12345678901234567890");
        //notaFiscal.Pagamentos.add(pagtoPIXRS);

        return notaFiscal.toString();
    }

    public void enviarNFeClasseAltoNivel() {
        txtRespostaEnvio.setText("");
        String result = "";
        String nfe = AlimentarDados();
        try {
            ACBrNFe.LimparLista();
            ACBrNFe.CarregarINI(nfe);
            ACBrNFe.ObterXml(0);
            result = ACBrNFe.Enviar(1, false, false, false);
        } catch (Exception ex) {
            Log.e("Erro ao Enviar NFe", ex.getMessage());
            result = ex.getMessage();
        } finally {
            txtRespostaEnvio.setText(result);
        }
    }

    public void enviarEmailNFCe() {
        txtRespostaEnvio.setText("");
        String NFeXml = txtNFeXML.getText().toString();
        String destinatario = txtDestinatario.getText().toString();
        try {
            ACBrNFe.EnviarEmail(destinatario, NFeXml, true, "Envio NFCe Email", "", "", "Envio NFCe");
            txtRespostaEnvio.setText("Email enviado com sucesso!");
        } catch (Exception ex) {
            Log.e("Erro ao Enviar Email", ex.getMessage());
            txtRespostaEnvio.setText(ex.getMessage());
        }
    }

    public void imprimirNFCe() {
        try {
            Log.d("Print", "Limpando lista antes da impressão.");
            ACBrNFe.LimparLista();

            String xmlContent = txtNFeXML.getText().toString();
            if (xmlContent.isEmpty()) {
                Log.d("Print", "XML está vazio. Não pode carregar.");
                return;
            }

            Log.d("Print", "Carregando XML: " + xmlContent);
            ACBrNFe.CarregarXML(xmlContent);
            Log.d("Print", "Preparando para imprimir.");
            ACBrNFe.Imprimir("", 1, "False", "False", "False", "False", "False");
            Log.d("Print", "Impressão realizada com sucesso.");
        } catch (Exception ex) {
            Log.e("Erro ao Imprimir NFCe", ex.getMessage());
            ex.printStackTrace();  // Para ver a pilha de erros
            txtRespostaEnvio.setText(ex.getMessage());
        }
    }

    public void imprimirPDFNFCe(){
        try {
            Log.d("Print", "Limpando lista antes da impressão.");
            ACBrNFe.LimparLista();

            String xmlContent = txtNFeXML.getText().toString();
            if (xmlContent.isEmpty()) {
                Log.d("Print", "XML está vazio. Não pode carregar.");
                return;
            }

            Log.d("Print", "Carregando XML: " + xmlContent);
            ACBrNFe.CarregarXML(xmlContent);
            Log.d("Print", "Preparando para imprimir.");
            ACBrNFe.ImprimirPDF();
            Log.d("Print", "Impressão PDF realizada com sucesso.");
        } catch (Exception ex) {
            Log.e("Erro ao Imprimir NFCe", ex.getMessage());
            ex.printStackTrace();  // Para ver a pilha de erros
            txtRespostaEnvio.setText(ex.getMessage());
        }
    }

    public void converterNFCePDFemBMP() {
        try {
            Log.d("Print", "Limpando lista antes da impressão.");
            ACBrNFe.LimparLista();

            String xmlContent = txtNFeXML.getText().toString();
            if (xmlContent.isEmpty()) {
                Log.d("Print", "XML está vazio. Não pode carregar.");
                return;
            }

            Log.d("Print", "Carregando XML: " + xmlContent);
            ACBrNFe.CarregarXML(xmlContent);

            Log.d("Print", "Preparando para imprimir.");
            ACBrNFe.ImprimirPDF();

            // Caminho do PDF gerado
            File pdfFile = new File(requireActivity().getExternalFilesDir("pdf"), "nfc_e.pdf");

            // Verifica se o arquivo PDF foi criado com sucesso
            if (!pdfFile.exists()) {
                Log.e("Erro", "PDF não encontrado no caminho: " + pdfFile.getAbsolutePath());
                return;
            }

            int targetWidth = 850;
            int targetHeight = 1200;

            Bitmap bitmap = savePdfAndConvertToBitmap(requireActivity(), pdfFile.getAbsolutePath(), targetWidth, targetHeight);
            if (bitmap == null) {
                Log.e("Erro ao Imprimir NFCe", "Bitmap está nulo. Conversão de PDF para Bitmap falhou.");
                return;
            }

            saveBitmapToFile(bitmap);

        } catch (Exception ex) {
            String errorMessage = (ex.getMessage() != null) ? ex.getMessage() : "Erro desconhecido";
            Log.e("Erro ao Imprimir NFCe", errorMessage, ex);
            txtRespostaEnvio.setText(errorMessage);
        }
    }

    private Bitmap savePdfAndConvertToBitmap(Context context, String pdfPath, int targetWidth, int targetHeight) {
        File pdfFile = new File(pdfPath);

        if (!pdfFile.exists()) {
            Log.e("Erro", "Arquivo PDF não encontrado: " + pdfPath);
            return null;
        }

        try (ParcelFileDescriptor fileDescriptor = ParcelFileDescriptor.open(pdfFile, ParcelFileDescriptor.MODE_READ_ONLY);
             PdfRenderer pdfRenderer = new PdfRenderer(fileDescriptor)) {

            if (pdfRenderer.getPageCount() == 0) {
                Log.e("Erro", "O PDF não contém páginas.");
                return null;
            }

            PdfRenderer.Page page = pdfRenderer.openPage(0);

            // Cria um Bitmap com o fundo branco e tamanho ajustado
            Bitmap bitmap = Bitmap.createBitmap(targetWidth, targetHeight, Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(bitmap);
            canvas.drawColor(Color.WHITE); // Define o fundo como branco

            // Define uma proporção para redimensionar o conteúdo para caber no bitmap
            float scale = Math.min((float) targetWidth / page.getWidth(), (float) targetHeight / page.getHeight());
            int scaledWidth = (int) (page.getWidth() * scale);
            int scaledHeight = (int) (page.getHeight() * scale);

            // Renderiza o conteúdo do PDF no bitmap redimensionado
            Rect rect = new Rect(0, 0, scaledWidth, scaledHeight);
            page.render(bitmap, rect, null, PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY);

            // Fecha a página após a renderização
            page.close();
            Log.d("Imagem BMP", "Imagem convertida com fundo branco para impressão.");

            return bitmap;

        } catch (Exception e) {
            Log.e("Erro ao renderizar PDF", e.getMessage(), e);
            return null;
        }
    }

    private void saveBitmapToFile(Bitmap bitmap) {
        if (bitmap == null) {
            Log.e("Erro ao Imprimir NFCe", "Bitmap recebido é nulo.");
            return;
        }

        File directory = new File(application.getBmpPath());

        if (!directory.exists() && !directory.mkdirs()) {
            Log.e("Erro", "Falha ao criar diretório: " + directory.getAbsolutePath());
            return;
        }

        String fileName = "imagem_convertida.bmp";
        File file = new File(directory, fileName);

        try (FileOutputStream fos = new FileOutputStream(file)) {
            if (!bitmap.compress(Bitmap.CompressFormat.PNG, 100, fos)) {
                Log.e("Erro ao Salvar Imagem", "Falha ao comprimir e salvar o bitmap.");
                return;
            }
            Log.d("Salvar Imagem", "Imagem salva em: " + file.getAbsolutePath());
            txtRespostaEnvio.setText("Imagem salva com sucesso em: " + file.getAbsolutePath());
        } catch (IOException e) {
            Log.e("Erro ao Salvar Imagem", "Erro: " + e.getMessage(), e);
        }
    }

    public void LimparRespostaEnvio() {
        txtRespostaEnvio.setText("");
    }
}