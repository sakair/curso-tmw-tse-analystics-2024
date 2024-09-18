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

tb_group_br AS(
SELECT 
	SG_PARTIDO,
	NM_PARTIDO,
	'BR' AS SG_UF,
	1.0 * SUM(total_feminino) / SUM(total_candidaturas) AS tx_feminino,
	SUM(total_feminino) as total_feminino,
	
	1.0 * SUM(total_raca_cor_preta) / SUM(total_candidaturas) AS tx_raca_cor_preta,
	SUM(total_raca_cor_preta) as total_raca_cor_preta,
	
	1.0 * SUM(total_raca_cor_preta_parda) / SUM(total_candidaturas) AS tx_raca_cor_preta_parda,
	SUM(total_raca_cor_preta_parda) as total_raca_cor_preta_parda,
	
	1.0 * SUM(total_raca_cor_nao_branca) / SUM(total_candidaturas) AS tx_raca_cor_nao_branca,
	SUM(total_raca_cor_nao_branca) as total_raca_cor_nao_branca,
	
	SUM(total_candidaturas) as total_candidaturas
FROM tb_group_uf
GROUP BY
SG_PARTIDO,
NM_PARTIDO
),

tb_union_all AS (
SELECT * FROM tb_group_br

UNION ALL

SELECT * FROM tb_group_uf
)

SELECT * FROM tb_union_all;