from flask import Flask, jsonify
from flask_cors import CORS

from config import Config
from routes import bp


def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)
    CORS(app)

    app.register_blueprint(bp)

    @app.get("/")
    def index():
        return jsonify({
            "nome": "Rede Comercial Aurora API",
            "endpoints": [
                "/api/faturamento-mensal",
                "/api/receita-filial",
                "/api/receita-categoria",
                "/api/produtos-mais-vendidos",
                "/api/margem-bruta",
            ],
        })

    return app


if __name__ == "__main__":
    create_app().run(host="0.0.0.0", port=5000)
