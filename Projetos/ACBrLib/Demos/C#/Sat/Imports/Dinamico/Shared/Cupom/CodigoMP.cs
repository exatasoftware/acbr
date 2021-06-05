﻿using ACBrLib.Core;

namespace ACBrLib.Sat
{
    public enum CodigoMP
    {
        [EnumValue("01")]
        mpDinheiro,

        [EnumValue("02")]
        mpCheque,

        [EnumValue("03")]
        mpCartaodeCredito,

        [EnumValue("04")]
        mpCartaodeDebito,

        [EnumValue("05")]
        mpCreditoLoja,

        [EnumValue("10")]
        mpValeAlimentacao,

        [EnumValue("11")]
        mpValeRefeicao,

        [EnumValue("12")]
        mpValePresente,

        [EnumValue("13")]
        mpValeCombustivel,

        [EnumValue("99")]
        mpOutros
    }
}