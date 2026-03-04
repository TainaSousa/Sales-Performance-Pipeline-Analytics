# 📊 Análise de Pipeline de Vendas B2B

![Python](https://img.shields.io/badge/Python-3.9+-blue.svg)
![SQL](https://img.shields.io/badge/SQL-PostgreSQL-336791.svg)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811.svg)



## Sobre o Projeto

Análise completa de pipeline de vendas de uma empresa B2B SaaS, utilizando **Python** para limpeza e exploração, **PostgreSQL** para modelagem dimensional, e **Power BI** para dashboards interativos.

**Período Analisado:** Outubro/2016 - Dezembro/2017 (15 meses)  
**Dataset:** 8.800 oportunidades de venda | 85 clientes corporativos



##  Contexto de Negócio

**Empresa:** OptiSuite (fictícia - dataset público)  
**Segmento:** Software B2B (SaaS)  
**Produtos:** 3 linhas de produtos (GTX, MG, GTK) com 7 SKUs



##  Principais Resultados

### KPIs do Negócio:
- **Taxa de Conversão:** 48.16% (excelente para B2B!)
- **Receita Total:** $10.01M
- **Ticket Médio:** $2,361
- **Ciclo de Vendas:** 52 dias
- **Taxa de sucesso:** 63%

### Insights Críticos:

#### **Alerta de Pipeline**
- Apenas **5.7%** das oportunidades em Prospecting
- **Recomendação:** Investimento urgente em geração de leads

####  **Produto Campeão**
- **GTX Pro** domina com $3.5M (35% da receita)
- Melhor ciclo de vendas: 48 dias
- 729 unidades vendidas

#### **Problemas Identificados**
- **MG Special:** Sub-precificado ($55/unidade com 793 vendas)
- **GTK 500:** Produto premium ($26k) com apenas 15 vendas
- **West Região:** Alto volume mas conversão 3% menor que East

---

## Tecnologias Utilizadas

### Análise e Processamento:
- **Python 3.9+**
  - Pandas: Manipulação de dados
  - NumPy: Operações numéricas
  - Matplotlib/Seaborn: Visualizações exploratórias

### Banco de Dados:
- **PostgreSQL 17**
  - Modelagem dimensional (Star Schema)
  - 4 tabelas (3 dimensões + 1 fato)
  - 4 views analíticas para BI

### Business Intelligence:
- **Power BI Desktop**
  - 4 dashboards interativos
  - 15+ medidas DAX
  - Drill-down e filtros cruzados

---

## 📂 Estrutura do Projeto