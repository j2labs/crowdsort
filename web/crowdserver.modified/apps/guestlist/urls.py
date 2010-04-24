from django.conf.urls.defaults import *

urlpatterns = patterns('guestlist.views',
    url(r'^$', 'query_names', name="guestlist_query_names"),
    url(r'^show/(?P<gid>\d+)$', 'show_by_id', name="guestlist_show_by_id"),
    url(r'^show/$', 'show_by_name', name="guestlist_show_by_name"),

    url(r'^alter/(?P<gid>\d+)$', 'alter_guest_status', name="alter_guest_status"),
    url(r'^alter/$', 'alter_guest_status', name="alter_guest_status"),

    url(r'^match/$', 'match_first_initial', name="match_first_initial"),
)
