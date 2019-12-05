from django.contrib import admin
from .models import emailSignup, Currencies

from import_export.admin import ImportExportModelAdmin
# Register your models here.
admin.site.register(emailSignup)

@admin.register(Currencies)
class CurrenciesResource(ImportExportModelAdmin):
	pass