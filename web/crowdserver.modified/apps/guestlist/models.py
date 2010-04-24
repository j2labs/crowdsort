from django.db import models
from django.conf import settings
from django.utils.translation import ugettext_lazy as _

from datetime import date

class Household(models.Model):
    name = models.CharField(_('Name'), max_length=255)

    def __unicode__(self):
        return "%s" % (self.name,)

class Guest(models.Model):
    name = models.CharField(_('Name'), max_length=255)
    email_address = models.EmailField(_('Email address'), max_length=255)
    table_number = models.CharField(_('Table Number'), max_length=10)
    criteria = models.CharField(_('Criteria'), max_length=1024)
    event_date = models.DateField(_('Event Date'), default=date.today)
    arrived = models.BooleanField(_('Arrived'), default=False)
    plus_count = models.IntegerField(_('Additional guests'))
    plus_counted = models.IntegerField(_('Guests counted'))
    household = models.ForeignKey(Household)
    
    def __unicode__(self):
        return "%s :: %s" % (self.name, self.event_date)
    
    class Meta:
        ordering = ('-event_date',)
    
    def get_absolute_url(self):
        return ('show/', [str(self.id)])
    
    get_absolute_url = models.permalink(get_absolute_url)
