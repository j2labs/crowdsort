from django.conf.urls.defaults import *


urlpatterns = patterns('',

    (r'^$', 'entree.guestlist.views.search'),
    (r'^login/$', 'entree.api.views.login'),
    (r'^guests/(?P<guest_id>\d+)/$', 'entree.api.views.detail'),
    (r'^names/$', 'entree.api.views.names'),
)
