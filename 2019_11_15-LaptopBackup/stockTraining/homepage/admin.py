from django.contrib import admin
from .models import Currencies, emailSignup

from import_export.admin import ImportExportModelAdmin

# Register your models here.
#admin.site.register(Currencies)

@admin.register(Currencies)
class CurrenciesResource(ImportExportModelAdmin):
	pass

admin.site.register(emailSignup)