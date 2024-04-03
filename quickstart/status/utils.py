from django.db import connections
from django.db.utils import OperationalError


def db_can_connect(db_alias: str = 'default') -> bool:

    db_connection = connections[db_alias]
    try:
        with db_connection.cursor() as cursor:
            cursor.execute('select 1')
            one = cursor.fetchone()[0]
            if one != 1:
                return False
    except OperationalError:
        return False

    return True
