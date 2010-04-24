import json

from django.http import HttpResponse
from django.core import serializers

from guestlist.models import Guest
from basicauth import logged_in_or_basicauth

@logged_in_or_basicauth()
def login(request):
    """
    Logs in the user via HTTP Basic Auth if there isn't already a web-session, and returns
    the user record in json format. If login fails, a 
    """
    
    json_serializer = serializers.get_serializer("json")()
    return HttpResponse(json_serializer.serialize((request.user,), ensure_ascii=False))

@logged_in_or_basicauth()
def detail(request, guest_id):
    """
    Returns the Guest record specified by guest_id in json.
    """
    
    guest = Guest.objects.get(id=guest_id)
    json_serializer = serializers.get_serializer("json")()
    return HttpResponse(json_serializer.serialize((guest,), ensure_ascii=False))


@logged_in_or_basicauth()
def names(request):
    """
    Finds a list of names. Request parameter 'q' can be sent as the starts-with query.
    Request parameter 'l' can be sent as the limit of the number of items returned. The
    search is case-insensitive, and the result is a json list of lists, where each element
    is [id, name]
    """
    
    result = []
    if 'q' in request.GET:
        name = request.GET['q']
        guests = Guest.objects.filter(name__istartswith=name).order_by('name')
    else:
        guests = Guest.objects.all().order_by('name')
    
    if 'limit' in request.GET:
        guests = guests[:int(request.GET['limit'])]
    
    for guest in guests:
        result.append((guest.id, guest.name))
    
    return HttpResponse(json.dumps(result))
