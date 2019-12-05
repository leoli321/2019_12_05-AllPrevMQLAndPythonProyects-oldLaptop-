from django.urls import path
from website import views

app_name = "website"
urlpatterns = [
	path('', views.index, name='index'),
	path("Nasdaq_2019_11_06", views.Nasdaq_2019_11_06, name = "Nasdaq_2019_11_06"),
	path("AAPL_2019_11_08", views.AAPL_2019_11_08, name = "AAPL_2019_11_08"),
	path("AAPL_2019_11_09", views.AAPL_2019_11_09, name = "AAPL_2019_11_09"),
	path("AAPL_2019_11_09_2", views.AAPL_2019_11_09_2, name = "AAPL_2019_11_09_2"),
	path("AAPL_2019_11_11", views.AAPL_2019_11_11, name = "AAPL_2019_11_11"),
	path("EURCHF_2019_11_11", views.EURCHF_2019_11_11, name = "EURCHF_2019_11_11"),
	path("ScenarioTemplateCurrency", views.ScenarioTemplateCurrency, name = "ScenarioTemplateCurrency"),
	path("ScenarioTemplateStock", views.ScenarioTemplateStock, name = "ScenarioTemplateStock"),
]