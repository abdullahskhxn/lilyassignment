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

## 📈 Project Roadmap
* [ ] Development of the Guest Mobile App UI (Flutter).
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
