# Infraestrutura - Docker

## Pre-requisitos

- Docker Desktop instalado

## Servicos

| Servico | Container | Porta local | Uso |
|---------|-----------|-------------|-----|
| PostgreSQL | `aurora-postgres` | `5434` | Banco `aurora_db` |
| API Flask | `aurora-api` | `5000` | Endpoints REST |

Credenciais do banco:

- Database: `aurora_db`
- Usuario: `aurora_user`
- Senha: `aurora_pass`

## Como Executar

```bash
cd infra/docker
docker compose up -d --build
```

Na primeira execucao, o script `db/init/cria_banco.sql` cria as tabelas, insere os dados de teste e cria as materialized views.

## Acessar o Banco

```bash
docker exec -it aurora-postgres psql -U aurora_user -d aurora_db
```

## Testar a API

```bash
curl "http://localhost:5000/api/health"
curl "http://localhost:5000/api/faturamento-mensal"
```

## Parar

```bash
docker compose stop
```

## Resetar Banco e Volumes

```bash
docker compose down -v
docker compose up -d --build
```

Use `down -v` somente quando quiser recriar o banco completamente.

## Troubleshooting

| Problema | Solucao |
|----------|---------|
| Porta `5434` em uso | Altere a porta local do PostgreSQL no `docker-compose.yml` |
| Porta `5000` em uso | Altere a porta local da API no `docker-compose.yml` |
| Script SQL nao executou | Rode `docker compose down -v` e suba novamente |
| API nao conecta ao banco | Verifique se `aurora-postgres` esta em execucao |
