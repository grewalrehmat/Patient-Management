import jwt
import datetime
from django.conf import settings
from django.http import JsonResponse
from django.contrib.auth.hashers import check_password
from rest_framework.decorators import api_view
from app.models import Employee

@api_view(["POST"])
def login_view(request):
    email = request.data.get("email")
    password = request.data.get("password")

    try:
        user = Employee.objects.get(email=email)
        if check_password(password, user.pwd):
            payload = {
                "id": user.employeeid,
                "email": user.email,
                "exp": datetime.datetime.utcnow() + datetime.timedelta(days=1),
                "role": user.role,
            }
            token = jwt.encode(payload, settings.SECRET_KEY, algorithm="HS256")
            return JsonResponse({"token": token})
        else:
            return JsonResponse({"error": "Invalid password"}, status=401)
    except Employee.DoesNotExist:
        return JsonResponse({"error": "User not found"}, status=404)
