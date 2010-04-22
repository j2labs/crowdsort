from django.conf.urls.defaults import *
from piston.resource import Resource
from handlers import GuestHandler, NameSearcher, RangeSearcher

guest_handler = Resource(GuestHandler)
name_searcher = Resource(NameSearcher)
range_searcher = Resource(RangeSearcher)

urlpatterns = patterns('',
    url(r'^names/.*?', name_searcher),
    url(r'^range/(?P<name>[^/]+)/', range_searcher),
    url(r'^guests/(?P<id>[^/]+)/', guest_handler),
)