# 🌉 Gram Setu — Rural Telemedicine & Healthcare

> **Setu Banao, Sehat Pao** — Building the bridge for rural health at the last mile.

Gram Setu is a comprehensive mobile platform designed for the rural Indian landscape. Built with **Flutter & Node.js**, it connects patients, doctors, ASHA workers, and pharmacists in a unified ecosystem supported by live vitals monitoring and multilingual AI.

---

## 🏥 Module Overview

Gram Setu provides specialized portals for each stakeholder:

*   **👤 Patient**: Remote consultation booking, health history, and vital tracking.
*   **🩺 Doctor**: Digital clinic with video calls, rPPG heart rate monitoring, and e-prescriptions.
*   **👩‍⚕️ ASHA Worker**: Community health management, patient registration, and local outreach.
*   **🏛️ Panchayat**: Village-level health statistics and administrative oversight.
*   **💊 Pharmacy**: Digital inventory management and a medicine marketplace for village users.

---

## ✨ Key Features

1.  **Contactless Vitals (rPPG)**: Heart rate and SpO2 estimation using only the phone's front camera (no wearables required).
2.  **Multilingual UI**: Dynamic translation across the entire app powered by **Sarvam AI**.
3.  **Real-time Consultations**: Video and status-based matching between rural patients and remote doctors.
4.  **Village Dashboard**: Analytics for local authorities to track health trends.
5.  **Medicine Hub**: Search local pharmacies and call them directly for medicines.

---

## 🚀 Quick Start Guide

> ⚠️ **IMPORTANT**: You must run the **Backend** and the **Flutter App** simultaneously.

### 1. Start the Backend
```bash
cd backend
npm install
npm run dev
```

### 2. Connect Your Mobile Device (Hackathon Setup)
If running on a **Physical Phone**, the app needs to know your laptop's address.
Open `lib/core/constants.dart` and choose your method:

#### Method A: Public Tunnel (Best for Remote/Judges)
1. Run `npm run tunnel` in your backend folder.
2. Copy the URL (e.g., `https://xyz.loca.lt`).
3. Set `useTunnel = true` and paste the URL in `tunnelUrl`.

#### Method B: Local Network (Physical IP)
1. Get your computer's IP (Windows: `ipconfig` -> `IPv4 Address`).
2. Set `usePhysicalIp = true` and paste your IP in `_manualIp`.
3. Ensures your phone and laptop are on the **Same Wi-Fi**.

### 3. Run the App
```bash
# Get dependencies
flutter pub get

# Launch app
flutter run
```

---

## 🛠 Tech Stack

*   **Frontend**: Flutter (Dart) with Provider
*   **Backend**: Node.js, Express, MongoDB Atlas
*   **AI/Vitals**: Sarvam AI (Translation), rPPG-Toolbox (Pulse detection)
*   **Tooling**: Localtunnel (Public Gateway)

---

## 📂 Project Structure

```
gram_setu/
├── lib/
│   ├── main.dart             # Route registry
│   ├── core/                 # Theme, Providers, Constants
│   ├── pages/                # All Screen widgets
│   ├── services/             # API and Vitals logic
│   ├── widgets/              # Reusable UI components
│   └── models/               # Client-side data models
├── backend/
│   ├── server.js             # Entry point
│   ├── routes/               # Express API routes
│   └── models/               # MongoDB Schemas
├── assets/                   # Images and Icons
└── pubspec.yaml              # App configuration
```

---

## 📋 Roadmap
- [x] Live Video Consultations
- [x] rPPG Pulse Monitoring
- [x] Multilingual Support (Sarvam AI)
- [x] Pharmacy Marketplace
- [x] ASHA Worker Outreach portal
- [ ] Offline-First Cache
- [ ] District Health API Integration

---

> Built with ❤️ for rural India.

---

## 🗺 Roadmap

- [x] Live video consultations
- [x] rPPG heart rate monitoring
- [x] Multilingual UI (Sarvam AI)
- [x] Doctor consultation dashboard
- [x] E-prescription module
- [x] ASHA worker integration
- [ ] District health API integration
- [ ] Offline-first mode
- [ ] Live rPPG deployment at scale

---

## 🙏 Acknowledgements

- [rPPG-Toolbox](https://github.com/ubicomplab/rPPG-Toolbox) — UbiComp Lab, University of Washington
- [Sarvam AI](https://api.sarvam.ai) — Indian language translation API
- [Flutter](https://flutter.dev) — Google's UI toolkit for cross-platform apps
- Built with ❤️ for rural India at the Mobile App Development Hackathon 2026

---

> **Note**: The app is pre-configured with a MongoDB Atlas cloud database. No local database setup is required.