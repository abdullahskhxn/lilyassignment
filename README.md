# STRATA: Decentralized Peer-to-Peer Bandwidth Sharing

**STRATA** is a decentralized platform that enables individuals and businesses to share their unused internet bandwidth with nearby users. By leveraging blockchain technology for secure micropayments and VPN tunneling for privacy, STRATA transforms ordinary routers into secure, income-generating bandwidth nodes.

---

## 🌐 Project Overview

In many modern environments, high-speed internet remains underutilized while travelers, students, and remote workers struggle with expensive or insecure public connectivity. STRATA bridges this gap by creating a secure peer-to-peer marketplace for network capacity.

### Key Features
* **Decentralized Sharing:** Securely sell excess bandwidth or buy affordable connectivity on-demand.
* **Blockchain Micropayments:** Automated, transparent transaction processing using smart contracts.
* **Privacy-First Networking:** All guest traffic is encrypted and routed through a secure **WireGuard VPN tunnel**.
* **Network Isolation:** Guest devices are isolated from the host's private network via strict firewall rules.
* **Emergency Local Chat:** A LAN-based communication channel that functions even during internet outages.
* **Low-Cost Host Nodes:** Optimized to run on accessible hardware like the **Raspberry Pi**.

---

## 🏗️ System Architecture

The STRATA ecosystem consists of three primary layers:

1.  **Guest Mobile Application:** A cross-platform app (built with Flutter) for network discovery, session management, and wallet integration.
2.  **Host Node:** A Python-based daemon running on a Raspberry Pi that manages the WiFi access point, monitors usage, and enforces connectivity rules.
3.  **Security & Payment Layer:** Uses blockchain for transaction verification and `iptables` for traffic isolation.

---

## 🔄 User Flow

Based on the STRATA system design, the application follows a streamlined process for both roles:

### For Hosts
1.  **Login/Signup:** Secure authentication via Email/Phone + OTP.
2.  **Onboarding:** Enter ISP details, SSID, and GPS location.
3.  **Setup:** Set data for sale, price per GB, and maximum concurrent users.
4.  **Dashboard:** Activate sharing and monitor real-time earnings and bandwidth usage.

### For Guests
1.  **Discovery:** Automatically scan and discover nearby STRATA networks via map or list view.
2.  **Purchase:** Select a host based on price/rating and choose a data quota.
3.  **Payment:** Initiate a micropayment via the built-in cryptocurrency wallet.
4.  **Connectivity:** Securely authenticate and access the internet through the encrypted tunnel.

---

## 🛠️ Technical Requirements

### Host Node
* **Hardware:** Raspberry Pi (or similar embedded device).
* **OS:** Linux-based with support for `hostapd` and `iptables`.
* **Networking:** WireGuard VPN for secure tunneling.

### Mobile App
* **Framework:** Flutter (iOS/Android).
* **Features:** Integrated cryptocurrency wallet and real-time session monitoring.

---

## 🚀 Running the Flutter Frontend

The `lib/` directory contains a complete dummy Flutter frontend for the STRATA app.

### Prerequisites
* Flutter SDK ≥ 3.0.0 (install from [flutter.dev](https://flutter.dev/docs/get-started/install))
* Dart SDK ≥ 3.0.0 (bundled with Flutter)
* A connected device or emulator (Android, iOS, web, or desktop)

### Quick Start
```bash
# Install dependencies
flutter pub get

# Run on your default device
flutter run

# Run on a specific device (e.g., Chrome)
flutter run -d chrome
```

### App Screens & Navigation
The app launches with a **Splash Screen** and then presents a **Role Selection** screen:

| Role | Flow |
|------|------|
| **Host** | Login/OTP → Onboarding (ISP/SSID/GPS) → Setup (price, quota, users) → Dashboard |
| **Guest** | Login/OTP → Location Permission → Nearby Hosts → Select Host → Quota → Payment → Dashboard |
| **Both** | Emergency Chatroom (LAN-based, accessible from sidebar) |

### Design
- **Colors:** Black (`#0A0A0A`) + Teal (`#00BFA5`) backgrounds, white text.
- **Sidebar:** Cursor/Gemini-style left sidebar — permanent on wide screens (>800 px), swipe Drawer on mobile.
- **State:** All data is mocked locally via `Provider`; no backend required.

---

## 📈 Project Roadmap
* [x] Development of the Guest Mobile App UI (Flutter).
* [ ] Implementation of the Host Node Daemon (Python).
* [ ] Deployment of Smart Contracts for micropayments.
* [ ] Development of a reputation system for host/guest trust.
* [ ] Conduct large-scale user trials for performance data.

---

## 👥 Contributors
* **Abdul Rehman** (221-0785)
* **Laila Tariq** (221-1574)
* **Abdullah Tahir** (211-0708)
* **Supervised by:** Mr. Shehreyar Rashid

**Institution:** National University of Computer and Emerging Sciences, Islamabad.  
**Session:** 2022-2026.

---
*Generated for the STRATA Final Year Project Prototype, June 2026.*
