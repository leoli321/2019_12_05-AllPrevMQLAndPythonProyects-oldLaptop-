from django import forms
from .models import emailSignup

class EmailSignupForm(forms.ModelForm):
	class Meta:
		model = emailSignup
		fields = [
			"email",
		]
	#your_email = forms.EmailField(max_length = 100, label = "Your email")
	