from django.template import Context, loader, RequestContext
from django.shortcuts import render_to_response
from django.http import HttpResponse
from django.conf import settings
from django.db import connection, transaction

from models import Guest

################
# Phill's code #
################

def search(request):
    return render_to_response('guests/find_guest.html', {'MEDIA_URL': settings.MEDIA_URL, 'event': "Robin Hood 2010"})
    
def detail(request, guest_id):
    return HttpResponse("Guest detail for id - %s" % (guest_id,))
    
def find_names(request):
    if 'q' in request.GET:
        name = request.GET['q']
        cursor = connection.cursor()
        # Is this faster than what django's orm offers?
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


#######################
# iWebKit based views #
#######################

#@login_required
def landing(request, template_name="homepage.html"):
    initials = [chr(x) for x in range(ord('A'), ord('Z')+1)]
    return render_to_response(template_name, 
                              {'initials': initials},
                              context_instance=RequestContext(request))

#@login_required
def match_first_initial(request, template_name="guestlist/guestlist.html"):
    id_names = []
    initial = None
    if 'initial' in request.POST:
        initial = request.POST['initial']
        guests = Guest.objects.order_by('name').filter(name__startswith=initial)
        id_names = [(g.id, g.name) for g in guests]
    return render_to_response(template_name, {
        'id_names': id_names,
        'initial': initial
    }, context_instance=RequestContext(request))

#@login_required
def query_names(request, template_name="guestlist/guestlist.txt"):
    # receives ?q=a&limit=150&timestamp=1265604168244
    names = []
    if 'q' in request.GET:
        q = request.GET['q']
        guests = Guest.objects.order_by('name').filter(name__startswith=q)[:10]
        names = [(g.name) for g in guests]
    return render_to_response(template_name, 
                              {'names': names},
                              context_instance=RequestContext(request))

#@login_required
def show_by_id(request, gid, template_name="guestlist/show_guest_info.html"):
    guest_set = Guest.objects.filter(id=gid)
    if len(guest_set) > 0:
        guest = guest_set[0]
        allowed_guests = guest.plus_count - guest.plus_counted
        allowed_guest_list = range(1, allowed_guests+1)
    return render_to_response(template_name, {
        'guest': guest,
        'allowed_guest_list': allowed_guest_list,
        'all_guests_of_guest_here': (allowed_guests == 0),
    }, context_instance=RequestContext(request))

#@login_required
def show_by_name(request, template_name="guestlist/show_guest_info.html"):
    guest = None
    allowed_guest_list = None
    allowed_guests = -1
    if 'LName' in request.POST:
        name = request.POST['LName']
        guest_set = Guest.objects.filter(name__exact=name)
        if len(guest_set) > 0:
            guest = guest_set[0]
            allowed_guests = guest.plus_count - guest.plus_counted
            allowed_guest_list = range(0, allowed_guests+1)
    return render_to_response(template_name, {
        'guest': guest,
        'allowed_guest_list': allowed_guest_list,
        'all_guests_of_guest_here': (allowed_guests == 0),
    }, context_instance=RequestContext(request))
        

#@login_required
def alter_guest_status(request, gid=None, template_name="guestlist/alter_guest_status.html"):
    context_vars = {}
    result = None
    reason = None
    
    if gid != None:
        guest_set = Guest.objects.filter(id=gid)
        if len(guest_set) > 0:

            guest = guest_set[0]
            found_arrived = 'arrived' in request.POST
            found_new_plus_count = 'new_plus_count' in request.POST
            found_with_guest = 'with_guest' in request.POST

            if guest.arrived and not found_arrived:
                result = 'Failure'
                reason = 'Guest can not be <b>un</b>checked it. Find James if you have an emergency.'

            elif found_arrived and not found_with_guest and not found_new_plus_count:
                guest.arrived = True
                guest.save()

            elif found_with_guest:
                guest.plus_counted = 1
                guest.arrived = found_arrived
                result = 'Success'
                guest.save()

            elif found_new_plus_count:
                npc = int(request.POST['new_plus_count'])
                #npc = request.POST['new_plus_count']
                net = (guest.plus_counted + npc) - guest.plus_count
                if net < 1:
                    result = 'Success'
                elif net > 0:
                    result = 'Failure'
                    reason = 'Guest has exceeded maximum extra guests with another line handler'
#                else:
#                    result = 'Failure'
#                    reason = 'Guest was just checked in by another line handler'

                if result == 'Success':
                    guest.plus_counted = guest.plus_counted + npc
                    guest.arrived = 'arrived' in request.POST
                    guest.save()

            elif guest.arrived == True:
                result = 'Success'

            context_vars['guest'] = guest
                
    context_vars['result'] = result
    context_vars['reason'] = reason

    return render_to_response(template_name,
                              context_vars,
                              context_instance=RequestContext(request))
