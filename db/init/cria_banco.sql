-- ============================================================
-- Rede Comercial Aurora — Script de Criação do Banco de Dados
-- ============================================================
-- Este script cria a estrutura inicial do banco aurora_db,
-- insere dados de teste e executa consultas de validação.
-- ============================================================

-- Limpar tabelas caso existam (ordem respeitando dependências)
DROP TABLE IF EXISTS itens_venda CASCADE;
DROP TABLE IF EXISTS vendas      CASCADE;
DROP TABLE IF EXISTS produtos    CASCADE;
DROP TABLE IF EXISTS categorias  CASCADE;
DROP TABLE IF EXISTS filiais     CASCADE;
DROP TABLE IF EXISTS calendario  CASCADE;

-- ============================================================
-- 1. TABELA: calendario
-- ============================================================
CREATE TABLE calendario (
    data_id      DATE        PRIMARY KEY,
    ano          INTEGER     NOT NULL,
    mes          INTEGER     NOT NULL CHECK (mes BETWEEN 1 AND 12),
    dia          INTEGER     NOT NULL CHECK (dia BETWEEN 1 AND 31),
    trimestre    INTEGER     NOT NULL CHECK (trimestre BETWEEN 1 AND 4),
    nome_mes     VARCHAR(20) NOT NULL,
    dia_semana   VARCHAR(20) NOT NULL
);

-- ============================================================
-- 2. TABELA: filiais
-- ============================================================
CREATE TABLE filiais (
    filial_id    SERIAL      PRIMARY KEY,
    nome         VARCHAR(100) NOT NULL,
    cidade       VARCHAR(100) NOT NULL,
    estado       CHAR(2)      NOT NULL,
    ativa        BOOLEAN      NOT NULL DEFAULT TRUE
);

-- ============================================================
-- 3. TABELA: categorias
-- ============================================================
CREATE TABLE categorias (
    categoria_id SERIAL       PRIMARY KEY,
    nome         VARCHAR(100) NOT NULL UNIQUE,
    descricao    TEXT
);

-- ============================================================
-- 4. TABELA: produtos
-- ============================================================
CREATE TABLE produtos (
    produto_id     SERIAL        PRIMARY KEY,
    nome           VARCHAR(150)  NOT NULL,
    categoria_id   INTEGER       NOT NULL REFERENCES categorias(categoria_id),
    preco_unitario NUMERIC(10,2) NOT NULL CHECK (preco_unitario > 0),
    custo_unitario NUMERIC(10,2) NOT NULL CHECK (custo_unitario > 0),
    ativo          BOOLEAN       NOT NULL DEFAULT TRUE
);

-- ============================================================
-- 5. TABELA: vendas
-- ============================================================
CREATE TABLE vendas (
    venda_id     SERIAL        PRIMARY KEY,
    filial_id    INTEGER       NOT NULL REFERENCES filiais(filial_id),
    data_venda   DATE          NOT NULL REFERENCES calendario(data_id),
    desconto     NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (desconto >= 0)
);

-- ============================================================
-- 6. TABELA: itens_venda
-- ============================================================
CREATE TABLE itens_venda (
    item_id            SERIAL        PRIMARY KEY,
    venda_id           INTEGER       NOT NULL REFERENCES vendas(venda_id),
    produto_id         INTEGER       NOT NULL REFERENCES produtos(produto_id),
    quantidade         INTEGER       NOT NULL CHECK (quantidade > 0),
    preco_unitario     NUMERIC(10,2) NOT NULL CHECK (preco_unitario > 0),
    desconto_item      NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (desconto_item >= 0)
);

-- ============================================================
-- INSERÇÃO DE DADOS DE TESTE
-- ============================================================

-- Calendário: janeiro a dezembro de 2024 (dias 1, 10 e 20 de cada mês)
INSERT INTO calendario (data_id, ano, mes, dia, trimestre, nome_mes, dia_semana) VALUES
('2024-01-10', 2024, 1,  10, 1, 'Janeiro',   'Quarta'),
('2024-01-20', 2024, 1,  20, 1, 'Janeiro',   'Sábado'),
('2024-02-10', 2024, 2,  10, 1, 'Fevereiro', 'Sábado'),
('2024-02-20', 2024, 2,  20, 1, 'Fevereiro', 'Terça'),
('2024-03-10', 2024, 3,  10, 1, 'Março',     'Domingo'),
('2024-03-20', 2024, 3,  20, 1, 'Março',     'Quarta'),
('2024-04-10', 2024, 4,  10, 2, 'Abril',     'Quarta'),
('2024-04-20', 2024, 4,  20, 2, 'Abril',     'Sábado'),
('2024-05-10', 2024, 5,  10, 2, 'Maio',      'Sexta'),
('2024-05-20', 2024, 5,  20, 2, 'Maio',      'Segunda'),
('2024-06-10', 2024, 6,  10, 2, 'Junho',     'Segunda'),
('2024-06-20', 2024, 6,  20, 2, 'Junho',     'Quinta'),
('2024-07-10', 2024, 7,  10, 3, 'Julho',     'Quarta'),
('2024-07-20', 2024, 7,  20, 3, 'Julho',     'Sábado'),
('2024-08-10', 2024, 8,  10, 3, 'Agosto',    'Sábado'),
('2024-08-20', 2024, 8,  20, 3, 'Agosto',    'Terça'),
('2024-09-10', 2024, 9,  10, 3, 'Setembro',  'Terça'),
('2024-09-20', 2024, 9,  20, 3, 'Setembro',  'Sexta'),
('2024-10-10', 2024, 10, 10, 4, 'Outubro',   'Quinta'),
('2024-10-20', 2024, 10, 20, 4, 'Outubro',   'Domingo'),
('2024-11-10', 2024, 11, 10, 4, 'Novembro',  'Domingo'),
('2024-11-20', 2024, 11, 20, 4, 'Novembro',  'Quarta'),
('2024-12-10', 2024, 12, 10, 4, 'Dezembro',  'Terça'),
('2024-12-20', 2024, 12, 20, 4, 'Dezembro',  'Sexta');

-- Filiais
INSERT INTO filiais (nome, cidade, estado) VALUES
('Aurora Centro',    'São Paulo',       'SP'),
('Aurora Sul',       'Curitiba',        'PR'),
('Aurora Norte',     'Manaus',          'AM'),
('Aurora Litoral',   'Florianópolis',   'SC'),
('Aurora Capital',   'Brasília',        'DF');

-- Categorias
INSERT INTO categorias (nome, descricao) VALUES
('Alimentos',       'Produtos alimentícios em geral'),
('Bebidas',         'Bebidas alcoólicas e não alcoólicas'),
('Higiene',         'Produtos de higiene pessoal'),
('Limpeza',         'Produtos de limpeza doméstica'),
('Hortifruti',      'Frutas, verduras e legumes'),
('Padaria',         'Pães, bolos e confeitaria');

-- Produtos (18 produtos, 3 por categoria)
INSERT INTO produtos (nome, categoria_id, preco_unitario, custo_unitario) VALUES
-- Alimentos (cat 1)
('Arroz 5kg',           1, 25.90, 18.00),
('Feijão 1kg',          1, 9.50,   6.50),
('Macarrão 500g',       1, 5.90,   3.20),
-- Bebidas (cat 2)
('Refrigerante 2L',     2, 8.90,   4.50),
('Suco Natural 1L',     2, 12.50,  7.80),
('Água Mineral 500ml',  2, 2.50,   0.90),
-- Higiene (cat 3)
('Sabonete',            3, 3.90,   1.50),
('Shampoo 400ml',       3, 18.90, 10.00),
('Creme Dental',        3, 7.50,   3.80),
-- Limpeza (cat 4)
('Detergente 500ml',    4, 3.50,   1.80),
('Desinfetante 1L',     4, 8.90,   4.50),
('Esponja de Aço',      4, 4.20,   1.90),
-- Hortifruti (cat 5)
('Banana kg',           5, 6.90,   3.50),
('Tomate kg',           5, 8.50,   4.80),
('Alface unid.',        5, 3.20,   1.50),
-- Padaria (cat 6)
('Pão Francês kg',      6, 14.90,  8.00),
('Bolo de Chocolate',   6, 22.00, 12.00),
('Croissant',           6, 7.50,   3.50);

-- Vendas (30 vendas distribuídas entre filiais e meses)
INSERT INTO vendas (filial_id, data_venda, desconto) VALUES
-- Janeiro
(1, '2024-01-10', 5.00),
(2, '2024-01-10', 0.00),
(3, '2024-01-20', 10.00),
-- Fevereiro
(1, '2024-02-10', 3.00),
(4, '2024-02-10', 0.00),
(5, '2024-02-20', 8.00),
-- Março
(1, '2024-03-10', 0.00),
(2, '2024-03-20', 12.00),
(3, '2024-03-20', 5.00),
-- Abril
(4, '2024-04-10', 0.00),
(5, '2024-04-10', 7.00),
(1, '2024-04-20', 15.00),
-- Maio
(2, '2024-05-10', 0.00),
(3, '2024-05-20', 4.00),
(4, '2024-05-20', 0.00),
-- Junho
(5, '2024-06-10', 10.00),
(1, '2024-06-10', 0.00),
(2, '2024-06-20', 6.00),
-- Julho
(3, '2024-07-10', 0.00),
(4, '2024-07-20', 9.00),
(5, '2024-07-20', 0.00),
-- Agosto
(1, '2024-08-10', 20.00),
(2, '2024-08-20', 0.00),
-- Setembro
(3, '2024-09-10', 3.00),
(4, '2024-09-20', 0.00),
-- Outubro
(5, '2024-10-10', 11.00),
(1, '2024-10-20', 0.00),
-- Novembro
(2, '2024-11-10', 5.00),
(3, '2024-11-20', 0.00),
-- Dezembro
(4, '2024-12-10', 8.00),
(5, '2024-12-20', 0.00);

-- Itens de venda (~80 itens)
INSERT INTO itens_venda (venda_id, produto_id, quantidade, preco_unitario, desconto_item) VALUES
-- Venda 1 (Filial 1, Jan)
(1, 1,  3, 25.90, 2.00),
(1, 4,  5, 8.90,  0.00),
(1, 16, 2, 14.90, 1.00),
-- Venda 2 (Filial 2, Jan)
(2, 2,  4, 9.50,  0.00),
(2, 7,  6, 3.90,  0.50),
(2, 13, 3, 6.90,  0.00),
-- Venda 3 (Filial 3, Jan)
(3, 5,  2, 12.50, 1.00),
(3, 10, 8, 3.50,  0.00),
(3, 17, 1, 22.00, 3.00),
-- Venda 4 (Filial 1, Fev)
(4, 3,  10, 5.90, 0.00),
(4, 8,  2, 18.90, 2.00),
(4, 14, 5,  8.50, 0.00),
-- Venda 5 (Filial 4, Fev)
(5, 1,  4, 25.90, 0.00),
(5, 6, 12,  2.50, 0.00),
(5, 15, 6,  3.20, 0.00),
-- Venda 6 (Filial 5, Fev)
(6, 9,  3, 7.50, 0.50),
(6, 11, 4, 8.90, 0.00),
(6, 18, 5, 7.50, 1.00),
-- Venda 7 (Filial 1, Mar)
(7, 1,  2, 25.90, 0.00),
(7, 2,  3,  9.50, 0.00),
(7, 4,  6,  8.90, 1.00),
-- Venda 8 (Filial 2, Mar)
(8, 12, 10, 4.20, 0.00),
(8, 16,  3, 14.90, 0.00),
(8, 5,   4, 12.50, 2.00),
-- Venda 9 (Filial 3, Mar)
(9, 7,   8,  3.90, 0.00),
(9, 14,  3,  8.50, 0.00),
-- Venda 10 (Filial 4, Abr)
(10, 3,  5,  5.90, 0.00),
(10, 6, 10,  2.50, 0.00),
(10, 17, 2, 22.00, 0.00),
-- Venda 11 (Filial 5, Abr)
(11, 8,  1, 18.90, 0.00),
(11, 10, 6,  3.50, 0.50),
(11, 13, 4,  6.90, 0.00),
-- Venda 12 (Filial 1, Abr)
(12, 1,  5, 25.90, 3.00),
(12, 11, 3,  8.90, 0.00),
(12, 18, 4,  7.50, 0.00),
-- Venda 13 (Filial 2, Mai)
(13, 2,  6,  9.50, 0.00),
(13, 4,  8,  8.90, 0.00),
(13, 15, 5,  3.20, 0.00),
-- Venda 14 (Filial 3, Mai)
(14, 9,  3,  7.50, 0.00),
(14, 16, 2, 14.90, 1.00),
-- Venda 15 (Filial 4, Mai)
(15, 5,  3, 12.50, 0.00),
(15, 12, 7,  4.20, 0.00),
(15, 14, 4,  8.50, 1.00),
-- Venda 16 (Filial 5, Jun)
(16, 1,  3, 25.90, 0.00),
(16, 7,  5,  3.90, 0.00),
(16, 17, 2, 22.00, 2.00),
-- Venda 17 (Filial 1, Jun)
(17, 3,  8,  5.90, 0.00),
(17, 6, 15,  2.50, 0.00),
(17, 13, 4,  6.90, 0.00),
-- Venda 18 (Filial 2, Jun)
(18, 10, 5,  3.50, 0.00),
(18, 8,  2, 18.90, 0.00),
(18, 11, 3,  8.90, 1.00),
-- Venda 19 (Filial 3, Jul)
(19, 2,  4,  9.50, 0.00),
(19, 15, 8,  3.20, 0.00),
(19, 18, 3,  7.50, 0.00),
-- Venda 20 (Filial 4, Jul)
(20, 1,  2, 25.90, 0.00),
(20, 4,  6,  8.90, 0.00),
(20, 16, 3, 14.90, 2.00),
-- Venda 21 (Filial 5, Jul)
(21, 9,  5,  7.50, 1.00),
(21, 14, 3,  8.50, 0.00),
(21, 12, 4,  4.20, 0.00),
-- Venda 22 (Filial 1, Ago)
(22, 5,  3, 12.50, 0.00),
(22, 7, 10,  3.90, 0.00),
(22, 17, 1, 22.00, 0.00),
-- Venda 23 (Filial 2, Ago)
(23, 3,  7,  5.90, 0.00),
(23, 13, 5,  6.90, 0.00),
-- Venda 24 (Filial 3, Set)
(24, 6, 20,  2.50, 0.00),
(24, 11, 4,  8.90, 0.00),
(24, 16, 2, 14.90, 0.00),
-- Venda 25 (Filial 4, Set)
(25, 8,  2, 18.90, 0.00),
(25, 10, 5,  3.50, 0.00),
(25, 18, 6,  7.50, 0.00),
-- Venda 26 (Filial 5, Out)
(26, 1,  4, 25.90, 2.00),
(26, 2,  3,  9.50, 0.00),
(26, 14, 5,  8.50, 0.00),
-- Venda 27 (Filial 1, Out)
(27, 4, 10,  8.90, 0.00),
(27, 12, 6,  4.20, 0.00),
(27, 15, 3,  3.20, 0.00),
-- Venda 28 (Filial 2, Nov)
(28, 5,  2, 12.50, 0.00),
(28, 9,  4,  7.50, 0.00),
(28, 17, 3, 22.00, 3.00),
-- Venda 29 (Filial 3, Nov)
(29, 3,  6,  5.90, 0.00),
(29, 7,  4,  3.90, 0.00),
(29, 16, 2, 14.90, 0.00),
-- Venda 30 (Filial 4, Dez)
(30, 11, 5,  8.90, 0.00),
(30, 13, 8,  6.90, 0.00),
(30, 18, 4,  7.50, 0.00),
-- Venda 31 (Filial 5, Dez)
(31, 1,  6, 25.90, 0.00),
(31, 8,  2, 18.90, 0.00),
(31, 10, 7,  3.50, 0.00);


-- ============================================================
-- VIEWS — Indicadores e Perguntas de Negócio
-- ============================================================

-- View base: indicadores por venda (usada pelas demais views)
CREATE VIEW v_indicadores_venda AS
SELECT
    v.venda_id,
    v.filial_id,
    f.nome           AS filial,
    v.data_venda,
    c.mes,
    c.nome_mes,
    c.trimestre,
    c.ano,
    iv.produto_id,
    p.nome           AS produto,
    p.categoria_id,
    cat.nome         AS categoria,
    iv.quantidade,
    iv.preco_unitario,
    iv.desconto_item,
    p.custo_unitario,
    v.desconto       AS desconto_venda,
    -- Indicadores por item
    (iv.quantidade * iv.preco_unitario)                       AS faturamento_bruto_item,
    (iv.desconto_item * iv.quantidade)                        AS desconto_item_total,
    (iv.quantidade * iv.preco_unitario)
      - (iv.desconto_item * iv.quantidade)                    AS receita_liquida_item,
    (iv.quantidade * p.custo_unitario)                        AS custo_total_item
FROM itens_venda iv
JOIN vendas v       ON v.venda_id    = iv.venda_id
JOIN filiais f      ON f.filial_id   = v.filial_id
JOIN calendario c   ON c.data_id     = v.data_venda
JOIN produtos p     ON p.produto_id  = iv.produto_id
JOIN categorias cat ON cat.categoria_id = p.categoria_id;

-- ============================================================
-- Pergunta 1: Faturamento total por mês
-- ============================================================
CREATE VIEW v_faturamento_mensal AS
SELECT
    ano,
    mes,
    nome_mes,
    SUM(faturamento_bruto_item)                                AS faturamento_bruto,
    SUM(desconto_item_total)                                   AS desconto_itens,
    SUM(faturamento_bruto_item) - SUM(desconto_item_total)     AS receita_liquida
FROM v_indicadores_venda
GROUP BY ano, mes, nome_mes
ORDER BY ano, mes;

-- ============================================================
-- Pergunta 2: Filiais com maior receita líquida
-- ============================================================
CREATE VIEW v_receita_por_filial AS
SELECT
    filial,
    SUM(faturamento_bruto_item)                                AS faturamento_bruto,
    SUM(desconto_item_total) + SUM(desconto_venda)             AS desconto_total,
    SUM(receita_liquida_item) - SUM(desconto_venda)            AS receita_liquida
FROM v_indicadores_venda
GROUP BY filial
ORDER BY receita_liquida DESC;

-- ============================================================
-- Pergunta 3: Categorias com maior receita líquida
-- ============================================================
CREATE VIEW v_receita_por_categoria AS
SELECT
    categoria,
    SUM(faturamento_bruto_item)                                AS faturamento_bruto,
    SUM(desconto_item_total)                                   AS desconto_total,
    SUM(receita_liquida_item)                                  AS receita_liquida
FROM v_indicadores_venda
GROUP BY categoria
ORDER BY receita_liquida DESC;

-- ============================================================
-- Pergunta 4: Produtos com maior quantidade vendida
-- ============================================================
CREATE VIEW v_quantidade_por_produto AS
SELECT
    produto,
    categoria,
    SUM(quantidade)              AS total_vendido,
    SUM(receita_liquida_item)    AS receita_liquida
FROM v_indicadores_venda
GROUP BY produto, categoria
ORDER BY total_vendido DESC;

-- ============================================================
-- Pergunta 5: Margem bruta por mês, filial e categoria
-- ============================================================
CREATE VIEW v_margem_bruta AS
SELECT
    nome_mes,
    mes,
    filial,
    categoria,
    SUM(receita_liquida_item)                                  AS receita_liquida,
    SUM(custo_total_item)                                      AS custo_total,
    SUM(receita_liquida_item) - SUM(custo_total_item)          AS margem_bruta,
    CASE
        WHEN SUM(receita_liquida_item) = 0 THEN 0
        ELSE ROUND(
            (SUM(receita_liquida_item) - SUM(custo_total_item))
            / SUM(receita_liquida_item) * 100
        , 2)
    END                                                        AS margem_bruta_pct
FROM v_indicadores_venda
GROUP BY nome_mes, mes, filial, categoria
ORDER BY mes, filial, categoria;

-- ============================================================
-- Indicador: Ticket médio por filial
-- ============================================================
CREATE VIEW v_ticket_medio AS
SELECT
    filial,
    COUNT(DISTINCT venda_id)                                   AS total_vendas,
    SUM(receita_liquida_item)                                  AS receita_liquida,
    ROUND(
        SUM(receita_liquida_item) / COUNT(DISTINCT venda_id)
    , 2)                                                       AS ticket_medio
FROM v_indicadores_venda
GROUP BY filial
ORDER BY ticket_medio DESC;

-- ============================================================
-- Resumo geral de indicadores
-- ============================================================
CREATE VIEW v_resumo_indicadores AS
SELECT
    SUM(faturamento_bruto_item)                                AS faturamento_bruto,
    SUM(desconto_item_total)                                   AS desconto_total,
    SUM(receita_liquida_item)                                  AS receita_liquida,
    SUM(custo_total_item)                                      AS custo_total,
    SUM(receita_liquida_item) - SUM(custo_total_item)          AS margem_bruta,
    ROUND(
        (SUM(receita_liquida_item) - SUM(custo_total_item))
        / SUM(receita_liquida_item) * 100
    , 2)                                                       AS margem_bruta_pct,
    SUM(quantidade)                                            AS quantidade_vendida,
    ROUND(
        SUM(receita_liquida_item) / COUNT(DISTINCT venda_id)
    , 2)                                                       AS ticket_medio
FROM v_indicadores_venda;


-- ============================================================
-- CONSULTAS DE VALIDAÇÃO
-- ============================================================

-- Validação 1: Contagem de registros por tabela
SELECT 'calendario'  AS tabela, COUNT(*) AS registros FROM calendario
UNION ALL
SELECT 'filiais',     COUNT(*) FROM filiais
UNION ALL
SELECT 'categorias',  COUNT(*) FROM categorias
UNION ALL
SELECT 'produtos',    COUNT(*) FROM produtos
UNION ALL
SELECT 'vendas',      COUNT(*) FROM vendas
UNION ALL
SELECT 'itens_venda', COUNT(*) FROM itens_venda;

-- Validação 2: Faturamento bruto total
SELECT
    SUM(iv.quantidade * iv.preco_unitario) AS faturamento_bruto
FROM itens_venda iv;

-- Validação 3: Desconto total (desconto da venda + desconto dos itens)
SELECT
    SUM(v.desconto) + SUM(iv.desconto_item * iv.quantidade) AS desconto_total
FROM vendas v
JOIN itens_venda iv ON iv.venda_id = v.venda_id;

-- Validação 4: Faturamento total por mês (Pergunta 1)
SELECT
    c.nome_mes,
    c.mes,
    SUM(iv.quantidade * iv.preco_unitario) AS faturamento_bruto
FROM itens_venda iv
JOIN vendas v   ON v.venda_id = iv.venda_id
JOIN calendario c ON c.data_id = v.data_venda
GROUP BY c.nome_mes, c.mes
ORDER BY c.mes;

-- Validação 5: Receita líquida por filial (Pergunta 2)
SELECT
    f.nome AS filial,
    SUM(iv.quantidade * iv.preco_unitario)
      - SUM(iv.desconto_item * iv.quantidade)
      - SUM(v.desconto) AS receita_liquida
FROM itens_venda iv
JOIN vendas v   ON v.venda_id = iv.venda_id
JOIN filiais f  ON f.filial_id = v.filial_id
GROUP BY f.nome
ORDER BY receita_liquida DESC;

-- Validação 6: Receita líquida por categoria (Pergunta 3)
SELECT
    cat.nome AS categoria,
    SUM(iv.quantidade * iv.preco_unitario)
      - SUM(iv.desconto_item * iv.quantidade) AS receita_liquida_categoria
FROM itens_venda iv
JOIN produtos p    ON p.produto_id = iv.produto_id
JOIN categorias cat ON cat.categoria_id = p.categoria_id
GROUP BY cat.nome
ORDER BY receita_liquida_categoria DESC;

-- Validação 7: Produtos com maior quantidade vendida (Pergunta 4)
SELECT
    p.nome AS produto,
    SUM(iv.quantidade) AS total_vendido
FROM itens_venda iv
JOIN produtos p ON p.produto_id = iv.produto_id
GROUP BY p.nome
ORDER BY total_vendido DESC
LIMIT 10;

-- Validação 8: Margem bruta por mês, filial e categoria (Pergunta 5)
SELECT
    c.nome_mes,
    f.nome AS filial,
    cat.nome AS categoria,
    SUM(iv.quantidade * iv.preco_unitario)
      - SUM(iv.desconto_item * iv.quantidade) AS receita_liquida,
    SUM(iv.quantidade * p.custo_unitario) AS custo_total,
    SUM(iv.quantidade * iv.preco_unitario)
      - SUM(iv.desconto_item * iv.quantidade)
      - SUM(iv.quantidade * p.custo_unitario) AS margem_bruta,
    CASE
        WHEN SUM(iv.quantidade * iv.preco_unitario) - SUM(iv.desconto_item * iv.quantidade) = 0 THEN 0
        ELSE ROUND(
            (SUM(iv.quantidade * iv.preco_unitario)
              - SUM(iv.desconto_item * iv.quantidade)
              - SUM(iv.quantidade * p.custo_unitario))
            / (SUM(iv.quantidade * iv.preco_unitario)
              - SUM(iv.desconto_item * iv.quantidade)) * 100
        , 2)
    END AS margem_bruta_pct
FROM itens_venda iv
JOIN vendas v      ON v.venda_id = iv.venda_id
JOIN calendario c  ON c.data_id = v.data_venda
JOIN filiais f     ON f.filial_id = v.filial_id
JOIN produtos p    ON p.produto_id = iv.produto_id
JOIN categorias cat ON cat.categoria_id = p.categoria_id
GROUP BY c.nome_mes, c.mes, f.nome, cat.nome
ORDER BY c.mes, f.nome, cat.nome;

-- Validação 9: Ticket médio geral
SELECT
    ROUND(
        SUM(iv.quantidade * iv.preco_unitario - iv.desconto_item * iv.quantidade)::NUMERIC
        / COUNT(DISTINCT v.venda_id)
    , 2) AS ticket_medio
FROM itens_venda iv
JOIN vendas v ON v.venda_id = iv.venda_id;
