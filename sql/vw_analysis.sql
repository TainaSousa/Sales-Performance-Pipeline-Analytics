-------------------------------------------------
-- Criação de Views - Performance por Região
-------------------------------------------------

CREATE VIEW vw_performance_regiao AS
SELECT 
    st.regional_office,
	COUNT(*) as total_venda,
	COUNT(CASE WHEN fp.deal_stage = 'Won' THEN 1 END) AS deals_ganhas,
    SUM(fp.close_value) AS receita_total,
   ROUND(
    COUNT(CASE WHEN fp.deal_stage = 'Won' THEN 1 END)::NUMERIC / 
    NULLIF(COUNT(*), 0) * 100, 
    2
) AS taxa_conversao_pct
FROM fact_sales_pipeline fp
LEFT JOIN dim_sales_teams st ON fp.sales_agent = st.sales_agent
GROUP BY st.regional_office


--------------------------------------------------
-- Criação de Views - Produtos por Receita
--------------------------------------------------

CREATE VIEW vw_top_produtos AS
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

--------------------------------------
-- Criação de Views - Vendas Mensais
--------------------------------------

CREATE VIEW  vw_vendas_mensais AS
SELECT 
    TO_CHAR(fp.engage_date, 'YYYY-MM') AS mes_referencia,
    COUNT(*) AS total_deals,
    COUNT(CASE WHEN fp.deal_stage = 'Won' THEN 1 END) AS deals_ganhas,
    SUM(CASE WHEN fp.deal_stage = 'Won' THEN fp.close_value ELSE 0 END) AS receita,  
    ROUND(
        COUNT(CASE WHEN fp.deal_stage = 'Won' THEN 1 END)::NUMERIC /  
        COUNT(*) * 100, 
        2
    ) AS taxa_conversao_pct
FROM fact_sales_pipeline fp
WHERE fp.engage_date IS NOT NULL
GROUP BY  TO_CHAR(fp.engage_date, 'YYYY-MM');


-----------------------------------------
-- Criação de Views - Funil de Vendas
-----------------------------------------

CREATE VIEW vw_funil_vendas AS
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
GROUP BY fp.deal_stage;


-------------------------------------------------
-- Criação de Views - Performace por gerentes
-------------------------------------------------

CREATE VIEW vw_performance_gerentes AS
SELECT 
    st.manager,
    st.regional_office,
    COUNT(DISTINCT st.sales_agent) AS qtd_vendedores,
    COUNT(*) AS total_deals,
    COUNT(CASE WHEN fp.deal_stage = 'Won' THEN 1 END) AS deals_ganhos,
    ROUND(
        COUNT(CASE WHEN fp.deal_stage = 'Won' THEN 1 END)::NUMERIC /
        NULLIF(COUNT(*), 0) * 100,
        2
    ) AS taxa_conversao_pct,
    SUM(CASE WHEN fp.deal_stage = 'Won' THEN fp.close_value ELSE 0 END) AS receita_total,
    ROUND(
        SUM(CASE WHEN fp.deal_stage = 'Won' THEN fp.close_value ELSE 0 END) /
        COUNT(DISTINCT st.sales_agent),
        2
    ) AS receita_por_vendedor
FROM fact_sales_pipeline fp
LEFT JOIN dim_sales_teams st ON fp.sales_agent = st.sales_agent
GROUP BY st.manager, st.regional_office;