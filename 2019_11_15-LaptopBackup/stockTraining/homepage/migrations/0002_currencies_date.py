# Generated by Django 2.2.6 on 2019-10-23 14:06

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('homepage', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='currencies',
            name='date',
            field=models.CharField(default='1970.01.01 00:00', max_length=120),
        ),
    ]
