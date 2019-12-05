from django.shortcuts import render, redirect
from .models import Currencies, emailSignup
from django.http import JsonResponse, HttpResponseRedirect

from .forms import EmailSignupForm

from django.contrib import messages

# Create your views here.
def index(request):
	allCurrencies = Currencies.objects.all() #[4500:4850]
	context = {"all_currencies": allCurrencies}
	return render(request, "homepage/index.html", context)

def train(request):
	allCurrencies = Currencies.objects.all() #[4500:4850]
	context = {"all_currencies": allCurrencies}
	return render(request, "homepage/train.html", context)

def compete(request):
	return render(request, "homepage/compete.html", {})

def learn(request):
	return render(request, "homepage/learn.html", {})

def coming_soon(request):
	form = EmailSignupForm(request.POST or None)

	if form.is_valid():
		form.save()

	context = {
		"form":form
	}

	return render(request, "homepage/coming_soon.html", context)
