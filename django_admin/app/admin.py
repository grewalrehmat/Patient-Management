from django.contrib import admin
from .models import Employee, Patient, Report, Prescribe

@admin.register(Employee)
class EmployeeAdmin(admin.ModelAdmin):
    list_display = ['employeeid', 'name', 'phone_number', 'email', 'role']

@admin.register(Patient)
class PatientAdmin(admin.ModelAdmin):
    list_display = ['patientid', 'name', 'age', 'gender', 'phone_number']

@admin.register(Report)
class ReportAdmin(admin.ModelAdmin):
    list_display = ['reportid', 'patient', 'type', 'date_uploaded']

@admin.register(Prescribe)
class PrescribeAdmin(admin.ModelAdmin):
    list_display = ['employee', 'patient']
