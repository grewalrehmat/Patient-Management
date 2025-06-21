# Use official Python image
FROM python:3.12-slim

# Set environment
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy project files
COPY . .

# Run Django development server (override this with gunicorn in prod)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
