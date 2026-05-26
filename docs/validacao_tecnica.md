# Validação Técnica - Semana 3

Relatório de testes e validação técnica da aplicação e interface analítica da **Rede Comercial Aurora**.

---

## Caso de Teste 1: Execução dos Containers e Criação do Banco

* **Objetivo:** Validar o correto build e inicialização dos serviços dockerizados (PostgreSQL e Flask API) e a criação da infraestrutura de volumes.
* **Passos Executados:**
  1. Parar containers anteriores via terminal: `docker compose down -v`.
  2. Executar inicialização limpa: `docker compose up -d --build`.
  3. Verificar status dos containers via: `docker compose ps`.
* **Resultado Esperado:** Os containers `aurora-postgres` e `aurora-api` devem estar marcados como `running` e saudáveis.
* **Resultado Obtido:** Containers inicializados e rodando com sucesso nos respectivos mapeamentos de portas (`5434:5432` para PostgreSQL e `5000:5000` para Flask).
* **Evidência:**
  ```text
  [+] Running 3/3
   ✔ Network docker_default  Created
   ✔ Container aurora-postgres  Started
   ✔ Container aurora-api       Started
  ```
* **Problema Encontrado:** Nenhum.

---

## Caso de Teste 2: Criação do Banco de Dados e Execução do Script SQL

* **Objetivo:** Confirmar que a estrutura de tabelas, índices e *Materialized Views* foi criada corretamente no banco `aurora_db`.
* **Passos Executados:**
  1. Acessar o terminal do banco: `docker exec -it aurora-postgres psql -U aurora_user -d aurora_db`.
  2. Executar listagem de tabelas e views: `\dt` e `\dv` ou `\dm`.
* **Resultado Esperado:** Listagem contendo as tabelas `vendas`, `itens_venda`, `produtos`, `categorias`, `filiais` e `calendario`, além da Materialized View principal `v_indicadores_venda`.
* **Resultado Obtido:** Banco de dados populado com 6 tabelas físicas e as Materialized Views do escopo analítico prontas para consulta.
* **Evidência:**
  ```text
                  List of relations
   Schema |          Name          |       Type        |    Owner
  --------+------------------------+-------------------+-------------
   public | calendario             | table             | aurora_user
   public | categorias             | table             | aurora_user
   public | filiais                | table             | aurora_user
   public | itens_venda            | table             | aurora_user
   public | produtos               | table             | aurora_user
   public | v_indicadores_venda    | materialized view | aurora_user
   public | vendas                 | table             | aurora_user
  ```
* **Problema Encontrado:** Nenhum.

---

## Caso de Teste 3: Conexão da Aplicação API com o Banco de Dados

* **Objetivo:** Assegurar que a API Flask consegue se conectar e efetuar chamadas bem-sucedidas ao banco de dados PostgreSQL.
* **Passos Executados:**
  1. Efetuar requisição HTTP GET para a rota de integridade da API: `curl http://localhost:5000/api/health`.
* **Resultado Esperado:** Resposta JSON com status 200: `{"status": "ok"}`.
* **Resultado Obtido:** Resposta JSON com status `ok` em tempo de resposta inferior a 25ms.
* **Problema Encontrado:** Nenhum.

---

## Caso de Teste 4: Abertura da Interface Principal (Front-End)

* **Objetivo:** Abrir a interface web integrada da aplicação no navegador e verificar se carrega de forma assíncrona.
* **Passos Executados:**
  1. Abrir navegador no endereço: `http://localhost:5000/`.
* **Resultado Esperado:** Carregamento de uma página com tema profissional (dashboard corporativo), carregamento dos dados iniciais nos 8 cards de indicadores e renderização dos 3 gráficos interativos e tabela de ranking.
* **Resultado Obtido:** Página principal renderizada com sucesso, carregando dinamicamente os valores de faturamento do banco de dados e os eixos dos gráficos de forma animada.
* **Problema Encontrado:** Nenhum.

---

## Caso de Teste 5: Cálculo dos Indicadores Obrigatórios

* **Objetivo:** Validar a precisão aritmética e formatação dos cálculos exibidos em pelo menos 3 indicadores principais contra dados brutos do banco de dados.
* **Passos Executados:**
  1. Verificar dados nos KPI Cards na abertura (Filtros Limpos):
     - **Faturamento Bruto**
     - **Receita Líquida**
     - **Margem Bruta %**
  2. Executar consulta SQL direta na materialized view geral `v_resumo_indicadores` para conferência matemática.
* **Resultado Esperado:** 
  - Faturamento Bruto: `R$ 49.336,60`
  - Receita Líquida: `R$ 47.925,25`
  - Margem Bruta %: `46,00%`
* **Resultado Obtido:** Os valores nos KPI cards coincidem exatamente com o cálculo materializado no banco de dados e são apresentados com efeito de contagem progressiva ao carregar.
* **Evidência:**
  ```sql
  SELECT faturamento_bruto, receita_liquida, margem_bruta_pct FROM v_resumo_indicadores;
  -- faturamento_bruto = 49336.60, receita_liquida = 47925.25, margem_bruta_pct = 46.00%
  ```
* **Problema Encontrado:** Nenhum.

---

## Caso de Teste 6: Aplicação de Filtros na Interface

* **Objetivo:** Validar que a aplicação de pelo menos 2 filtros altera dinamicamente e corretamente as visualizações e indicadores da tela comercial.
* **Passos Executados:**
  1. Na barra lateral de filtros, selecionar no dropdown de **Filial** a opção: `Aurora Centro`.
  2. Selecionar no dropdown de **Categoria** a opção: `Alimentos`.
  3. Clicar no botão **Aplicar Filtros**.
  4. Analisar alteração nos números de KPIs e gráficos.
* **Resultado Esperado:**
  - Os indicadores devem atualizar e mostrar apenas os resultados da filial `Aurora Centro` sob a categoria `Alimentos`.
  - Os gráficos de Faturamento Mensal, Análise de Categorias (mostrando apenas Alimentos) e Ranking devem refletir a nova seleção.
* **Resultado Obtido:** Todos os cards de métricas (Faturamento Bruto, Quantidade, Receita, Margem, Custo, Ticket) sofreram transição animada de valores. Os gráficos e a tabela de produtos mais vendidos foram redesenhados na hora com a fatia correta dos dados.
* **Problema Encontrado:** Nenhum.
