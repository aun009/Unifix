# UniFix — One stop solution for Linux issues

Your all‑in‑one open‑source PaaS to automate dependency setups, fix lab machine issues, and streamline student–teacher workflows.

[![Open Source](https://img.shields.io/badge/powered%20by-open%20source-3fb950.svg)](#)  
[![Status](https://img.shields.io/badge/status-active-success.svg)](#)  
[![Tech](https://img.shields.io/badge/stack-React%20%7C%20Vite%20%7C%20Node.js%20%7C%20PostgreSQL-0ea5e9.svg)](#)

---

## ✨ What is UniFix?
UniFix is a lightweight Platform‑as‑a‑Service designed for students, TAs and lab admins to simplify technical maintenance and support inside campus labs.

It automates:
- Dependency installation (Python, Java, Docker, compilers, etc.)
- Database setup (automated configuration scripts)
- System fixes (common Linux configs, broken packages, permissions)
- Storage configuration (NFS mounts, Samba shares)
- Utility management (network fixes, environment variables, services)
- Feedback intake and notifications to instructors/admins

Think: a student downloads a script from UniFix → executes it → problem solved in one shot.

---

## 🗂 Repository layout
```
UniFix/
├─ frontend/            # React + Vite app (UI, animations, responsive design)
├─ backend/             # Node.js + Express backend (REST API, Neon PostgreSQL)
└─ Unifix/              # (Legacy) Original Spring Boot backend
```

- Frontend dev server: http://localhost:5173
- Backend server: http://localhost:8081

---

## 🚀 Features
- Modern React UI with smooth CSS animations, particle effects, and fully responsive layouts for mobile and tablet devices
- Huge library of ready‑to‑run Bash scripts (see `frontend/public/scripts`)
- Feedback form with validation and persistence to Neon PostgreSQL
- Email notifications to admins when new feedback is submitted
- CORS enabled for local development

---

## 🔐 Credentials and Setup

### 1) Neon PostgreSQL
1. Create a database instance or log into your dashboard at `https://neon.tech`.
2. Retrieve your connection string from the console. Example:
   
   `postgresql://neondb_owner:npg_wzrm1cWXitC3@ep-falling-bread-adpoy9ql.c-2.us-east-1.aws.neon.tech/neondb?sslmode=require`

Create the environment file `backend/.env` with your parameters:
```env
PORT=8081
DATABASE_URL=postgresql://neondb_owner:npg_wzrm1cWXitC3@ep-falling-bread-adpoy9ql.c-2.us-east-1.aws.neon.tech/neondb?sslmode=require
```

Initialize the database schema (`feedbacks` table creation) by running:
```bash
cd backend
node init-db.js
```

### 2) SMTP / Gmail App Password (Optional, for email notifications)
1. Enable 2‑Step Verification on your Google account.
2. Go to Security → App passwords → Generate new.
3. Copy the 16‑character password.
4. Append these variables to your `backend/.env`:
```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=YOUR_GMAIL@example.com
SMTP_PASS=YOUR_16_CHAR_APP_PASSWORD
SMTP_RECEIVER=YOUR_GMAIL@example.com
```

---

## 🧰 Prerequisites
- Node.js ≥ 20.x
- npm

---

## 🛠 Local development

### 1) Backend (Node.js + Express)
```bash
cd backend
npm install
npm start
```
To run in development mode with automatic hot reloading (via nodemon):
```bash
npm run dev
```

Test endpoints:
```bash
curl http://localhost:8081/api/feedback/health    # GET health check
curl http://localhost:8081/api/feedback           # GET all feedbacks
curl -X POST http://localhost:8081/api/feedback \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","message":"Hello from UniFix Node.js backend"}'
```

### 2) Frontend (React + Vite)
```bash
cd frontend
npm install
npm run dev
```
Open the printed Local URL (typically http://localhost:5173).

---

## ⚙️ Configuration options
- Backend port: `PORT=8081` (can be configured in `backend/.env`)
- CORS: opens automatically for development viewports
- API base URL: defaults to `http://localhost:8081/api` in local development. For production deployment, set `VITE_API_URL` to your production server address.

---

## 🤝 Contributing
1. Fork the repo and create a feature branch.
2. Frontend: keep components small, prefer descriptive names, avoid one‑letter variables.
3. Backend: write clean JavaScript, handle asynchronous errors, and use parameterized SQL queries to prevent SQL injections.
4. Submit a PR with a clear description, screenshots (if UI), and test notes.

---

## 📄 License
This project is open‑source under a permissive license (add your preferred license file if needed).

Happy fixing! 🚀
