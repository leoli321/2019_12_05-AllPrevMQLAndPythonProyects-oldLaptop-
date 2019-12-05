from django.db import models
import datetime
from django.utils import timezone
# Create your models here.

class emailSignup(models.Model):
	email = models.EmailField(max_length = 100)
	timestamp = models.DateTimeField(auto_now_add = True)

	def __str__(self):
		return self.email

class Currencies(models.Model):
	Symbol = models.CharField(max_length=20)
	date = models.CharField(max_length = 22)
	Open = models.DecimalField(max_digits= 30,decimal_places = 6)
	High = models.DecimalField(max_digits= 30,decimal_places = 6)
	Low = models.DecimalField(max_digits= 30,decimal_places = 6)
	Close = models.DecimalField(max_digits= 30,decimal_places = 6)
	Volume = models.DecimalField(max_digits= 30,decimal_places = 1)
	MovingAverage = models.DecimalField(max_digits= 30,decimal_places = 6, default = "0")

	def __str__(self):
		return self.Symbol + " " + str(self.date) 