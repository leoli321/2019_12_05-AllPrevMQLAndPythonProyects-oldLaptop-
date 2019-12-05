from django.contrib import admin
from .models import Currencies, News


# Register your models here.


from import_export.admin import ImportExportModelAdmin
@admin.register(Currencies)
class CurrenciesResource(ImportExportModelAdmin):
	pass


@admin.register(News)
class NewsResource(ImportExportModelAdmin):
	pass
