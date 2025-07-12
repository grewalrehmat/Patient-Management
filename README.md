# MedVault-RS — AI-Enhanced Medical Record System (Rust Backend)

MedVault-RS is a high-performance, memory-safe EHR backend written in Rust. It enables hospitals, labs, and research centers to securely store, access, and analyze patient records in real-time with AI-powered insights and strict role-based access.

---

## Overview

This backend powers the MedVault system — a secure, scalable, and efficient healthcare record manager. Built with Rust and Actix-Web, it provides:

- Secure user authentication and session handling
- Role-based access to patient data
- AI-assisted diagnostics from lab reports
- Intern/trainee token management with auto-expiry
- OCR + NLP-based lab report parsing via Python microservice

---

## Features

- Doctor / Trainee / Admin login system
- Secure storage of patient records and lab data
- Intern access restricted by tokens, revoked automatically
- AI microservice integration (Flask/FastAPI)
- OCR-based PDF/lab report ingestion
- Token-based access control using JWT
- Scalable Actix-Web backend with Diesel ORM
- Full Docker + Postgres setup for local or production deployment

---

## Tech Stack

### Backend (Rust)

- **Actix-Web** — async web framework
- **Diesel ORM** — compile-time safe DB interactions
- **JWT** — token-based auth
- **Argon2 / bcrypt** — password hashing
- **Serde** — serialization/deserialization
- **PostgreSQL** — primary relational DB

### AI Microservice (Python)

- **Flask / FastAPI** — lightweight AI service
- **Tesseract OCR** — text extraction from reports
- **spaCy / HuggingFace** — NLP for diagnosis suggestions
- **Returns JSON** to Rust backend for frontend consumption

### Frontend (Planned)

- **React.js** for the Web Dashboard
- **Flutter** mobile app for trainees/interns
- **Axios** for HTTP communication

---

## Access Control Matrix

| Role     | Patients | Reports | Admin Panel | Auth Tokens |
|----------|----------|---------|-------------|-------------|
| Doctor   | Full     | Full    | No          | Yes         |
| Trainee  | Linked   | Upload  | No          | Yes         |
| Admin    | CRUD     | CRUD    | Full        | Yes         |
| Intern   | Limited  | Upload  | No          | Auto-expiry |

Intern access is granted via tokens that are automatically invalidated upon exit.

---

## Security Practices

- JWT-based login system
- Argon2/bcrypt password hashing
- Role-based guards for API routes
- `.env` based secret/key management
- Dockerized DB and backend for isolation

---

## Getting Started

### Prerequisites

- Docker / Docker Compose
- Rust (for native build)
- PostgreSQL

### Quickstart

```bash
# Start backend + DB
docker-compose up --build

# Or run Rust backend manually
cd patients/
cargo run
```


### Folder Structure
```bash
Patient-Management/
├── patients/             # Rust backend
│   ├── src/
│   ├── Dockerfile
│   ├── Cargo.toml
├── .env.example
├── docker-compose.yml
├── pgi_app
```
