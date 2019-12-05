from django.shortcuts import render
from .models import AAPL, MSFT, HPQ, SNE
# Create your views here.

def dashboard(request):
	AAPLs = AAPL.objects.all()
	MSFTs = MSFT.objects.all()
	HPQs = HPQ.objects.all()
	SNEs = SNE.objects.all()

	context = {
		"AAPLs": AAPLs,
		"MSFTs": MSFTs,
		"HPQs": HPQs,
		"SNEs": SNEs
	}

	return render(request, "dashboard/index.html", context)
