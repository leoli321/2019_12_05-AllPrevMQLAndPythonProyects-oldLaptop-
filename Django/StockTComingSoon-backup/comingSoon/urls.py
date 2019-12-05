from django.urls import path
from comingSoon import views

app_name = "homepage"
urlpatterns = [
	path('', views.index, name='index'),
	path("thankYou", views.indexThankYou, name = "thankYou"),
]