# Infraestrutura — Docker PostgreSQL

## Pré-requisitos

- [Docker](https://www.docker.com/) instalado
- [Docker Compose](https://docs.docker.com/compose/) (incluído no Docker Desktop)

## Configuração do Container

| Propriedade | Valor |
|-------------|-------|
| Container | `aurora-postgres` |
| Imagem | `postgres:16` |
| Banco de dados | `aurora_db` |
| Usuário | `aurora_user` |
| Senha | `aurora_pass` |
| Porta | `5432` |

## Como executar

### 1. Subir o container

```bash
cd infra/docker
docker compose up -d
```

Na primeira execução, o script `db/init/cria_banco.sql` será executado automaticamente, criando as tabelas e inserindo os dados de teste.

### 2. Verificar se o container está rodando

```bash
docker ps
```

### 3. Acessar o banco via psql

```bash
docker exec -it aurora-postgres psql -U aurora_user -d aurora_db
```

### 4. Parar o container

```bash
docker compose stop
```

### 5. Remover o container e dados

```bash
docker compose down -v
```

> **Nota:** O flag `-v` remove o volume de dados. Use somente se quiser resetar o banco completamente.

## Troubleshooting

| Problema | Solução |
|----------|---------|
| Porta 5432 em uso | Pare outro serviço PostgreSQL local ou altere a porta no `docker-compose.yml` |
| Script SQL não executou | Remova o volume com `docker compose down -v` e suba novamente |
| Permissão negada | Execute o Docker com permissões de administrador |
