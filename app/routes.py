from flask import Blueprint, jsonify, request

from services import get_report


bp = Blueprint("api", __name__, url_prefix="/api")


def report_response(report_name):
    try:
        return jsonify(get_report(report_name, request.args))
    except ValueError as exc:
        return jsonify({"erro": str(exc)}), 400


@bp.get("/health")
def health():
    return jsonify({"status": "ok"})


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
