from django.conf import settings
from django.conf.urls.defaults import *
from django.views.generic.simple import direct_to_template

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',

    url(r'^$', 'guestlist.views.landing', name='home'),
    (r'^names/', include('guestlist.urls')),
    (r'^api/', include('api.urls')),                       

    (r'^grappelli/', include('grappelli.urls')),
    (r'^admin/', include(admin.site.urls)),
)


if settings.SERVE_MEDIA:

    urlpatterns += patterns('',
        (r'^debug/makenames/(?P<how_many>\d+)/$', 'debugapp.views.makedata'),
        (r'^site_media/(?P<path>.*)$', 'django.views.static.serve',
         {'document_root': settings.MEDIA_ROOT})
    )

