from django.conf.urls.defaults import *
from django.conf import settings
from django.contrib import admin

urlpatterns = patterns('',

    (r'^makedata/(?P<how_many>\d+)/$', 'debugapp.views.makedata'),
)
