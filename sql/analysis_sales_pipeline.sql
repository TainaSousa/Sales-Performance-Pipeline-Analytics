---------------------------------------------------------------------
-- Ánalise: Performance por Região
-- Objetivo: Avaliar qual região gera mais receita e tem melhor taxa de conversão
---------------------------------------------------------------------

SELECT 
    st.regional_office,
	COUNT(*) as total_venda,
	COUNT(CASE WHEN fp.deal_stage = 'Won' THEN 1 END) AS vendas_ganhas,
    SUM(fp.close_value) AS receita_total,
   ROUND(
    COUNT(CASE WHEN fp.deal_stage = 'Won' THEN 1 END)::NUMERIC / 
    NULLIF(COUNT(*), 0) * 100, 
    2
) AS taxa_conversao_pct
FROM fact_sales_pipeline fp
LEFT JOIN dim_sales_teams st ON fp.sales_agent = st.sales_agent
GROUP BY st.regional_office
ORDER BY st.regional_office


-----------------------------------------------------------------------
--- Ánalise: Top 7 Produtos por Receita
-- Ojetivo: Identificar produtos mais lucrativos e padrões de venda
-----------------------------------------------------------------------

SELECT 
    p.product,
	p.series,
    COUNT(*) AS qtd_product,
    SUM(fp.close_value) AS receita_product,
    AVG(fp.close_value) AS receita_media_por_venda
FROM fact_sales_pipeline fp
LEFT JOIN dim_products p ON fp.product = p.product
WHERE fp.deal_stage = 'Won' 
GROUP BY p.product, p.series
ORDER BY receita_product DESC
LIMIT 7;


-------------------------------------------------------------------------
-- Ánalise: Ciclo de Vendas por Produto
-- Objetivo: Entender tempo necessário para fechar cada tipo de produto
-------------------------------------------------------------------------

SELECT 
    p.product,
    COUNT(*) AS qtd_vendas,
	ROUND(AVG(fp.close_date::DATE - fp.engage_date::DATE), 0) AS media_dias,
    MIN(fp.close_date::DATE - fp.engage_date::DATE) AS min_dias,
    MAX(fp.close_date::DATE - fp.engage_date::DATE) AS max_dias
FROM fact_sales_pipeline fp
LEFT JOIN dim_products p ON fp.product = p.product
WHERE fp.deal_stage = 'Won' 
AND fp.engage_date IS NOT NULL
AND fp.close_date IS NOT NULL
GROUP BY p.product
ORDER BY media_dias 
limit 10;

-----------------------------------------------------------------------
-- Ánalise: Performance dos Gerentes
-- Objetivo: Avaliar desempenho de cada gerente através de seu time
-----------------------------------------------------------------------

SELECT 
    st.manager,
    st.regional_office,
    COUNT(DISTINCT st.sales_agent) AS vendedores,
    COUNT(*) AS total_vendas,
    COUNT(CASE WHEN fp.deal_stage = 'Won' THEN 1 END) AS vendas_ganhas,
    ROUND(
        COUNT(CASE WHEN fp.deal_stage = 'Won' THEN 1 END)::NUMERIC / 
        COUNT(*) * 100, 
        2
    ) AS taxa_conversao_pct,
    SUM(CASE WHEN fp.deal_stage = 'Won' THEN fp.close_value ELSE 0 END) AS receita_total,
    ROUND(
       SUM(CASE WHEN fp.deal_stage = 'Won' THEN fp.close_value ELSE 0 END) / 
        NULLIF(COUNT(DISTINCT st.sales_agent), 0), 
        2
    ) AS receita_por_vendedor
FROM fact_sales_pipeline fp
LEFT JOIN dim_sales_teams st ON fp.sales_agent = st.sales_agent
GROUP BY st.manager, st.regional_office
ORDER BY receita_total DESC;

-------------------------------------------------------------------------------
-- Ánalise: Top 5 Clientes
-- Objetivo: Identificar clientes mais valiosos e padrões de compra
-------------------------------------------------------------------------------

SELECT 
    a.account,
    a.sector,
    a.office_location,
    a.subsidiary_of,
    SUM(fp.close_value) AS receita_cliente
FROM fact_sales_pipeline fp
LEFT JOIN dim_accounts a ON fp.account = a.account
WHERE fp.deal_stage = 'Won' 
AND a.account IS NOT NULL
GROUP BY a.account, a.sector, a.office_location, a.subsidiary_of
ORDER BY receita_cliente DESC
LIMIT 5;


----------------------------------------------------------------------------
-- Ánalise: Vendas Mensais
-- Objetivo: Entender evolução do negócio ao longo do tempo e identificar sazonalidade
----------------------------------------------------------------------------


SELECT 
    TO_CHAR(fp.engage_date, 'YYYY-MM') AS mes_referencia,
    COUNT(*) AS total_deals,
    COUNT(CASE WHEN fp.deal_stage = 'Won' THEN 1 END) AS deals_ganhos,
    SUM(CASE WHEN fp.deal_stage = 'Won' THEN fp.close_value ELSE 0 END) AS receita,  
    ROUND(
        COUNT(CASE WHEN fp.deal_stage = 'Won' THEN 1 END)::NUMERIC /  
        COUNT(*) * 100, 
        2
    ) AS taxa_conversao_pct
FROM fact_sales_pipeline fp
WHERE fp.engage_date IS NOT NULL
GROUP BY  mes_referencia
ORDER BY mes_referencia


---------------------------------------------------------------------------
-- Ánalise: Funil de Vendas
-- Objetivo: Visualizar fluxo de oportunidades pelos estágios e identificar gargalos
---------------------------------------------------------------------------


SELECT
   fp.deal_stage,
   COUNT(*) AS qtd_deals,
  ROUND(
    COUNT(*) * 100.0 / 
    (SELECT COUNT(*) 
     FROM fact_sales_pipeline 
     WHERE deal_stage IS NOT NULL),
    2
) AS percentual_deals,

    SUM(COALESCE(fp.close_value, 0)) AS receita_potencial,
    ROUND(
        SUM(COALESCE(fp.close_value, 0)) * 100.0 /
        NULLIF(
            (SELECT SUM(COALESCE(close_value, 0)) 
             FROM fact_sales_pipeline),0),
        2
    ) AS percentual_receita
FROM fact_sales_pipeline fp
GROUP BY fp.deal_stage
ORDER BY
    CASE 
        WHEN fp.deal_stage = 'Prospecting' THEN 1
        WHEN fp.deal_stage = 'Engaging' THEN 2
        WHEN fp.deal_stage = 'Won' THEN 3
        WHEN fp.deal_stage = 'Lost' THEN 4
        ELSE 5
    END;
