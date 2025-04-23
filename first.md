# 🏥 MedVault — AI-Enhanced Patient Record System

A scalable, secure, and intelligent healthcare platform that digitizes patient records, provides AI-assisted diagnosis, and supports real-time supervision and data control for doctors, interns, and trainees.

## 💡 Project Overview

MedVault is a cloud-based Electronic Health Record (EHR) system designed for hospitals and research facilities. It features a web and mobile interface for doctors and trainees to:
- Access and update patient records.
- Upload lab reports and medical imaging.
- Receive AI-generated possible diagnoses using OCR + NLP.
- Track patient mortality trends.
- Maintain supervisory hierarchies between interns and doctors.

## 🧠 Features

- **User Roles**: Doctor, Intern/Trainee, Admin.
- **Authentication System**: Token-based (DRF), auto-expiring for interns on exit.
- **Patient Dashboard**: View medical history, reports, prescriptions.
- **Lab Report OCR**: Extracts text from uploaded reports.
- **AI Microservice**: Uses ML/NLP to suggest possible diagnoses.
- **Mortality Rate Tracker**: Calculates mortality trends per department/doctor.
- **Supervisor Linking**: Intern logins are tied to supervising doctors.

---

## ⚙️ Tech Stack

### 🔗 Frontend (Web & App)
- **React JS** → Web portal for doctors/admins.
- **React Native** → Mobile app for real-time access on the go.
- **Axios** → Handles API requests to backend.

### 🧩 Backend (Core)
- **Django** → Web framework and API gateway.
- **Django REST Framework (DRF)** → Exposes RESTful APIs.
- **Service Layer Architecture** → Separates business logic cleanly.

### 🗄️ Database & Caching
- **PostgreSQL** → Main database for all patient/user data.
- **Redis** → Cache for session tokens, frequently accessed records, etc.

### 🧠 AI Microservice
- **FastAPI** or **Flask** → Lightweight Python service.
- **Tesseract OCR** → Extracts data from PDF/image lab reports.
- **Transformers / spaCy / Custom ML Models** → Analyzes report data, generates JSON diagnosis.
- **Diagnosis JSON** → Sent back to Django for display + logging.

---

## 🛡️ Security & Access

- **Role-Based Permissions**: Interns have restricted access; doctors have extended access.
- **Token Management**: JWT or session-based, auto-expired for interns post tenure.
- **Encrypted Storage**: Patient data is encrypted using AES-256 at rest.
- **Audit Logs**: All changes are timestamped and stored.

---

---

## 📊 Mortality Rate Calculation

Each patient record is tagged with:
- Admission date
- Discharge date
- Status (`recovered`, `deceased`)
- Doctor ID / Department

Django aggregates this data by month/quarter/year to show:
- Individual disease mortality rate trend.
- Department-level analysis.

---

## 📱 App Features (React Native)

- Login via QR/Token.
- View assigned patients.
- Upload reports directly via camera.
- Get real-time AI feedback.
- Logout auto when internship ends (managed from backend).

---

## 📘 Future Add-ons

- Analytics dashboard for hospital heads.
- Multilingual OCR support.
- Federated Learning for AI model retraining with anonymized data.

---

## 📄 License

This project is licensed under the **Apache 2.0 License** — see the [LICENSE](LICENSE) file for details.

---