from decimal import Decimal
from threading import Lock

from psycopg2.pool import ThreadedConnectionPool
from psycopg2.extras import RealDictCursor

from config import Config


_connection_pool = None
_pool_lock = Lock()


def _json_ready(value):
    if isinstance(value, Decimal):
        return float(value)
    return value


def _get_pool():
    global _connection_pool
    with _pool_lock:
        if _connection_pool is None:
            _connection_pool = ThreadedConnectionPool(
                Config.DB_MIN_CONN,
                Config.DB_MAX_CONN,
                **Config.database_dsn(),
            )
    return _connection_pool


def execute_query(sql, params=None):
    connection_pool = _get_pool()
    conn = connection_pool.getconn()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute(sql, params or {})
            rows = cursor.fetchall()
            return [
                {key: _json_ready(value) for key, value in row.items()}
                for row in rows
            ]
    finally:
        connection_pool.putconn(conn)


def close_pool():
    global _connection_pool
    if _connection_pool is not None:
        _connection_pool.closeall()
        _connection_pool = None
