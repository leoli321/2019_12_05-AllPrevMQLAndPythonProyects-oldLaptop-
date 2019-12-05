# -*- coding: utf-8 -*-
"""
Created on Mon Oct 14 10:15:33 2019

@author: gvega
"""

from django.urls import path

from . import views

app_name = "polls"
urlpatterns = [
    #polls
    path('',views.index, name = "index"), #If you go to the homepage run index function
    #polls/5
    path('<int:question_id>/', views.detail, name = "detail"),
    #polls/5/results
    path('<int:question_id>/results/', views.results, name = "results"),
    #polls/5/vote
    path('<int:question_id>/vote/', views.results, name = "vote"),
]
