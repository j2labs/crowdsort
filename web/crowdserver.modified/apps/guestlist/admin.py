from guestlist.models import Guest, Household
from django.contrib import admin
from django.contrib.contenttypes import generic
#
def mark_unarrived(modeladmin, request, queryset):
    queryset.update(arrived=False)
mark_unarrived.short_description = "Mark guests as unarrived"

#def zero_pluscounted(modeladmin, request, queryset):
#    queryset.update(plus_counted=0)
#zero_pluscounted.short_description = "Zero out guests counted"

class GuestAdmin(admin.ModelAdmin):
    list_display        = ('name', 'event_date', 'arrived', 'email_address','table_number',)
    search_fields       = ('name', 'event_date',)
    actions = [mark_unarrived,]

#class HouseholdInline(generic.GenericTabularInline):
#    model = Guest
#
#class HouseholdAdmin(admin.ModelAdmin):
#    inlines = [
#        HouseholdInline,
#    ]    

admin.site.register(Guest, GuestAdmin)
#admin.site.register(Household, HouseholdAdmin)
admin.site.register(Household)
