from guestlist.models import Guest, Household
from django.contrib import admin

def mark_unarrived(modeladmin, request, queryset):
    queryset.update(arrived=False)
mark_unarrived.short_description = "Mark guests as unarrived"

def zero_pluscounted(modeladmin, request, queryset):
    queryset.update(plus_counted=0)
zero_pluscounted.short_description = "Zero out guests counted"

class GuestAdmin(admin.ModelAdmin):
    list_display        = ('name', 'event_date', 'arrived', 'vip', 'plus_count','plus_counted',)
    search_fields       = ('name', 'event_date',)
    actions = [mark_unarrived,zero_pluscounted]

admin.site.register(Guest, GuestAdmin)
admin.site.register(Household)
