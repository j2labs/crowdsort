from django.conf.urls.defaults import *
from django.http import HttpResponseRedirect
from django.core.urlresolvers import reverse


urlpatterns = patterns('api.views',

    (r'^$', lambda request: HttpResponseRedirect(reverse('home'))),
    (r'^login/$', 'login'),
    (r'^guests/(?P<guest_id>\d+)/$', 'detail'),
    (r'^names/$', 'names'),
)
