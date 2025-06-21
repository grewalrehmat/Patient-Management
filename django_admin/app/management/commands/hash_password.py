from django.core.management.base import BaseCommand
from django.contrib.auth.hashers import make_password
from app.models import Employee

class Command(BaseCommand):
    help = "Hashes all unhashed employee passwords"

    def handle(self, *args, **kwargs):
        updated = 0
        for employee in Employee.objects.all():
            if not employee.pwd.startswith("pbkdf2_"):
                raw_pw = employee.pwd
                employee.pwd = make_password(raw_pw)
                employee.save()
                self.stdout.write(f"[+] Hashed password for {employee.email}")
                updated += 1
        self.stdout.write(self.style.SUCCESS(f"✅ {updated} password(s) hashed."))
