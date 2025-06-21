from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth.hashers import check_password
from .models import Employee

class EmployeeLoginView(APIView):
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')

        try:
            employee = Employee.objects.get(email=email)
        except Employee.DoesNotExist:
            return Response({"error": "Employee not found"}, status=status.HTTP_404_NOT_FOUND)

        if not check_password(password, employee.pwd):
            return Response({"error": "Invalid password"}, status=status.HTTP_401_UNAUTHORIZED)

        # Create JWT token for employee
        refresh = RefreshToken.for_user(employee)
        return Response({
            "access": str(refresh.access_token),
            "refresh": str(refresh),
        }, status=status.HTTP_200_OK)
