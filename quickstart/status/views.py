from django.http import HttpResponse
from .utils import db_can_connect


def health(request):

    db_connected = db_can_connect()

    if not db_connected:
        return HttpResponse('Service Unavailable', status=503)
    return HttpResponse('Ok', status=200)
