﻿using System;

namespace ACBrLib.Core.PosPrinter
{
    [Flags]
    public enum ACBrPosTipoStatus
    {
        None = 0,
        Erro = 1 << 0,
        NaoSerial = 1 << 1,
        PoucoPapel = 1 << 2,
        SemPapel = 1 << 3,
        GavetaAberta = 1 << 4,
        Imprimindo = 1 << 5,
        OffLine = 1 << 6,
        TampaAberta = 1 << 7,
        ErroLeitura = 1 << 8
    }

    public enum PosDirecao
    {
        dirEsquerdaParaDireita,
        dirTopoParaBaixo,
        dirDireitaParaEsquerda,
        dirBaixoParaTopo
    }
}