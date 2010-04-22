from django.conf.urls.defaults import *
from django.conf import settings
from django.contrib import admin

admin.autodiscover()

urlpatterns = patterns('',

    (r'^$', 'entree.guestlist.views.search'),
    (r'^guests/(?P<guest_id>\d+)/$', 'entree.guestlist.views.detail'),
    (r'^names/$', 'entree.guestlist.views.find_names'),
    (r'^range/$', 'entree.guestlist.views.fetch_range'),
    (r'^admin/', include(admin.site.urls)),
#    (r'^grappelli/', include('grappelli.urls')),
    (r'^api/', include('entree.api.urls')),
)


if settings.DEBUG:
    
    urlpatterns += patterns('',
        (r'^debug/makenames/(?P<how_many>\d+)/$', 'entree.debugapp.views.makedata'),
        (r'^%s(?P<path>.*)$' % settings.MEDIA_URL, 'django.views.static.serve',
            {'document_root': settings.MEDIA_ROOT}),
    )
