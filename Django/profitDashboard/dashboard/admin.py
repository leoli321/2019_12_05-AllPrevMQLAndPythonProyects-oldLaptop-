from django.contrib import admin
from .models import AAPL, MSFT, HPQ, SNE

from import_export.admin import ImportExportModelAdmin

# Register your models here.
#admin.site.register(Currencies)

@admin.register(AAPL)
class revenueResource(ImportExportModelAdmin):
	pass
@admin.register(MSFT)
class revenueResource(ImportExportModelAdmin):
	pass
@admin.register(HPQ)
class revenueResource(ImportExportModelAdmin):
	pass
@admin.register(SNE)
class revenueResource(ImportExportModelAdmin):
	pass		