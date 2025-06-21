from django.db import models
from django.contrib.auth.hashers import make_password
from django.utils import timezone

class Employee(models.Model):
    employeeid = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)
    phone_number = models.CharField(max_length=15)
    email = models.EmailField(unique=True)
    pwd = models.CharField("Password", max_length=128)
    role = models.CharField(max_length=50)
        
    def save(self, *args, **kwargs):
        # Prevent double hashing
        if not self.pwd.startswith("pbkdf2_"):
            self.pwd = make_password(self.pwd)
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.name} ({self.role})"

    class Meta:
        db_table = "employees"
        verbose_name = "Employee"
        verbose_name_plural = "Employees"


class Patient(models.Model):
    patientid = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)
    age = models.IntegerField()
    gender = models.CharField(max_length=10)
    phone_number = models.CharField(max_length=15)

    def __str__(self):
        return f"{self.name}"

    class Meta:
        db_table = "patients"


class Report(models.Model):
    reportid = models.AutoField(primary_key=True)
    patient = models.ForeignKey(
        Patient,
        on_delete=models.CASCADE,
        db_column='patientid'
    )
    type = models.CharField(max_length=100)
    date_uploaded = models.DateTimeField(db_column='date_uploaded',default=timezone.now)

    def __str__(self):
        return f"{self.type} report for {self.patient.name} on {self.date_uploaded.strftime('%Y-%m-%d')}"

    class Meta:
        db_table = "reports"


class Prescribe(models.Model):
    id = models.AutoField(primary_key=True)  # Needed for Django Admin

    employee = models.ForeignKey(
        Employee,
        on_delete=models.CASCADE,
        db_column='employeeid'
    )
    patient = models.ForeignKey(
        Patient,
        on_delete=models.CASCADE,
        db_column='patientid'
    )

    def __str__(self):
        return f"{self.employee.name} → {self.patient.name}"

    class Meta:
        db_table = "prescribe"
        verbose_name_plural = "Prescriptions"
