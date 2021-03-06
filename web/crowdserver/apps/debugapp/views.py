
import random
import datetime

from django.template import Context, loader
from django.shortcuts import render_to_response
from django.http import HttpResponse
from django.conf import settings

from guestlist.models import Guest

# TODO: unicode
alphabet = u"abcdefghijklmnopqrstuvwxyz" # "\xc4\x87"
min = 5
max = 26

# Creates a bunch of guests
def makedata(request, how_many):
    
    print "Creating %s guests with random names..." % (how_many,)
    
    for count in xrange(1,int(how_many)):
        name = ""
        for x in random.sample(alphabet,random.randint(min,max)):
            name+=x

        print "Creating guest with name %s" % (name,)
        guest = Guest()
        guest.name = name
        guest.table_name = "Table"
        email = "ih@ve.one"
        guest.save()
    
    print "Guest created."
