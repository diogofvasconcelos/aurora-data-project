-- ============================================================
-- Rede Comercial Aurora - Consultas obrigatorias da Semana 2
-- ============================================================
-- Parametros padrao usados nas 5 consultas:
-- $1 = data_inicio (DATE, opcional)
-- $2 = data_fim (DATE, opcional)
-- $3 = filial_id (INTEGER, opcional)
-- $4 = produto_id (INTEGER, opcional)
-- $5 = categoria_id (INTEGER, opcional)

-- Consulta 1: Faturamento total por mes
SELECT
    CONCAT(ano, '-', LPAD(mes::TEXT, 2, '0')) AS mes,
    SUM(faturamento_bruto_item)::NUMERIC(12,2) AS faturamento_bruto,
    SUM(desconto_total_item)::NUMERIC(12,2) AS desconto_total,
    SUM(receita_liquida_item)::NUMERIC(12,2) AS receita_liquida,
    SUM(quantidade)::INTEGER AS quantidade_vendida,
    COUNT(DISTINCT venda_id)::INTEGER AS quantidade_vendas
FROM v_indicadores_venda
WHERE ($1::DATE IS NULL OR data_venda >= $1::DATE)
  AND ($2::DATE IS NULL OR data_venda <= $2::DATE)
  AND ($3::INTEGER IS NULL OR filial_id = $3::INTEGER)
  AND ($4::INTEGER IS NULL OR produto_id = $4::INTEGER)
  AND ($5::INTEGER IS NULL OR categoria_id = $5::INTEGER)
GROUP BY ano, mes
ORDER BY ano, mes;

-- Consulta 2: Receita liquida por filial
SELECT
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
WHERE ($1::DATE IS NULL OR data_venda >= $1::DATE)
  AND ($2::DATE IS NULL OR data_venda <= $2::DATE)
  AND ($3::INTEGER IS NULL OR filial_id = $3::INTEGER)
  AND ($4::INTEGER IS NULL OR produto_id = $4::INTEGER)
  AND ($5::INTEGER IS NULL OR categoria_id = $5::INTEGER)
GROUP BY filial
ORDER BY receita_liquida DESC;

-- Consulta 3: Receita liquida por categoria
SELECT
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
WHERE ($1::DATE IS NULL OR data_venda >= $1::DATE)
  AND ($2::DATE IS NULL OR data_venda <= $2::DATE)
  AND ($3::INTEGER IS NULL OR filial_id = $3::INTEGER)
  AND ($4::INTEGER IS NULL OR produto_id = $4::INTEGER)
  AND ($5::INTEGER IS NULL OR categoria_id = $5::INTEGER)
GROUP BY categoria
ORDER BY receita_liquida DESC;

-- Consulta 4: Produtos mais vendidos
SELECT
    produto,
    categoria,
    SUM(quantidade)::INTEGER AS quantidade_vendida,
    SUM(faturamento_bruto_item)::NUMERIC(12,2) AS faturamento_bruto,
    SUM(receita_liquida_item)::NUMERIC(12,2) AS receita_liquida
FROM v_indicadores_venda
WHERE ($1::DATE IS NULL OR data_venda >= $1::DATE)
  AND ($2::DATE IS NULL OR data_venda <= $2::DATE)
  AND ($3::INTEGER IS NULL OR filial_id = $3::INTEGER)
  AND ($4::INTEGER IS NULL OR produto_id = $4::INTEGER)
  AND ($5::INTEGER IS NULL OR categoria_id = $5::INTEGER)
GROUP BY produto, categoria
ORDER BY quantidade_vendida DESC, receita_liquida DESC;

-- Consulta 5: Margem bruta por mes, filial e categoria
SELECT
    CONCAT(ano, '-', LPAD(mes::TEXT, 2, '0')) AS mes,
    filial,
    categoria,
    SUM(receita_liquida_item)::NUMERIC(12,2) AS receita_liquida,
    SUM(custo_total_item)::NUMERIC(12,2) AS custo_total,
    (SUM(receita_liquida_item) - SUM(custo_total_item))::NUMERIC(12,2) AS margem_bruta,
    CASE
        WHEN SUM(receita_liquida_item) = 0 THEN 0
        ELSE ROUND((SUM(receita_liquida_item) - SUM(custo_total_item)) / SUM(receita_liquida_item) * 100, 2)
    END AS margem_bruta_pct
FROM v_indicadores_venda
WHERE ($1::DATE IS NULL OR data_venda >= $1::DATE)
  AND ($2::DATE IS NULL OR data_venda <= $2::DATE)
  AND ($3::INTEGER IS NULL OR filial_id = $3::INTEGER)
  AND ($4::INTEGER IS NULL OR produto_id = $4::INTEGER)
  AND ($5::INTEGER IS NULL OR categoria_id = $5::INTEGER)
GROUP BY ano, mes, filial, categoria
ORDER BY ano, mes, filial, categoria;
