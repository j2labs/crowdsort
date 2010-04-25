from django.db import models
from django.conf import settings
from django.utils.translation import ugettext_lazy as _

from datetime import datetime

class Guest(models.Model):
    name = models.CharField(_('Name'), max_length=255, default=u'Unknown')
    iml_num = models.CharField(_('IML Number'), max_length=255, blank=True, null=True)
    re_id = models.CharField(_('RE ID'), max_length=255, blank=True, null=True)
    table_name = models.CharField(_('Table Name'), max_length=100, blank=True, null=True)
    email = models.EmailField(_('Email Address'), max_length=255, blank=True, null=True)
    comments = models.CharField(_('Comments'), max_length=1024, blank=True, null=True)
    phone_number = models.CharField(_('Phone Number'), max_length=13, blank=True, null=True)
    arrived = models.BooleanField(_('Arrived'), default=False)
    plus_count = models.IntegerField(_('Additional guests'), default=0)
    plus_counted = models.IntegerField(_('Guests counted'), default=0)

    def __unicode__(self):
        return u'%s' % (self.name)
    
    class Meta:
        ordering = ('-name',)
    
    def get_absolute_url(self):
        return ('show/', [str(self.id)])
    
    get_absolute_url = models.permalink(get_absolute_url)
