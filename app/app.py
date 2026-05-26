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
        return app.send_static_file("index.html")

    # Global error handler — ensures Flask NEVER returns a blank page
    @app.errorhandler(500)
    def handle_500(error):
        return jsonify({"erro": "Erro interno do servidor"}), 500

    @app.errorhandler(503)
    def handle_503(error):
        return jsonify({"erro": "Banco de dados indisponível"}), 503

    @app.errorhandler(Exception)
    def handle_exception(error):
        return jsonify({"erro": f"Erro inesperado: {error}"}), 500

    return app


if __name__ == "__main__":
    create_app().run(host="0.0.0.0", port=5000)
