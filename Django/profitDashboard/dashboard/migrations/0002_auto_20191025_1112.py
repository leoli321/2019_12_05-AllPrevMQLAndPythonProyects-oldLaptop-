# Generated by Django 2.2.6 on 2019-10-25 16:12

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('dashboard', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='revenue',
            name='revenue',
            field=models.IntegerField(),
        ),
    ]
