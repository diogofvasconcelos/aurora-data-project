# Rede Comercial Aurora

Sistema de consulta e análise de desempenho comercial da **Rede Comercial Aurora**, desenvolvido como projeto da disciplina de Projeto de Sistemas.

## Integrantes

<!-- Adicione os nomes dos integrantes do grupo abaixo -->
- Integrante 1
- Integrante 2
- Integrante 3
- Integrante 4

## Descrição do Projeto

A Rede Comercial Aurora precisa de um sistema para consultar e analisar seu desempenho comercial. Este projeto implementa a infraestrutura de dados necessária para calcular indicadores como faturamento, receita líquida, margem bruta e ticket médio, permitindo análises por filial, categoria, produto e período.

### Perguntas de Negócio

O sistema responde às seguintes perguntas:

1. Qual foi o faturamento total por mês?
2. Quais filiais tiveram maior receita líquida no período analisado?
3. Quais categorias de produto geraram maior receita líquida?
4. Quais produtos tiveram maior quantidade vendida?
5. Como a margem bruta varia por mês, filial e categoria?

### Indicadores

- Faturamento bruto
- Desconto total
- Receita líquida
- Custo total
- Margem bruta
- Margem bruta percentual
- Quantidade vendida
- Ticket médio

## Estrutura do Repositório

```
aurora/
├── db/
│   ├── init/
│   │   └── cria_banco.sql          # Script SQL de criação e dados de teste
│   └── docs/
│       └── modelo_banco.md         # Modelo técnico do banco de dados
├── infra/
│   └── docker/
│       ├── docker-compose.yml      # Container PostgreSQL
│       └── README.md               # Instruções do Docker
├── docs/
│   ├── requisitos_tecnicos.md      # Requisitos e especificações técnicas
│   ├── entregas.md                 # Controle de entregas por semana
│   └── REQUISITO_01_SEMANA_01_*.md # Requisitos do professor
└── README.md                       # Este arquivo
```

## Tecnologias

- **PostgreSQL 16** — Banco de dados relacional
- **Docker** — Containerização do ambiente
- **SQL** — Consultas e manipulação de dados

## Como Executar

### Pré-requisitos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado

### Passos

1. Clone o repositório:
   ```bash
   git clone <url-do-repositorio>
   cd aurora
   ```

2. Suba o banco de dados:
   ```bash
   cd infra/docker
   docker compose up -d
   ```

3. Acesse o banco:
   ```bash
   docker exec -it aurora-postgres psql -U aurora_user -d aurora_db
   ```

4. Execute consultas de validação (já inclusas no script de inicialização).

### Parar o ambiente

```bash
cd infra/docker
docker compose down
```

## Documentação

- [Modelo do Banco de Dados](db/docs/modelo_banco.md)
- [Requisitos Técnicos](docs/requisitos_tecnicos.md)
- [Controle de Entregas](docs/entregas.md)
- [Instruções Docker](infra/docker/README.md)
