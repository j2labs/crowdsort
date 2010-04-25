from django.template import Context, loader, RequestContext
from django.shortcuts import render_to_response
from django.http import HttpResponse, HttpResponseRedirect
from django.conf import settings
from django.db import connection, transaction
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login, logout

from models import Guest

#######################
# iWebKit based views #
#######################

def login_user(request, template_name="login.html"):

    message = None
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(username=username, password=password)
        if user is not None:
            if user.is_active:
                login(request, user)
                # TODO: Implement 'next' handling for nice link-through
                return HttpResponseRedirect('/')
            else:
                message = 'This account has been disabled.'
        else:
            message = 'Incorrect username or password.'
    
    return render_to_response(template_name, {
        'message':message
    }, context_instance=RequestContext(request))

@login_required
def logout_user(request):

    logout(request)
    return HttpResponseRedirect('/')

@login_required
def landing(request, template_name="homepage.html"):
    initials = [chr(x) for x in range(ord('A'), ord('Z')+1)]
    return render_to_response(template_name, {
        'initials': initials
    }, context_instance=RequestContext(request))

@login_required
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

@login_required
def query_names(request, template_name="guestlist/guestlist.txt"):
    # receives ?q=a&limit=150&timestamp=1265604168244
    names = []
    if 'q' in request.GET:
        q = request.GET['q']
        # disregard limit flag and limit to 25
        guests = Guest.objects.order_by('name').filter(name__startswith=q)[:25]
        names = [(g.name) for g in guests]
    return render_to_response(template_name, { 
        'names': names
    }, context_instance=RequestContext(request))

@login_required
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

@login_required
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
        

@login_required
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
                net = (guest.plus_counted + npc) - guest.plus_count
                if net < 1:
                    result = 'Success'
                elif net > 0:
                    result = 'Failure'
                    reason = 'Guest has exceeded maximum extra guests with another line handler'

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
