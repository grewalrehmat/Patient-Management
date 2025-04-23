# 🏥 MedVault-JS — AI-Enhanced Medical Record System (Node.js Backend)

Welcome to **MedVault-JS**, a full-stack, AI-integrated, secure medical data system built with **Node.js**, **React**, and **React Native**. It supports full patient record management, OCR/NLP diagnostics, trainee supervision, and real-time insights.

---

## 📌 Project Objective

To build a cross-platform, AI-assisted application that:
- Stores & retrieves patient medical data.
- Assigns trainees under doctors with revocable access.
- Uses OCR + NLP to analyze lab reports.
- Tracks mortality rate trends per doctor/hospital.
- Provides both web and mobile app interfaces.

---

## ⚙️ Tech Stack

### 🎯 Frontend
- **React.js** – Web app for doctors/admins.
- **React Native** – Mobile app for doctors/trainees.
- **Axios** – API communication layer.

### ⚡ Backend (Node.js)
- **Express.js** – API routing and middleware.
- **Sequelize / Prisma** – ORM for PostgreSQL.
- **JWT** – Auth tokens.
- **bcryptjs** – Password hashing.
- **Helmet, CORS, Rate Limiter** – Security middlewares.

### 🧠 AI Microservice
- **Python** (FastAPI or Flask)
- **Tesseract OCR** – Extract lab text from images.
- **spaCy / HuggingFace Transformers** – Analyze text & predict conditions.

### 🧠 DB & Caching
- **PostgreSQL** – Core data (patients, reports, users).
- **Redis** – Token/session caching and dashboard speedups.

---
---

## 🛡️ Roles & Access

- **Doctors**: Full access to their patients and assigned trainees.
- **Trainees**: Linked under a doctor, auto-expire token on exit.
- **Admins**: Manage hospital-wide access and analytics.

Tokens are generated upon login and invalidated on internship completion.

---

## 📊 Mortality Rate Module

Each record logs:
- Admission, discharge, and outcome (alive/deceased)
- Treated by which doctor or trainee

Node.js calculates trends with:
- `/api/mortality/overall`
- `/api/mortality/doctor/:id`
- Dashboard data served in React.

---

## 📱 Mobile App Features

- Login via trainee/doctor tokens.
- Upload lab reports for AI diagnosis.
- View AI-analyzed cases.
- View personal and department-level trends.
- Forced logout post-internship via backend trigger.

---


## 🔒 Security Stack

- JWT + Role-based middleware (RBAC)
- Token TTL set via Redis (for expiring interns)
- bcrypt for secure credential storage
- CORS, Helmet, rate-limiting enforced

---

## 🧠 AI Features

- Upload image (report) → Sent to AI microservice
- OCR reads the report
- NLP detects issues/symptoms
- JSON sent back to frontend
- Optionally suggest next steps (e.g., blood test, CT scan)

---