-- ============================================================
-- Rede Comercial Aurora - Script de criacao do banco de dados
-- Semana 2: dados ampliados, consultas-base e materialized views
-- ============================================================

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
    filial_id    SERIAL       PRIMARY KEY,
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
-- INSERCAO DE DADOS DE TESTE
-- ============================================================

-- Calendario: janeiro a dezembro de 2024, com 5 dias por mes.
WITH meses (mes, nome_mes) AS (
    VALUES
        (1, 'Janeiro'),
        (2, 'Fevereiro'),
        (3, 'Marco'),
        (4, 'Abril'),
        (5, 'Maio'),
        (6, 'Junho'),
        (7, 'Julho'),
        (8, 'Agosto'),
        (9, 'Setembro'),
        (10, 'Outubro'),
        (11, 'Novembro'),
        (12, 'Dezembro')
),
dias (dia) AS (
    VALUES (5), (10), (15), (20), (25)
)
INSERT INTO calendario (data_id, ano, mes, dia, trimestre, nome_mes, dia_semana)
SELECT
    make_date(2024, meses.mes, dias.dia) AS data_id,
    2024 AS ano,
    meses.mes,
    dias.dia,
    ((meses.mes - 1) / 3) + 1 AS trimestre,
    meses.nome_mes,
    CASE EXTRACT(DOW FROM make_date(2024, meses.mes, dias.dia))
        WHEN 0 THEN 'Domingo'
        WHEN 1 THEN 'Segunda'
        WHEN 2 THEN 'Terca'
        WHEN 3 THEN 'Quarta'
        WHEN 4 THEN 'Quinta'
        WHEN 5 THEN 'Sexta'
        ELSE 'Sabado'
    END AS dia_semana
FROM meses
CROSS JOIN dias
ORDER BY meses.mes, dias.dia;

INSERT INTO filiais (nome, cidade, estado) VALUES
('Aurora Centro',  'Sao Paulo',     'SP'),
('Aurora Sul',     'Curitiba',      'PR'),
('Aurora Norte',   'Manaus',        'AM'),
('Aurora Litoral', 'Florianopolis', 'SC'),
('Aurora Capital', 'Brasilia',      'DF');

INSERT INTO categorias (nome, descricao) VALUES
('Alimentos',  'Produtos alimenticios em geral'),
('Bebidas',    'Bebidas alcoolicas e nao alcoolicas'),
('Higiene',    'Produtos de higiene pessoal'),
('Limpeza',    'Produtos de limpeza domestica'),
('Hortifruti', 'Frutas, verduras e legumes'),
('Padaria',    'Paes, bolos e confeitaria');

INSERT INTO produtos (nome, categoria_id, preco_unitario, custo_unitario) VALUES
('Arroz 5kg',          1, 25.90, 18.00),
('Feijao 1kg',         1,  9.50,  6.50),
('Macarrao 500g',      1,  5.90,  3.20),
('Refrigerante 2L',    2,  8.90,  4.50),
('Suco Natural 1L',    2, 12.50,  7.80),
('Agua Mineral 500ml', 2,  2.50,  0.90),
('Sabonete',           3,  3.90,  1.50),
('Shampoo 400ml',      3, 18.90, 10.00),
('Creme Dental',       3,  7.50,  3.80),
('Detergente 500ml',   4,  3.50,  1.80),
('Desinfetante 1L',    4,  8.90,  4.50),
('Esponja de Aco',     4,  4.20,  1.90),
('Banana kg',          5,  6.90,  3.50),
('Tomate kg',          5,  8.50,  4.80),
('Alface unid.',       5,  3.20,  1.50),
('Pao Frances kg',     6, 14.90,  8.00),
('Bolo de Chocolate',  6, 22.00, 12.00),
('Croissant',          6,  7.50,  3.50),
('Amaciante 2L',       4, 12.90,  6.50),
('Melancia kg',        5,  4.50,  2.00);

-- 120 vendas distribuidas entre 5 filiais, 12 meses e datas diferentes.
INSERT INTO vendas (filial_id, data_venda, desconto)
SELECT
    ((venda_numero - 1) % 5) + 1 AS filial_id,
    make_date(
        2024,
        ((venda_numero - 1) % 12) + 1,
        CASE (((venda_numero - 1) / 12) % 5)
            WHEN 0 THEN 5
            WHEN 1 THEN 10
            WHEN 2 THEN 15
            WHEN 3 THEN 20
            ELSE 25
        END
    ) AS data_venda,
    CASE
        WHEN venda_numero % 11 = 0 THEN 12.00
        WHEN venda_numero % 7 = 0 THEN 8.50
        WHEN venda_numero % 4 = 0 THEN 5.00
        ELSE 0.00
    END AS desconto
FROM generate_series(1, 120) AS venda_numero;

-- 360 itens vinculados as vendas, com produtos, quantidades e descontos variados.
INSERT INTO itens_venda (venda_id, produto_id, quantidade, preco_unitario, desconto_item)
SELECT
    v.venda_id,
    produto_calc.produto_id,
    ((v.venda_id + item.ordem * 2) % 8) + 1 AS quantidade,
    p.preco_unitario,
    CASE
        WHEN (v.venda_id + item.ordem) % 13 = 0 THEN 1.50
        WHEN (v.venda_id + item.ordem) % 9 = 0 THEN 0.75
        ELSE 0.00
    END AS desconto_item
FROM vendas v
CROSS JOIN (VALUES (1, 0), (2, 5), (3, 11)) AS item(ordem, produto_shift)
CROSS JOIN LATERAL (
    SELECT (((v.venda_id * item.ordem + item.produto_shift - 1) % 20) + 1) AS produto_id
) AS produto_calc
JOIN produtos p ON p.produto_id = produto_calc.produto_id
ORDER BY v.venda_id, item.ordem;

-- ============================================================
-- MATERIALIZED VIEWS - Indicadores e perguntas de negocio
-- ============================================================

-- Base materializada: indicadores por item de venda.
-- O desconto da venda e rateado proporcionalmente pelo faturamento bruto do item.
CREATE MATERIALIZED VIEW v_indicadores_venda AS
WITH itens_calculados AS (
    SELECT
        v.venda_id,
        v.filial_id,
        f.nome AS filial,
        v.data_venda,
        c.mes,
        c.nome_mes,
        c.trimestre,
        c.ano,
        iv.produto_id,
        p.nome AS produto,
        p.categoria_id,
        cat.nome AS categoria,
        iv.quantidade,
        iv.preco_unitario,
        iv.desconto_item,
        p.custo_unitario,
        v.desconto AS desconto_venda,
        (iv.quantidade * iv.preco_unitario)::NUMERIC(12,2) AS faturamento_bruto_item,
        (iv.desconto_item * iv.quantidade)::NUMERIC(12,2) AS desconto_item_total,
        (iv.quantidade * p.custo_unitario)::NUMERIC(12,2) AS custo_total_item,
        (SUM(iv.quantidade * iv.preco_unitario) OVER (PARTITION BY v.venda_id))::NUMERIC(12,2) AS faturamento_bruto_venda
    FROM itens_venda iv
    JOIN vendas v          ON v.venda_id = iv.venda_id
    JOIN filiais f         ON f.filial_id = v.filial_id
    JOIN calendario c      ON c.data_id = v.data_venda
    JOIN produtos p        ON p.produto_id = iv.produto_id
    JOIN categorias cat    ON cat.categoria_id = p.categoria_id
),
itens_rateados AS (
    SELECT
        *,
        ROUND(
            CASE
                WHEN faturamento_bruto_venda = 0 THEN 0
                ELSE desconto_venda * faturamento_bruto_item / faturamento_bruto_venda
            END,
            2
        ) AS desconto_venda_rateado
    FROM itens_calculados
)
SELECT
    venda_id,
    filial_id,
    filial,
    data_venda,
    ano,
    mes,
    nome_mes,
    trimestre,
    produto_id,
    produto,
    categoria_id,
    categoria,
    quantidade,
    preco_unitario,
    custo_unitario,
    desconto_item,
    desconto_venda,
    faturamento_bruto_item,
    desconto_item_total,
    desconto_venda_rateado,
    (desconto_item_total + desconto_venda_rateado)::NUMERIC(12,2) AS desconto_total_item,
    (faturamento_bruto_item - desconto_item_total - desconto_venda_rateado)::NUMERIC(12,2) AS receita_liquida_item,
    custo_total_item
FROM itens_rateados;

CREATE INDEX idx_v_indicadores_data ON v_indicadores_venda (data_venda);
CREATE INDEX idx_v_indicadores_filial ON v_indicadores_venda (filial_id);
CREATE INDEX idx_v_indicadores_produto ON v_indicadores_venda (produto_id);
CREATE INDEX idx_v_indicadores_categoria ON v_indicadores_venda (categoria_id);

-- Pergunta 1: Faturamento total por mes.
CREATE MATERIALIZED VIEW v_faturamento_mensal AS
SELECT
    ano,
    mes,
    nome_mes,
    CONCAT(ano, '-', LPAD(mes::TEXT, 2, '0')) AS mes_referencia,
    SUM(faturamento_bruto_item)::NUMERIC(12,2) AS faturamento_bruto,
    SUM(desconto_total_item)::NUMERIC(12,2) AS desconto_total,
    SUM(receita_liquida_item)::NUMERIC(12,2) AS receita_liquida,
    SUM(quantidade)::INTEGER AS quantidade_vendida,
    COUNT(DISTINCT venda_id)::INTEGER AS quantidade_vendas
FROM v_indicadores_venda
GROUP BY ano, mes, nome_mes
ORDER BY ano, mes;

-- Pergunta 2: Receita liquida por filial.
CREATE MATERIALIZED VIEW v_receita_por_filial AS
SELECT
    filial_id,
    filial,
    SUM(faturamento_bruto_item)::NUMERIC(12,2) AS faturamento_bruto,
    SUM(desconto_total_item)::NUMERIC(12,2) AS desconto_total,
    SUM(receita_liquida_item)::NUMERIC(12,2) AS receita_liquida,
    SUM(custo_total_item)::NUMERIC(12,2) AS custo_total,
    (SUM(receita_liquida_item) - SUM(custo_total_item))::NUMERIC(12,2) AS margem_bruta,
    CASE
        WHEN SUM(receita_liquida_item) = 0 THEN 0
        ELSE ROUND((SUM(receita_liquida_item) - SUM(custo_total_item)) / SUM(receita_liquida_item) * 100, 2)
    END AS margem_bruta_pct
FROM v_indicadores_venda
GROUP BY filial_id, filial
ORDER BY receita_liquida DESC;

-- Pergunta 3: Receita liquida por categoria.
CREATE MATERIALIZED VIEW v_receita_por_categoria AS
SELECT
    categoria_id,
    categoria,
    SUM(quantidade)::INTEGER AS quantidade_vendida,
    SUM(faturamento_bruto_item)::NUMERIC(12,2) AS faturamento_bruto,
    SUM(receita_liquida_item)::NUMERIC(12,2) AS receita_liquida,
    (SUM(receita_liquida_item) - SUM(custo_total_item))::NUMERIC(12,2) AS margem_bruta,
    CASE
        WHEN SUM(receita_liquida_item) = 0 THEN 0
        ELSE ROUND((SUM(receita_liquida_item) - SUM(custo_total_item)) / SUM(receita_liquida_item) * 100, 2)
    END AS margem_bruta_pct
FROM v_indicadores_venda
GROUP BY categoria_id, categoria
ORDER BY receita_liquida DESC;

-- Pergunta 4: Produtos mais vendidos.
CREATE MATERIALIZED VIEW v_quantidade_por_produto AS
SELECT
    produto_id,
    produto,
    categoria_id,
    categoria,
    SUM(quantidade)::INTEGER AS quantidade_vendida,
    SUM(faturamento_bruto_item)::NUMERIC(12,2) AS faturamento_bruto,
    SUM(receita_liquida_item)::NUMERIC(12,2) AS receita_liquida
FROM v_indicadores_venda
GROUP BY produto_id, produto, categoria_id, categoria
ORDER BY quantidade_vendida DESC, receita_liquida DESC;

-- Pergunta 5: Margem bruta por mes, filial e categoria.
CREATE MATERIALIZED VIEW v_margem_bruta AS
SELECT
    ano,
    mes,
    nome_mes,
    CONCAT(ano, '-', LPAD(mes::TEXT, 2, '0')) AS mes_referencia,
    filial_id,
    filial,
    categoria_id,
    categoria,
    SUM(receita_liquida_item)::NUMERIC(12,2) AS receita_liquida,
    SUM(custo_total_item)::NUMERIC(12,2) AS custo_total,
    (SUM(receita_liquida_item) - SUM(custo_total_item))::NUMERIC(12,2) AS margem_bruta,
    CASE
        WHEN SUM(receita_liquida_item) = 0 THEN 0
        ELSE ROUND((SUM(receita_liquida_item) - SUM(custo_total_item)) / SUM(receita_liquida_item) * 100, 2)
    END AS margem_bruta_pct
FROM v_indicadores_venda
GROUP BY ano, mes, nome_mes, filial_id, filial, categoria_id, categoria
ORDER BY ano, mes, filial, categoria;

-- Indicador adicional: ticket medio por filial.
CREATE MATERIALIZED VIEW v_ticket_medio AS
SELECT
    filial_id,
    filial,
    COUNT(DISTINCT venda_id)::INTEGER AS total_vendas,
    SUM(receita_liquida_item)::NUMERIC(12,2) AS receita_liquida,
    ROUND(SUM(receita_liquida_item) / COUNT(DISTINCT venda_id), 2) AS ticket_medio
FROM v_indicadores_venda
GROUP BY filial_id, filial
ORDER BY ticket_medio DESC;

-- Resumo geral dos principais indicadores.
CREATE MATERIALIZED VIEW v_resumo_indicadores AS
SELECT
    SUM(faturamento_bruto_item)::NUMERIC(12,2) AS faturamento_bruto,
    SUM(desconto_total_item)::NUMERIC(12,2) AS desconto_total,
    SUM(receita_liquida_item)::NUMERIC(12,2) AS receita_liquida,
    SUM(custo_total_item)::NUMERIC(12,2) AS custo_total,
    (SUM(receita_liquida_item) - SUM(custo_total_item))::NUMERIC(12,2) AS margem_bruta,
    ROUND((SUM(receita_liquida_item) - SUM(custo_total_item)) / SUM(receita_liquida_item) * 100, 2) AS margem_bruta_pct,
    SUM(quantidade)::INTEGER AS quantidade_vendida,
    COUNT(DISTINCT venda_id)::INTEGER AS quantidade_vendas,
    ROUND(SUM(receita_liquida_item) / COUNT(DISTINCT venda_id), 2) AS ticket_medio
FROM v_indicadores_venda;
