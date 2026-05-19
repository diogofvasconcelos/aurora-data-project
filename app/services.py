from datetime import date

from database import execute_query
import queries


QUERY_BUILDERS = {
    "faturamento_mensal": queries.faturamento_mensal,
    "receita_filial": queries.receita_filial,
    "receita_categoria": queries.receita_categoria,
    "produtos_mais_vendidos": queries.produtos_mais_vendidos,
    "margem_bruta": queries.margem_bruta,
}


def _parse_date(value, field_name):
    if not value:
        return None
    try:
        return date.fromisoformat(value).isoformat()
    except ValueError as exc:
        raise ValueError(f"{field_name} deve usar o formato YYYY-MM-DD") from exc


def _parse_int(value, field_name):
    if value in (None, ""):
        return None
    try:
        return int(value)
    except ValueError as exc:
        raise ValueError(f"{field_name} deve ser um numero inteiro") from exc


def parse_filters(args):
    data_inicio = _parse_date(args.get("data_inicio"), "data_inicio")
    data_fim = _parse_date(args.get("data_fim"), "data_fim")

    if data_inicio and data_fim and data_inicio > data_fim:
        raise ValueError("data_inicio nao pode ser maior que data_fim")

    return {
        "data_inicio": data_inicio,
        "data_fim": data_fim,
        "filial_id": _parse_int(args.get("filial_id"), "filial_id"),
        "produto_id": _parse_int(args.get("produto_id"), "produto_id"),
        "categoria_id": _parse_int(args.get("categoria_id"), "categoria_id"),
    }


def get_report(report_name, args):
    filters = parse_filters(args)
    sql, params = QUERY_BUILDERS[report_name](filters)
    dados = execute_query(sql, params)
    return {
        "filtros": filters,
        "total_registros": len(dados),
        "dados": dados,
    }
