from guestlist.models import Guest, Household
from django.contrib import admin

def mark_unarrived(modeladmin, request, queryset):
    queryset.update(arrived=False)
mark_unarrived.short_description = "Mark guests: UNARRIVED"

def mark_unarrived(modeladmin, request, queryset):
    queryset.update(arrived=True)
mark_unarrived.short_description = "Mark guests: ARRIVED"

def zero_pluscounted(modeladmin, request, queryset):
    queryset.update(plus_counted=0)
zero_pluscounted.short_description = "Zero out guests counted"

class GuestAdmin(admin.ModelAdmin):
    list_display        = ('name', 'table_name', 'arrived', 'email', 'plus_count','plus_counted',)
    search_fields       = ('name', 'table_name', 'email', 'comments', )
    actions = [mark_unarrived, zero_pluscounted]

admin.site.register(Guest, GuestAdmin)
admin.site.register(Household)
