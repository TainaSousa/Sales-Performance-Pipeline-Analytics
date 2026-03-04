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


## 📂 Estrutura do Projeto

sales-performance-bi/
│
├── 📁 data/
│   ├── 📁 raw/                 # Dados originais (não modificados)
│   │   ├── sales_pipeline.csv  # 8.800 oportunidades
│   │   ├── products.csv        # 7 produtos
│   │   ├── sales_teams.csv     # 35 vendedores
│   │   └── accounts.csv        # 85 clientes
│   │
│   └── 📁 processed/           # Dados limpos e transformados
│       ├── sales_data_clean.csv      # Dataset master (8.800 linhas)
│       ├── dim_products.csv          # Dimensão produtos (7)
│       ├── dim_sales_teams.csv       # Dimensão vendedores (30)
│       ├── dim_accounts.csv          # Dimensão clientes (85)
│       └── fact_sales_pipeline.csv   # Tabela fato (8.800)
│
|── 📁 docs/
│   └── data_dictionary.txt    #  Dicionario dos dados contidos nas tabelas 
|
|
| ── 📁 images/                  # Screenshots dos dashboards
│   ├── dashboard_overview.png       # KPIs executivos
│   ├── dashboard_products.png       # Análise de produtos
│   ├── dashboard_funnel.png         # Funil de vendas
│   └── dashboard_managers.png       # Performance gerentes
│
├── 📁 notebooks/
│   └── sales_analysis.ipynb    # Análise completa em Python/Pandas
|
|
├──📁 sql/
│   ├── analises_sales_pipeline.sql  # 7 queries analíticas
│   └── vw_analises.sql              # 4 views para Power BI
│
├── .gitignore                  # Arquivos ignorados pelo Git
├── README.md                   # Documentação do projeto
└── requirements.txt            # Dependências Python (pandas, jupyter)
