from django.shortcuts import render
from .models import emailSignup, Currencies
from django.contrib import messages
# Create your views here.


from .forms import EmailSignupForm
def index(request):
	form = EmailSignupForm(request.POST or None)

	if form.is_valid():
		email_signup_qs = emailSignup.objects.filter(email = form.instance.email)
		if email_signup_qs.exists():
			messages.info(request, "You are already subscribed")
			return render(request, "comingSoon/youAlreadySubscribed.html", {})
		else:
			form.save()
			return render(request, "comingSoon/indexThankYou.html", {})
			
	allCurrencies = Currencies.objects.all()
	context = {
		"form":form,
		"all_currencies": allCurrencies
	}

	return render(request, "comingSoon/index.html", context)

def indexThankYou(request):
	return render(request, "comingSoon/indexThankYou.html", {})