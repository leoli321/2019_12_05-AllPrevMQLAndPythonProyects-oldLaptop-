from django.db import models

# Create your models here.
class Currencies(models.Model):
	Symbol = models.CharField(max_length=20)
	date = models.CharField(max_length = 22)
	Open = models.DecimalField(max_digits= 30,decimal_places = 6)
	High = models.DecimalField(max_digits= 30,decimal_places = 6)
	Low = models.DecimalField(max_digits= 30,decimal_places = 6)
	Close = models.DecimalField(max_digits= 30,decimal_places = 6)
	Volume = models.DecimalField(max_digits= 30,decimal_places = 1)
	MovingAverage = models.DecimalField(max_digits= 30,decimal_places = 6, default = "0")
	Name = models.CharField(max_length = 140, default = "")
	TimeFrame = models.CharField(max_length = 30, default = "")

	def __str__(self):
		return self.Symbol + " " + str(self.date) 

class News(models.Model):
	date = models.CharField(max_length=20)
	title = models.CharField(max_length = 300)
	name = models.CharField(max_length = 200)

	def __str__(self):
		return self.date + " " + str(self.title)