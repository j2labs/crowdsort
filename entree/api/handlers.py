from piston.handler import BaseHandler
from piston.utils import rc

from guestlist.models import Guest

#
# Allows read or update right now. Doesn't allow create or delete. That's currently left to the
# admin interface.
#
class GuestHandler(BaseHandler):
    allowed_methods = ('GET', 'PUT')
    model = Guest
    
    def read(self, request, id):
        return Guest.objects.get(id = id)
    
    def update(self, request, id):
        print "got here"
        guestData = request.data
        guest = Guest.objects.get(id = guestData['id'])
        guest.plus_counted = guestData['plus_counted']
        guest.save()
        
        return rc.ALL_OK
    

# The limit right now is 150 names. Things run a tiny bit faster with less. Might make sense to 
# drop it to 50 to go easy on the phone.
class NameSearcher(BaseHandler):
    allowed_methods = ('GET',)
    model = Guest

    # 
    # Name search for auto-complete. Follows the jQuery autocomplete paradigm,
    # will use the request param 'q' for the starts-with, and 'limit' for the
    # maximum number of returned entries. Searches are case-insensitive.
    # 
    def read(self, request):
        result = ""
        if 'q' in request.GET:
            name = request.GET['q']
            guests = Guest.objects.filter(name__istartswith=name)
        else:
            guests = Guest.objects.all()
        
        if 'limit' in request.GET:
            guests = guests[:int(request.GET['limit'])]
        
        for guest in guests:
            result += guest.name + "\n"
        
        return result

class RangeSearcher(BaseHandler):
    allowed_methods = ('GET',)
    model = Guest
    
    # 
    # Returns a range of guest-names and their ids. The format of range should
    # be two strings separated by a space (ie: 'A-C')
    # 
    def r(self, request, r):
        print "got here"
        result = []
        
        r = r.split('-')
        # Does the Django ORM have a range? Does MySQL?
        # .. MySQL has > 'a%'
        guests = Guest.objects.filter(name__gte=r[0])
        for guest in guests:
            result.append(guest.id, guest.name)

        return result