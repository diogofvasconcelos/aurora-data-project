# Rede Comercial Aurora

Sistema de consulta e analise de desempenho comercial da **Rede Comercial Aurora**, desenvolvido como projeto da disciplina de Projeto de Sistemas.

## Integrantes

- Diogo Lucas Ferreira Vasconcelos
- Kamilly
- Stenio
- Alexandre
- Pablo

## Descricao do Projeto

A Rede Comercial Aurora precisa de um sistema para consultar e analisar seu desempenho comercial. Este projeto implementa a infraestrutura de dados e uma API inicial para calcular indicadores como faturamento, receita liquida, margem bruta e ticket medio, com analises por filial, categoria, produto e periodo.

## Perguntas de Negocio

1. Qual foi o faturamento total por mes?
2. Quais filiais tiveram maior receita liquida no periodo analisado?
3. Quais categorias de produto geraram maior receita liquida?
4. Quais produtos tiveram maior quantidade vendida?
5. Como a margem bruta varia por mes, filial e categoria?

## Tecnologias

- PostgreSQL 16
- Docker Compose
- Python 3.12
- Flask
- psycopg2
- SQL com materialized views

## Estrutura do Repositorio

```text
aurora/
|-- app/
|   |-- app.py
|   |-- config.py
|   |-- database.py
|   |-- queries.py
|   |-- routes.py
|   |-- services.py
|   |-- Dockerfile
|   `-- requirements.txt
|-- db/
|   |-- consultas/
|   |   `-- consultas.sql
|   |-- docs/
|   |   `-- modelo_banco.md
|   `-- init/
|       `-- cria_banco.sql
|-- docs/
|   |-- entregas.md
|   |-- semana2.md
|   |-- requisitos_tecnicos.md
|   |-- REQUISITO_01_SEMANA_01_REPOSITORIO_BANCO_E_INFRAESTRUTURA.md
|   `-- REQUISITO_02_SEMANA_02_DADOS_CONSULTAS_E_SERVICOS.md
|-- infra/
|   `-- docker/
|       |-- docker-compose.yml
|       `-- README.md
`-- README.md
```

## Como Executar

### Pre-requisitos

- Docker Desktop instalado

### Subir banco e API

```bash
cd infra/docker
docker compose up -d --build
```

Servicos:

- PostgreSQL: `localhost:5434`
- API Flask: `http://localhost:5000`

### Acessar o banco

```bash
docker exec -it aurora-postgres psql -U aurora_user -d aurora_db
```

### Testar a API

```bash
curl "http://localhost:5000/api/faturamento-mensal"
curl "http://localhost:5000/api/receita-filial?data_inicio=2024-01-01&data_fim=2024-06-30"
curl "http://localhost:5000/api/produtos-mais-vendidos?filial_id=1&categoria_id=4"
```

Filtros disponiveis nos endpoints:

- `data_inicio` no formato `YYYY-MM-DD`
- `data_fim` no formato `YYYY-MM-DD`
- `filial_id`
- `produto_id`
- `categoria_id`

### Parar o ambiente

```bash
cd infra/docker
docker compose down
```

Para recriar o banco do zero e executar novamente o script inicial:

```bash
cd infra/docker
docker compose down -v
docker compose up -d --build
```

## Documentacao

- [Semana 2](docs/semana2.md)
- [Modelo do Banco de Dados](db/docs/modelo_banco.md)
- [Requisitos Tecnicos](docs/requisitos_tecnicos.md)
- [Controle de Entregas](docs/entregas.md)
- [Instrucoes Docker](infra/docker/README.md)
