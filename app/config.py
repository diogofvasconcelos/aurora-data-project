import os


class Config:
    DB_HOST = os.getenv("DB_HOST", "localhost")
    DB_PORT = int(os.getenv("DB_PORT", "5434"))
    DB_NAME = os.getenv("DB_NAME", "aurora_db")
    DB_USER = os.getenv("DB_USER", "aurora_user")
    DB_PASSWORD = os.getenv("DB_PASSWORD", "aurora_pass")
    DB_MIN_CONN = int(os.getenv("DB_MIN_CONN", "1"))
    DB_MAX_CONN = int(os.getenv("DB_MAX_CONN", "5"))
    JSON_SORT_KEYS = False

    @classmethod
    def database_dsn(cls):
        return {
            "host": cls.DB_HOST,
            "port": cls.DB_PORT,
            "dbname": cls.DB_NAME,
            "user": cls.DB_USER,
            "password": cls.DB_PASSWORD,
        }
