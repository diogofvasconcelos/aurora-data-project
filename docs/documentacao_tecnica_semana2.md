# Semana 2 - Dados, Consultas e Servicos

## Objetivo

Esta entrega amplia a base de dados da Rede Comercial Aurora, cria as 5 consultas obrigatorias com filtros reais e adiciona uma primeira camada tecnica de acesso aos dados usando Python e Flask.

## Como Subir o Ambiente

```bash
cd infra/docker
docker compose up -d --build
```

Servicos disponiveis:

- PostgreSQL: `localhost:5434`
- API Flask: `http://localhost:5000`

Para recriar o banco do zero:

```bash
cd infra/docker
docker compose down -v
docker compose up -d --build
```

## Como Executar o Script SQL

O Docker Compose monta o arquivo `db/init/cria_banco.sql` em `/docker-entrypoint-initdb.d/cria_banco.sql`. O PostgreSQL executa esse script automaticamente quando o volume do banco e criado pela primeira vez.

Execucao manual:

```bash
docker exec -i aurora-postgres psql -U aurora_user -d aurora_db < ../../db/init/cria_banco.sql
```

## Tabelas

| Tabela | Descricao |
|--------|-----------|
| `calendario` | Datas de 2024 usadas nas vendas, com mes, trimestre e dia da semana |
| `filiais` | 5 unidades da Rede Comercial Aurora |
| `categorias` | Categorias comerciais dos produtos |
| `produtos` | 20 produtos com preco e custo unitario |
| `vendas` | 120 vendas distribuidas entre filiais e meses |
| `itens_venda` | 360 itens vinculados as vendas |

## Materialized Views

| Materialized view | Uso |
|-------------------|-----|
| `v_indicadores_venda` | Base analitica por item de venda |
| `v_faturamento_mensal` | Faturamento total por mes |
| `v_receita_por_filial` | Receita, custo e margem por filial |
| `v_receita_por_categoria` | Receita, quantidade e margem por categoria |
| `v_quantidade_por_produto` | Produtos mais vendidos |
| `v_margem_bruta` | Margem por mes, filial e categoria |
| `v_ticket_medio` | Ticket medio por filial |
| `v_resumo_indicadores` | Resumo geral dos indicadores |

Caso os dados sejam alterados depois da carga inicial, atualize as materialized views:

```sql
REFRESH MATERIALIZED VIEW v_indicadores_venda;
REFRESH MATERIALIZED VIEW v_faturamento_mensal;
REFRESH MATERIALIZED VIEW v_receita_por_filial;
REFRESH MATERIALIZED VIEW v_receita_por_categoria;
REFRESH MATERIALIZED VIEW v_quantidade_por_produto;
REFRESH MATERIALIZED VIEW v_margem_bruta;
REFRESH MATERIALIZED VIEW v_ticket_medio;
REFRESH MATERIALIZED VIEW v_resumo_indicadores;
```

## Consultas Criadas

As 5 consultas obrigatorias estao em `db/consultas/consultas.sql`.

| Consulta | Indicadores retornados |
|----------|------------------------|
| Faturamento total por mes | faturamento bruto, desconto total, receita liquida, quantidade vendida, quantidade de vendas |
| Receita liquida por filial | faturamento bruto, desconto total, receita liquida, custo total, margem bruta, margem bruta percentual |
| Receita liquida por categoria | quantidade vendida, faturamento bruto, receita liquida, margem bruta, margem bruta percentual |
| Produtos mais vendidos | produto, categoria, quantidade vendida, faturamento bruto, receita liquida |
| Margem bruta por mes, filial e categoria | receita liquida, custo total, margem bruta, margem bruta percentual |

## Filtros

As consultas SQL usam parametros:

- `$1`: data inicial
- `$2`: data final
- `$3`: filial_id
- `$4`: produto_id
- `$5`: categoria_id

Na API, os filtros equivalentes sao enviados pela URL:

- `data_inicio`
- `data_fim`
- `filial_id`
- `produto_id`
- `categoria_id`

Exemplos:

```bash
curl "http://localhost:5000/api/faturamento-mensal?data_inicio=2024-01-01&data_fim=2024-06-30"
curl "http://localhost:5000/api/receita-filial?filial_id=1"
curl "http://localhost:5000/api/produtos-mais-vendidos?categoria_id=4"
```

## API

Estrutura da camada tecnica:

| Arquivo | Responsabilidade |
|---------|------------------|
| `app/config.py` | Configuracao de conexao por variaveis de ambiente |
| `app/database.py` | Pool de conexoes e execucao das consultas |
| `app/queries.py` | SQL usado pela API com filtros dinamicos |
| `app/services.py` | Validacao e preparo dos filtros |
| `app/routes.py` | Endpoints REST |
| `app/app.py` | Inicializacao do Flask |

Endpoints:

- `GET /api/faturamento-mensal`
- `GET /api/receita-filial`
- `GET /api/receita-categoria`
- `GET /api/produtos-mais-vendidos`
- `GET /api/margem-bruta`

## Validacoes Recomendadas

```sql
SELECT COUNT(*) FROM filiais;
SELECT COUNT(*) FROM categorias;
SELECT COUNT(*) FROM produtos;
SELECT COUNT(*) FROM vendas;
SELECT COUNT(*) FROM itens_venda;
SELECT COUNT(DISTINCT DATE_TRUNC('month', data_venda)) FROM vendas;
```

Resultados esperados:

- `filiais`: 5
- `categorias`: 6
- `produtos`: 20
- `vendas`: 120
- `itens_venda`: 360
- meses distintos com venda: 12
