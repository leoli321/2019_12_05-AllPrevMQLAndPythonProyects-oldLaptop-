"""FxTrainMain URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path("", include("website.urls")),
    path("Nasdaq_2019_11_06/",include("website.urls")),
    path("AAPL_2019_11_08/",include("website.urls")),
    path("AAPL_2019_11_09/",include("website.urls")),
    path("AAPL_2019_11_09_2/",include("website.urls")),
    path("AAPL_2019_11_11/",include("website.urls")),
    path("EURCHF_2019_11_11/",include("website.urls")), 
    path("ScenarioTemplateCurrency/",include("website.urls")),
    path("ScenarioTemplateStock/",include("website.urls")),
]
