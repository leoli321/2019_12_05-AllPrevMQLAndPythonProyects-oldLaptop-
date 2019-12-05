from django import forms
from .models import emailSignup

class EmailSignupForm(forms.ModelForm):
	email = forms.EmailField(widget = forms.TextInput(attrs={
		"type": "email",
		"name": "email",
		"id": "email",
		"placeholder": "Your email goes here"
		}), label = ""
	)
	class Meta:
		model = emailSignup
		fields = [
			"email",
		]
	#your_email = forms.EmailField(max_length = 100, label = "Your email")
	