from django.template import Context, loader
from django.shortcuts import render_to_response
from django.http import HttpResponse
from django.conf import settings
from django.db import connection, transaction

from models import Guest

def search(request):
    return render_to_response('guests/find_guest.html', {'MEDIA_URL': settings.MEDIA_URL, 'event': "Robin Hood 2010"})
    
def detail(request, guest_id):
    return HttpResponse("Guest detail for id - %s" % (guest_id,))
    
def find_names(request):
    if 'q' in request.GET:
        name = request.GET['q']
        cursor = connection.cursor()
        cursor.execute("""SELECT name from guestlist_guest where name like '%s%%%%' limit 150""" % (name,))
        resultlist = slist = [r[0] for r in cursor.fetchall()]
        result = "\n".join(slist)
        
        return HttpResponse(result);
        
# 
# Returns a range of guest-names and their ids. The format of range should
# be two strings separated by a space (ie: 'A-C')
# 
def fetch_range(request):
    print "got here"
    
    result = []
    name_range = request.GET['r']
    r = name_range.split('-')
    # Does the Django ORM have a range? Does MySQL?
    # .. MySQL has > 'a%'
    guests = Guest.objects.filter(name__gte = r[0])
    for guest in guests:
        result.append((guest.id, guest.name))

    return HttpResponse(result)