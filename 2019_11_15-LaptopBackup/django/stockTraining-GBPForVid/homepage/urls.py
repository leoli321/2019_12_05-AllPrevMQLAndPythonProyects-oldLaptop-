from django.urls import path
from homepage import views

app_name = "homepage"
urlpatterns = [
	path('train',views.train, name ="train"),
	path('compete',views.compete, name ="compete"),
	path('learn',views.learn, name ="learn"),
	path("coming_soon",views.coming_soon, name = "coming_soon"),
	path('', views.index, name='index'),
]