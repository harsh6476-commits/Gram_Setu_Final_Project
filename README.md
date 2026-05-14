# Gram Setu 🏥
**Swasthya Seva Aapke Dwar — A production-ready healthcare management platform for rural India.**

---

## 📖 Problem Statement
In rural communities, maintaining synchronized health records between Panchayat officials, ASHA workers, and remote Doctors is challenging. Lack of infrastructure leads to fragmented patient histories, delayed consultations, and disconnected healthcare workflows. Gram Setu solves this by bridging the gap via a unified, cloud-connected mobile application.

## ✨ Features
* **Role-Based Dashboards:** Dedicated secure portals for Patients, ASHA Workers, Doctors, and Panchayat Members.
* **Remote Consultations:** Patients and ASHA workers can request consultations from available doctors.
* **Prescription Management:** Doctors can issue digital prescriptions linked securely to Patient UIDs.
* **Cloud Sync:** Real-time data synchronization powered by MongoDB Atlas.
* **Smart UI/UX:** Built with Flutter for a smooth, cross-platform experience.

## 🛠️ Tech Stack
* **Frontend:** Flutter & Dart
* **Backend:** Node.js & Express.js
* **Database:** MongoDB Atlas
* **Deployment:** Render (Live Production Cloud)

---

## 🏗️ Architecture Diagram
```text
┌─────────────────┐       HTTPS       ┌────────────────────┐       TLS       ┌───────────────┐
│                 │   (REST APIs)     │                    │  (Mongoose)     │               │
│  Flutter App    ├──────────────────►│  Render Hosted     ├────────────────►│ MongoDB Atlas │
│  (Android/iOS)  │                   │  Node.js Backend   │                 │ Cloud Cluster │
│                 │                   │                    │                 │               │
└─────────────────┘                   └────────────────────┘                 └───────────────┘
```

---

## 📱 Live Demo
* **Backend API Base URL:** `https://gram-setu-backend.onrender.com/api`
* **Health Check Ping:** `https://gram-setu-backend.onrender.com/health`

*(Note: The Render backend sleeps after 15 minutes of inactivity. The Flutter app is programmed to gracefully wait and display a "Server waking up..." message during cold starts).*

---

## ⚙️ Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/harsh6476-commits/Gram_Setu_Final_Project.git
cd Gram_Setu_Final_Project
```

### 2. Backend Setup
The backend is completely separated into the `/backend` folder.
```bash
cd backend
npm install
```

**Environment Variables:**
Create a `.env` file inside the `backend` folder using the provided `.env.example` template:
```env
MONGO_URI=mongodb+srv://<user>:<pass>@cluster0...
JWT_SECRET=your_jwt_secret
```

**Run Locally:**
```bash
npm run dev
```

### 3. Frontend Setup (Flutter)
Return to the root directory and install Flutter dependencies:
```bash
flutter pub get
```

**Run the App:**
```bash
flutter run
```
*(The app is pre-configured to automatically connect to the live Render backend. No local tunneling is required).*

---

## 📂 Folder Structure
* `/lib`: The primary Flutter frontend source code, split into `core`, `pages`, and `services`.
* `/backend`: The Express.js backend containing `controllers`, `models`, and `routes`.
* `/assets`: Application images and static resources.

---

## 🚀 Future Improvements
* **Video Consultations:** Integrate WebRTC for live doctor-patient video calls.
* **AI Diagnostics:** Analyze patient symptoms dynamically using an LLM.
* **Offline First:** Implement local SQLite caching so ASHA workers can operate in dead zones and sync when internet is restored.

---
*Built with ❤️ for Hackathon 2026*
