from decimal import Decimal
from threading import Lock

from psycopg2 import OperationalError
from psycopg2.pool import ThreadedConnectionPool
from psycopg2.extras import RealDictCursor

from config import Config


_connection_pool = None
_pool_lock = Lock()


class DatabaseUnavailableError(Exception):
    """Raised when the database cannot be reached."""
    pass


def _json_ready(value):
    if isinstance(value, Decimal):
        return float(value)
    return value


def _get_pool():
    global _connection_pool
    with _pool_lock:
        if _connection_pool is None:
            try:
                _connection_pool = ThreadedConnectionPool(
                    Config.DB_MIN_CONN,
                    Config.DB_MAX_CONN,
                    **Config.database_dsn(),
                )
            except OperationalError as exc:
                raise DatabaseUnavailableError(
                    f"Não foi possível conectar ao banco de dados: {exc}"
                ) from exc
    return _connection_pool


def execute_query(sql, params=None):
    try:
        connection_pool = _get_pool()
    except DatabaseUnavailableError:
        raise

    conn = None
    try:
        conn = connection_pool.getconn()
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute(sql, params or {})
            rows = cursor.fetchall()
            return [
                {key: _json_ready(value) for key, value in row.items()}
                for row in rows
            ]
    except OperationalError as exc:
        # Database went away after pool was created — reset pool for next attempt
        _reset_pool()
        raise DatabaseUnavailableError(
            f"Conexão com o banco de dados foi perdida: {exc}"
        ) from exc
    finally:
        if conn is not None:
            try:
                connection_pool.putconn(conn)
            except Exception:
                pass


def _reset_pool():
    """Reset the pool so the next request retries the connection."""
    global _connection_pool
    with _pool_lock:
        if _connection_pool is not None:
            try:
                _connection_pool.closeall()
            except Exception:
                pass
            _connection_pool = None


def close_pool():
    _reset_pool()
