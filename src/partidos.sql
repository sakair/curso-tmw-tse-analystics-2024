WITH tb_cand AS (
    SELECT SQ_CANDIDATO,
            SG_UF,
            DS_CARGO,
            SG_PARTIDO,
            NM_PARTIDO,
            DT_NASCIMENTO,
            DS_GENERO,
            DS_GRAU_INSTRUCAO,
            DS_ESTADO_CIVIL,
            DS_COR_RACA,
            DS_OCUPACAO
    FROM tb_candidaturas
),

tb_total_bens AS (
    SELECT SQ_CANDIDATO,
           sum(cast(replace(VR_BEM_CANDIDATO, ',', '.') as DECIMAL(15,2))) AS total_bens
    FROM tb_bens
    GROUP BY 1
),

tb_info_completa_cand AS (
    SELECT t1.*,
        COALESCE(t2.total_bens, 0) AS total_bens
    FROM tb_cand AS t1
    LEFT JOIN tb_total_bens AS t2
    ON t1.SQ_CANDIDATO = t2.SQ_CANDIDATO

),

tb_group_uf AS (
    SELECT
        SG_PARTIDO,
        NM_PARTIDO,
        SG_UF,
        AVG(CASE WHEN DS_GENERO = 'FEMININO' THEN 1 ELSE 0 END) AS tx_feminino,
        SUM(CASE WHEN DS_GENERO = 'FEMININO' THEN 1 ELSE 0 END) AS total_feminino,
        AVG(CASE WHEN DS_COR_RACA = 'PRETA' THEN 1 ELSE 0 END) AS tx_raca_cor_preta,
        SUM(CASE WHEN DS_COR_RACA = 'PRETA' THEN 1 ELSE 0 END) AS total_raca_cor_preta,
        AVG(CASE WHEN DS_COR_RACA IN ('PRETA', 'PARDA') THEN 1 ELSE 0 END) AS tx_raca_cor_preta_parda,
        SUM(CASE WHEN DS_COR_RACA IN ('PRETA', 'PARDA') THEN 1 ELSE 0 END) AS total_raca_cor_preta_parda,
        AVG(CASE WHEN DS_COR_RACA <> 'BRANCA' THEN 1 ELSE 0 END) AS tx_raca_cor_nao_branca,
        SUM(CASE WHEN DS_COR_RACA <> 'BRANCA' THEN 1 ELSE 0 END) AS total_raca_cor_nao_branca,
        count(*) AS total_candidaturas
    FROM tb_info_completa_cand AS t1
    GROUP BY 1,2,3
),

tb_all AS (
    SELECT
        SG_PARTIDO,
        NM_PARTIDO,
        SUM(CASE WHEN SG_UF = 'AC' THEN tx_feminino ELSE 0 END) AS tx_femininoAC,
        SUM(CASE WHEN SG_UF = 'AL' THEN tx_feminino ELSE 0 END) AS tx_femininoAL,
        SUM(CASE WHEN SG_UF = 'AM' THEN tx_feminino ELSE 0 END) AS tx_femininoAM,
        SUM(CASE WHEN SG_UF = 'AP' THEN tx_feminino ELSE 0 END) AS tx_femininoAP,
        SUM(CASE WHEN SG_UF = 'BA' THEN tx_feminino ELSE 0 END) AS tx_femininoBA,
        SUM(CASE WHEN SG_UF = 'CE' THEN tx_feminino ELSE 0 END) AS tx_femininoCE,
        SUM(CASE WHEN SG_UF = 'ES' THEN tx_feminino ELSE 0 END) AS tx_femininoES,
        SUM(CASE WHEN SG_UF = 'GO' THEN tx_feminino ELSE 0 END) AS tx_femininoGO,
        SUM(CASE WHEN SG_UF = 'MA' THEN tx_feminino ELSE 0 END) AS tx_femininoMA,
        SUM(CASE WHEN SG_UF = 'MG' THEN tx_feminino ELSE 0 END) AS tx_femininoMG,
        SUM(CASE WHEN SG_UF = 'MS' THEN tx_feminino ELSE 0 END) AS tx_femininoMS,
        SUM(CASE WHEN SG_UF = 'MT' THEN tx_feminino ELSE 0 END) AS tx_femininoMT,
        SUM(CASE WHEN SG_UF = 'PA' THEN tx_feminino ELSE 0 END) AS tx_femininoPA,
        SUM(CASE WHEN SG_UF = 'PB' THEN tx_feminino ELSE 0 END) AS tx_femininoPB,
        SUM(CASE WHEN SG_UF = 'PE' THEN tx_feminino ELSE 0 END) AS tx_femininoPE,
        SUM(CASE WHEN SG_UF = 'PI' THEN tx_feminino ELSE 0 END) AS tx_femininoPI,
        SUM(CASE WHEN SG_UF = 'PR' THEN tx_feminino ELSE 0 END) AS tx_femininoPR,
        SUM(CASE WHEN SG_UF = 'RJ' THEN tx_feminino ELSE 0 END) AS tx_femininoRJ,
        SUM(CASE WHEN SG_UF = 'RO' THEN tx_feminino ELSE 0 END) AS tx_femininoRO,
        SUM(CASE WHEN SG_UF = 'RS' THEN tx_feminino ELSE 0 END) AS tx_femininoRS,
        SUM(CASE WHEN SG_UF = 'SC' THEN tx_feminino ELSE 0 END) AS tx_femininoSC,
        SUM(CASE WHEN SG_UF = 'SE' THEN tx_feminino ELSE 0 END) AS tx_femininoSE,
        SUM(CASE WHEN SG_UF = 'SP' THEN tx_feminino ELSE 0 END) AS tx_femininoSP,
        SUM(CASE WHEN SG_UF = 'TO' THEN tx_feminino ELSE 0 END) AS tx_femininoTO,
        SUM(CASE WHEN SG_UF = 'RN' THEN tx_feminino ELSE 0 END) AS tx_femininoRN,
        SUM(CASE WHEN SG_UF = 'RR' THEN tx_feminino ELSE 0 END) AS tx_femininoRR,
        1.0 * SUM(total_feminino) / SUM(total_candidaturas) AS tx_femininoBR,

        SUM(CASE WHEN SG_UF = 'AC' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaAC,
        SUM(CASE WHEN SG_UF = 'AL' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaAL,
        SUM(CASE WHEN SG_UF = 'AM' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaAM,
        SUM(CASE WHEN SG_UF = 'AP' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaAP,
        SUM(CASE WHEN SG_UF = 'BA' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaBA,
        SUM(CASE WHEN SG_UF = 'CE' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaCE,
        SUM(CASE WHEN SG_UF = 'ES' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaES,
        SUM(CASE WHEN SG_UF = 'GO' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaGO,
        SUM(CASE WHEN SG_UF = 'MA' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaMA,
        SUM(CASE WHEN SG_UF = 'MG' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaMG,
        SUM(CASE WHEN SG_UF = 'MS' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaMS,
        SUM(CASE WHEN SG_UF = 'MT' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaMT,
        SUM(CASE WHEN SG_UF = 'PA' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaPA,
        SUM(CASE WHEN SG_UF = 'PB' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaPB,
        SUM(CASE WHEN SG_UF = 'PE' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaPE,
        SUM(CASE WHEN SG_UF = 'PI' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaPI,
        SUM(CASE WHEN SG_UF = 'PR' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaPR,
        SUM(CASE WHEN SG_UF = 'RJ' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaRJ,
        SUM(CASE WHEN SG_UF = 'RO' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaRO,
        SUM(CASE WHEN SG_UF = 'RS' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaRS,
        SUM(CASE WHEN SG_UF = 'SC' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaSC,
        SUM(CASE WHEN SG_UF = 'SE' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaSE,
        SUM(CASE WHEN SG_UF = 'SP' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaSP,
        SUM(CASE WHEN SG_UF = 'TO' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaTO,
        SUM(CASE WHEN SG_UF = 'RN' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaRN,
        SUM(CASE WHEN SG_UF = 'RR' THEN tx_raca_cor_preta ELSE 0 END) AS tx_raca_cor_pretaRR,
        1.0 * SUM(total_raca_cor_preta) / sum(total_candidaturas) AS tx_raca_cor_pretaBR,

        SUM(CASE WHEN SG_UF = 'AC' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaAC,
        SUM(CASE WHEN SG_UF = 'AL' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaAL,
        SUM(CASE WHEN SG_UF = 'AM' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaAM,
        SUM(CASE WHEN SG_UF = 'AP' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaAP,
        SUM(CASE WHEN SG_UF = 'BA' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaBA,
        SUM(CASE WHEN SG_UF = 'CE' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaCE,
        SUM(CASE WHEN SG_UF = 'ES' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaES,
        SUM(CASE WHEN SG_UF = 'GO' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaGO,
        SUM(CASE WHEN SG_UF = 'MA' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaMA,
        SUM(CASE WHEN SG_UF = 'MG' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaMG,
        SUM(CASE WHEN SG_UF = 'MS' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaMS,
        SUM(CASE WHEN SG_UF = 'MT' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaMT,
        SUM(CASE WHEN SG_UF = 'PA' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaPA,
        SUM(CASE WHEN SG_UF = 'PB' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaPB,
        SUM(CASE WHEN SG_UF = 'PE' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaPE,
        SUM(CASE WHEN SG_UF = 'PI' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaPI,
        SUM(CASE WHEN SG_UF = 'PR' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaPR,
        SUM(CASE WHEN SG_UF = 'RJ' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaRJ,
        SUM(CASE WHEN SG_UF = 'RO' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaRO,
        SUM(CASE WHEN SG_UF = 'RS' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaRS,
        SUM(CASE WHEN SG_UF = 'SC' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaSC,
        SUM(CASE WHEN SG_UF = 'SE' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaSE,
        SUM(CASE WHEN SG_UF = 'SP' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaSP,
        SUM(CASE WHEN SG_UF = 'TO' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaTO,
        SUM(CASE WHEN SG_UF = 'RN' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaRN,
        SUM(CASE WHEN SG_UF = 'RR' THEN tx_raca_cor_nao_branca ELSE 0 END) AS tx_raca_cor_nao_brancaRR,
        1.0 * SUM(total_raca_cor_nao_branca) / sum(total_candidaturas) AS tx_raca_cor_nao_brancaBR,

        SUM(CASE WHEN SG_UF = 'AC' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaAC,
        SUM(CASE WHEN SG_UF = 'AL' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaAL,
        SUM(CASE WHEN SG_UF = 'AM' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaAM,
        SUM(CASE WHEN SG_UF = 'AP' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaAP,
        SUM(CASE WHEN SG_UF = 'BA' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaBA,
        SUM(CASE WHEN SG_UF = 'CE' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaCE,
        SUM(CASE WHEN SG_UF = 'ES' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaES,
        SUM(CASE WHEN SG_UF = 'GO' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaGO,
        SUM(CASE WHEN SG_UF = 'MA' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaMA,
        SUM(CASE WHEN SG_UF = 'MG' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaMG,
        SUM(CASE WHEN SG_UF = 'MS' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaMS,
        SUM(CASE WHEN SG_UF = 'MT' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaMT,
        SUM(CASE WHEN SG_UF = 'PA' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaPA,
        SUM(CASE WHEN SG_UF = 'PB' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaPB,
        SUM(CASE WHEN SG_UF = 'PE' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaPE,
        SUM(CASE WHEN SG_UF = 'PI' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaPI,
        SUM(CASE WHEN SG_UF = 'PR' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaPR,
        SUM(CASE WHEN SG_UF = 'RJ' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaRJ,
        SUM(CASE WHEN SG_UF = 'RO' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaRO,
        SUM(CASE WHEN SG_UF = 'RS' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaRS,
        SUM(CASE WHEN SG_UF = 'SC' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaSC,
        SUM(CASE WHEN SG_UF = 'SE' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaSE,
        SUM(CASE WHEN SG_UF = 'SP' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaSP,
        SUM(CASE WHEN SG_UF = 'TO' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaTO,
        SUM(CASE WHEN SG_UF = 'RN' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaRN,
        SUM(CASE WHEN SG_UF = 'RR' THEN tx_raca_cor_preta_parda ELSE 0 END) AS tx_raca_cor_preta_pardaRR,
        1.0 * SUM(total_raca_cor_preta_parda) / sum(total_candidaturas) AS tx_raca_cor_preta_pardaBR,

        SUM(total_feminino) AS total_feminino,
        SUM(total_raca_cor_preta) AS total_raca_cor_preta,
        SUM(total_raca_cor_nao_branca) AS total_raca_cor_nao_branca,
        SUM(total_raca_cor_preta_parda) AS total_raca_cor_preta_parda,
        SUM(total_candidaturas) AS total_candidaturas
    FROM tb_group_uf
    GROUP BY 1,2
)

SELECT *
FROM tb_all;