from django.shortcuts import render
from .models import Currencies, News

# Create your views here.

def index(request):
	allCurrencies = Currencies.objects.all()
	context = {
		"all_currencies": allCurrencies
	}

	return render(request,"website/index.html", context)


def Nasdaq_2019_11_06(request):

	newsData = News.objects.filter(name = "2019_11_06-BullFlagAndBreakoutTrend")
	data = Currencies.objects.filter(Name = "2019_11_06-BullFlagAndBreakoutTrend")
	hour4data = data.filter(TimeFrame = "4h")
	dailydata = data.filter(TimeFrame = "daily")
	context = {
		"data": data,
		"hour4data": hour4data,
		"dailydata": dailydata,
		"news": newsData
	}

	return render(request,"website/Nasdaq_2019_11_06.html", context)

def AAPL_2019_11_08(request):

	newsData = News.objects.filter(name = "2019_11_08-AppleEarnings-Q32019-OCT")
	data = Currencies.objects.filter(Name = "2019_11_08-AppleEarnings-Q32019-OCT")
	hour4data = data.filter(TimeFrame = "4h")
	dailydata = data.filter(TimeFrame = "daily")
	context = {
		"data": data,
		"hour4data": hour4data,
		"dailydata": dailydata,
		"news": newsData
	}

	return render(request,"website/AAPL_2019_11_08.html", context)

def AAPL_2019_11_09(request):

	newsData = News.objects.filter(name = "2019_11_09-AppleEarnings-Q22019-JUL")
	data = Currencies.objects.filter(Name = "2019_11_09-AppleEarnings-Q22019-JUL")
	hour4data = data.filter(TimeFrame = "4h")
	dailydata = data.filter(TimeFrame = "daily")
	context = {
		"data": data,
		"hour4data": hour4data,
		"dailydata": dailydata,
		"news": newsData
	}

	return render(request,"website/AAPL_2019_11_09.html", context)


def AAPL_2019_11_09_2(request):

	newsData = News.objects.filter(name = "2019_11_09-AppleEarnings-Q22019-APR")
	data = Currencies.objects.filter(Name = "2019_11_09-AppleEarnings-Q22019-APR")
	hour4data = data.filter(TimeFrame = "4h")
	dailydata = data.filter(TimeFrame = "daily")
	context = {
		"data": data,
		"hour4data": hour4data,
		"dailydata": dailydata,
		"news": newsData
	}

	return render(request,"website/AAPL_2019_11_09_2.html", context)

def AAPL_2019_11_11(request):

	newsData = News.objects.filter(name = "2019_11_11-AppleEarnings-Q12019-JAN")
	data = Currencies.objects.filter(Name = "2019_11_11-AppleEarnings-Q12019-JAN")
	hour4data = data.filter(TimeFrame = "4h")
	dailydata = data.filter(TimeFrame = "daily")
	context = {
		"data": data,
		"hour4data": hour4data,
		"dailydata": dailydata,
		"news": newsData
	}

	return render(request,"website/AAPL_2019_11_11.html", context)

def EURCHF_2019_11_11(request):

	newsData = News.objects.filter(name = "2019_11_11-EURCHF-DowntrendMaySep-2019")
	data = Currencies.objects.filter(Name = "2019_11_11-EURCHF-DowntrendMaySep-2019")
	hour4data = data.filter(TimeFrame = "4h")
	dailydata = data.filter(TimeFrame = "daily")
	context = {
		"data": data,
		"hour4data": hour4data,
		"dailydata": dailydata,
		"news": newsData
	}

	return render(request,"website/EURCHF_2019_11_11.html", context)


def ScenarioTemplateCurrency(request):

	newsData = News.objects.filter(name = "2019_11_11-EURCHF-DowntrendMaySep-2019")
	data = Currencies.objects.filter(Name = "2019_11_11-EURCHF-DowntrendMaySep-2019")
	hour4data = data.filter(TimeFrame = "4h")
	dailydata = data.filter(TimeFrame = "daily")
	context = {
		"data": data,
		"hour4data": hour4data,
		"dailydata": dailydata,
		"news": newsData
	}

	return render(request,"website/ScenarioTemplateCurrency.html", context)


def ScenarioTemplateStock(request):

	newsData = News.objects.filter(name = "2019_11_11-AppleEarnings-Q12019-JAN")
	data = Currencies.objects.filter(Name = "2019_11_11-AppleEarnings-Q12019-JAN")
	hour4data = data.filter(TimeFrame = "4h")
	dailydata = data.filter(TimeFrame = "daily")
	context = {
		"data": data,
		"hour4data": hour4data,
		"dailydata": dailydata,
		"news": newsData
	}

	return render(request,"website/ScenarioTemplateStock.html", context)








