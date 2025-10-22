# UniFix — One stop solution for Linux issues

Your all‑in‑one open‑source PaaS to automate dependency setups, fix lab machine issues, and streamline student–teacher workflows.

[![Open Source](https://img.shields.io/badge/powered%20by-open%20source-3fb950.svg)](#)  
[![Status](https://img.shields.io/badge/status-active-success.svg)](#)  
[![Tech](https://img.shields.io/badge/stack-React%20%7C%20Vite%20%7C%20Spring%20Boot%20%7C%20MongoDB-0ea5e9.svg)](#)

---

## ✨ What is UniFix?
UniFix is a lightweight Platform‑as‑a‑Service designed for students, TAs and lab admins to simplify technical maintenance and support inside campus labs.

It automates:
- Dependency installation (Python, Java, Docker, compilers, etc.)
- Database setup (MongoDB Atlas)
- System fixes (common Linux configs, broken packages, permissions)
- Storage configuration (NFS mounts, Samba shares)
- Utility management (network fixes, environment variables, services)
- Feedback intake and notifications to instructors/admins

Think: a student downloads a script from UniFix → executes it → problem solved in one shot.

---

## 🗂 Repository layout
```
UniFix/
├─ frontend/            # React + Vite app (UI, animations, scripts)
└─ Unifix/              # Spring Boot backend (REST API, email, MongoDB)
```

- Frontend dev server: http://localhost:5173 (Vite may auto‑shift to 5174/5175 if 5173 busy)
- Backend server: http://localhost:8081

---

## 🚀 Features
- Modern React UI with smooth CSS animations and particle effects
- Huge library of ready‑to‑run Bash scripts (see `frontend/public/scripts`)
- Feedback form with validation and persistence to MongoDB Atlas
- Email notifications to admins when new feedback is submitted
- CORS enabled for local development

---

## 🔐 Credentials you’ll need (once)

### 1) MongoDB Atlas
1. Create a free cluster at `https://www.mongodb.com/atlas`.
2. Create a database user (username + strong password).
3. Allow your IP (Network Access → IP Access List). Prefer 0.0.0.0/0 during development.
4. Get the connection string (Driver: Java). Example:
   
   `mongodb+srv://<USER>:<PASSWORD>@cluster0.xxxxx.mongodb.net/unifix?retryWrites=true&w=majority&appName=Cluster0`
5. If your password contains `@` or `%`, URL‑encode them (`@` → `%40`, `%` → `%25`).

Update backend `Unifix/src/main/resources/application.properties`:
```
spring.data.mongodb.uri=mongodb+srv://USER:PASSWORD@cluster0.xxxxx.mongodb.net/unifix?retryWrites=true&w=majority&appName=Cluster0
spring.data.mongodb.database=unifix
```

### 2) Gmail App Password (for email)
1. Enable 2‑Step Verification on your Google account.
2. Go to Security → App passwords → Generate new → App: Mail, Device: Other (e.g., UniFix Backend).
3. Copy the 16‑character password (remove spaces when pasting).
4. In `application.properties` set:
```
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=YOUR_GMAIL@example.com
spring.mail.password=YOUR_16_CHAR_APP_PASSWORD
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true

# Who receives notifications
app.email.from=YOUR_GMAIL@example.com
app.email.recipient=YOUR_GMAIL@example.com
```

Tip: Prefer environment variable for secrets in development shells: `export MAIL_PASSWORD=XXXX` then
```
spring.mail.password=${MAIL_PASSWORD}
```

---

## 🧰 Prerequisites
- Node.js ≥ 20.19 (or 22.12+) and npm
- Java 17+ (tested with 21) and Maven (or use the provided Maven Wrapper `./mvnw`)

---

## 🛠 Local development

### 1) Backend (Spring Boot)
```bash
cd Unifix
# using system Maven
mvn spring-boot:run
# or using wrapper
./mvnw spring-boot:run
```
Backend starts at http://localhost:8081

Test endpoints:
```bash
curl http://localhost:8081/api/feedback          # GET all feedback
curl -X POST http://localhost:8081/api/feedback \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","email":"test@example.com","message":"Hello from UniFix"}'
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
- Backend port: `server.port=8081` (change in `application.properties`)
- CORS: open by default for development
- API base URL used by the frontend points to `http://localhost:8081/api/feedback`

For production, expose the backend and set an env in the frontend (for example):
```
VITE_API_URL=https://your-domain/api
```

---

## 🧑‍🎓 How UniFix helps students and labs
- Removes friction: one place to find common fixes and scripts
- Faster lab support: students submit feedback, admins get notified via email
- Consistency: standardizes environment setup across many lab machines
- Extensible: add your own domain‑specific scripts and categories

---

## 🤝 Contributing
1. Fork the repo and create a feature branch.
2. Frontend: keep components small, prefer descriptive names, avoid one‑letter variables.
3. Backend: follow Spring conventions; avoid catching exceptions without handling.
4. Submit a PR with a clear description, screenshots (if UI), and test notes.

Run linters/tests locally where applicable before opening a PR.

---

## 🧩 Troubleshooting
- Gmail error `535 5.7.8 Username and Password not accepted`:
  - Use a Gmail App Password (not your normal password).
  - Paste 16 characters without spaces; ensure `app.email.from` equals your Gmail.
  - If Google blocks sign‑in, visit `https://accounts.google.com/DisplayUnlockCaptcha`, approve, then retry.
- MongoDB connection error with special characters in password:
  - URL‑encode `@` as `%40`, `%` as `%25` in the connection string.
- Vite error about Node version:
  - Upgrade Node to ≥ 20.19 or 22.12 (`nvm install 20.19.0` and `nvm use 20.19.0`).
- Port 8080 already in use:
  - Jenkins or another service may occupy it; UniFix uses 8081 by default.

---

## 📄 License
This project is open‑source under a permissive license (add your preferred license file if needed).

---

## 💬 Support
- Open an issue with logs and steps to reproduce.
- For setup help, include your `application.properties` (mask secrets) and exact error text.

Happy fixing! 🚀


