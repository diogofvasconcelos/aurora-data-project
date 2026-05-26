from flask import Blueprint, jsonify, request

from database import DatabaseUnavailableError
from services import get_report


bp = Blueprint("api", __name__, url_prefix="/api")


def report_response(report_name):
    try:
        return jsonify(get_report(report_name, request.args))
    except ValueError as exc:
        return jsonify({"erro": str(exc)}), 400
    except DatabaseUnavailableError as exc:
        return jsonify({"erro": str(exc)}), 503
    except Exception as exc:
        return jsonify({"erro": f"Erro interno do servidor: {exc}"}), 500


@bp.get("/health")
def health():
    try:
        from database import execute_query
        execute_query("SELECT 1")
        return jsonify({"status": "ok"})
    except Exception as exc:
        return jsonify({"status": "error", "erro": str(exc)}), 503


@bp.get("/faturamento-mensal")
def faturamento_mensal():
    return report_response("faturamento_mensal")


@bp.get("/receita-filial")
def receita_filial():
    return report_response("receita_filial")


@bp.get("/receita-categoria")
def receita_categoria():
    return report_response("receita_categoria")


@bp.get("/produtos-mais-vendidos")
def produtos_mais_vendidos():
    return report_response("produtos_mais_vendidos")


@bp.get("/margem-bruta")
def margem_bruta():
    return report_response("margem_bruta")


@bp.get("/filiais")
def filiais():
    return report_response("filiais")


@bp.get("/categorias")
def categorias():
    return report_response("categorias")


@bp.get("/produtos")
def produtos():
    return report_response("produtos")


@bp.get("/indicadores-gerais")
def indicadores_gerais():
    return report_response("indicadores_gerais")
