FILTER_COLUMNS = {
    "filial_id": "filial_id",
    "produto_id": "produto_id",
    "categoria_id": "categoria_id",
}


def build_filters(filters):
    clauses = []
    params = {}

    if filters.get("data_inicio"):
        clauses.append("data_venda >= %(data_inicio)s")
        params["data_inicio"] = filters["data_inicio"]

    if filters.get("data_fim"):
        clauses.append("data_venda <= %(data_fim)s")
        params["data_fim"] = filters["data_fim"]

    for key, column in FILTER_COLUMNS.items():
        if filters.get(key) is not None:
            clauses.append(f"{column} = %({key})s")
            params[key] = filters[key]

    where_sql = ""
    if clauses:
        where_sql = "WHERE " + " AND ".join(clauses)

    return where_sql, params


def faturamento_mensal(filters):
    where_sql, params = build_filters(filters)
    return f"""
        SELECT
            CONCAT(ano, '-', LPAD(mes::TEXT, 2, '0')) AS mes,
            SUM(faturamento_bruto_item)::NUMERIC(12,2) AS faturamento_bruto,
            SUM(desconto_total_item)::NUMERIC(12,2) AS desconto_total,
            SUM(receita_liquida_item)::NUMERIC(12,2) AS receita_liquida,
            SUM(quantidade)::INTEGER AS quantidade_vendida,
            COUNT(DISTINCT venda_id)::INTEGER AS quantidade_vendas
        FROM v_indicadores_venda
        {where_sql}
        GROUP BY ano, mes
        ORDER BY ano, mes
    """, params


def receita_filial(filters):
    where_sql, params = build_filters(filters)
    return f"""
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
        {where_sql}
        GROUP BY filial
        ORDER BY receita_liquida DESC
    """, params


def receita_categoria(filters):
    where_sql, params = build_filters(filters)
    return f"""
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
        {where_sql}
        GROUP BY categoria
        ORDER BY receita_liquida DESC
    """, params


def produtos_mais_vendidos(filters):
    where_sql, params = build_filters(filters)
    return f"""
        SELECT
            produto,
            categoria,
            SUM(quantidade)::INTEGER AS quantidade_vendida,
            SUM(faturamento_bruto_item)::NUMERIC(12,2) AS faturamento_bruto,
            SUM(receita_liquida_item)::NUMERIC(12,2) AS receita_liquida
        FROM v_indicadores_venda
        {where_sql}
        GROUP BY produto, categoria
        ORDER BY quantidade_vendida DESC, receita_liquida DESC
    """, params


def margem_bruta(filters):
    where_sql, params = build_filters(filters)
    return f"""
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
        {where_sql}
        GROUP BY ano, mes, filial, categoria
        ORDER BY ano, mes, filial, categoria
    """, params
