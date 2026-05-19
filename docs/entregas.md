# Entregas - Rede Comercial Aurora

## Semana 1: Repositorio, Banco de Dados e Infraestrutura

| # | Entrega | Status |
|---|---------|--------|
| 1 | Repositorio Git criado e compartilhado | Concluido |
| 2 | Estrutura inicial de pastas organizada | Concluido |
| 3 | Modelo tecnico do banco documentado (`db/docs/modelo_banco.md`) | Concluido |
| 4 | Docker Compose para PostgreSQL (`infra/docker/docker-compose.yml`) | Concluido |
| 5 | Script SQL inicial (`db/init/cria_banco.sql`) | Concluido |
| 6 | Documentacao tecnica (`docs/requisitos_tecnicos.md`) | Concluido |
| 7 | README com instrucoes de execucao | Concluido |

### Detalhes da Semana 1

- Banco com 6 tabelas principais: `calendario`, `filiais`, `categorias`, `produtos`, `vendas`, `itens_venda`.
- Infraestrutura inicial com PostgreSQL em Docker.
- Consultas iniciais para validacao dos indicadores.

---

## Semana 2: Dados, Consultas e Servicos

| # | Entrega | Status |
|---|---------|--------|
| 1 | Massa de dados ampliada para 60 datas, 5 filiais, 6 categorias, 20 produtos, 120 vendas e 360 itens | Concluido |
| 2 | Materialized views para indicadores e perguntas de negocio | Concluido |
| 3 | Arquivo `db/consultas/consultas.sql` com 5 consultas parametrizaveis | Concluido |
| 4 | Filtros por periodo, filial, produto e categoria | Concluido |
| 5 | API Flask com separacao entre configuracao, banco, queries, servicos e rotas | Concluido |
| 6 | Docker Compose atualizado com servico `api` | Concluido |
| 7 | Documentacao tecnica da Semana 2 (`docs/semana2.md`) | Concluido |

### Detalhes da Semana 2

- As consultas usam a materialized view base `v_indicadores_venda`.
- O desconto da venda e rateado entre os itens para evitar duplicidade no calculo de receita liquida.
- A API retorna JSON e aceita filtros via query parameters.

---

## Semana 3: Aplicacao

| # | Entrega | Status |
|---|---------|--------|
| 1 | Interface final ou evolucao da aplicacao | Pendente |

> A ser definido conforme os proximos requisitos.
