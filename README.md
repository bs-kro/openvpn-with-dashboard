A "turnkey" installation script to deploy an ultra-secure OpenVPN server paired with a real-time monitoring web interface, built specifically for **Debian 12**.

This project combines a Public Key Infrastructure (PKI) based on **Elliptic Curve (EC)** cryptography for maximum performance, and a sleek Web dashboard offering live monitoring and a **self-destructing** (*Burn-after-reading*) configuration sharing system.

---

## ✨ Key Features

* **🚀 100% Automated Installation:** A single script handles OS updates, dependencies, network routing (iptables), PKI, web server, and SSL setup.
* **🔐 Cutting-Edge Cryptography (EC):** Uses `prime256v1` instead of classic RSA for faster connections (ideal for mobile devices) and instant certificate generation.
* **⚡ Live Dashboard (AJAX):** Real-time CPU/RAM usage monitoring and a live view of connected users, refreshed every **2 seconds** without reloading the page.
* **🔥 "Burn-After-Reading" Sharing:** Transmit `.ovpn` profiles via a unique link. As soon as the end-user downloads their file, the link and the temporary file self-destruct from the server instantly.
* **🛡️ Hardened Web Security:** The interface is protected by a password (Apache Basic Auth), native Let's Encrypt integration (SSL HTTPS), anti-CSRF tokens on all forms, and private keys are stored strictly outside public web directories.
* **🚷 Single Connection Limit:** Strict enforcement preventing the same profile from being connected on two different devices simultaneously.
* **🗑️ Instant Revocation:** Delete a user in 1 click. This automatically updates the CRL (Certificate Revocation List) and immediately drops any active session for that user.

---

## 📋 Prerequisites

Before running the script, ensure you have:
1. A freshly installed **Debian 12** VPS.
2. **Root** access.
3. Ports **1194 (UDP/TCP)**, **80 (HTTP)**, and **443 (HTTPS)** open on your provider's firewall.
4. *(Optional but recommended)* A **domain name** or subdomain (e.g., `vpn.your-domain.com`) pointing to your VPS public IP to successfully generate the SSL certificate.

---

## 🛠️ Installation

Log in to your server as `root` via SSH, and run the following commands:

**1. Download the script:**
git clone https://github.com/bs-kro/openvpn-with-dashboard.git

2. Make the script executable:
Bash

cd openvpn-with-dashboard

chmod +x install.sh

3. Run the installer:
Bash

./install.sh

The setup wizard will ask you a few simple questions (IP validation, UDP/TCP protocol, web interface credentials, and domain name). Once provided, the script handles everything else in the background.
💻 Dashboard Usage Guide

Once the installation is complete, access your control panel via https://vpn.your-domain.com (or http://YOUR_IP if you bypassed the domain step).
You will be prompted to enter the credentials you chose during installation.
➕ Create a New User

    Go to the Create New User panel.

    Enter a username (no spaces, e.g., iphone_marc).

    Click Generate Profile.

    The certificate is generated almost instantly thanks to Elliptic Curve cryptography.

🔗 Share Configuration (Burn-After-Reading)

    In the user table, click on 🔗 Share Link.

    A pop-up will appear with a unique URL (e.g., https://.../share/a8b4f.../).

    Copy and send this link to the end-user.

    Important: As soon as the user clicks the link and downloads their .ovpn file, the share folder is permanently wiped from the server.

🗑️ Revoke Access

    In the user table, click 🗑 Revoke next to the user's name.

    Confirm the prompt.

    The certificate is immediately blacklisted, the .ovpn file is deleted from the server, and if the user is currently online, their VPN session is forcefully terminated.

📂 Important File Structure

If you wish to explore or modify the infrastructure manually:

    Web Dashboard: /var/www/html/

    OpenVPN Configuration: /etc/openvpn/server/server.conf

    Live Status Log (Read by UI): /var/log/openvpn/openvpn-status.log

    Secure .ovpn Storage: /etc/openvpn/clients/

    Certificate Authority (Easy-RSA): /etc/openvpn/easy-rsa/

    Management Scripts (Sudo): /usr/local/bin/ovpn-add.sh and ovpn-del.sh

⚠️ Security Warnings

    Admin Password: Do not lose the credentials you set during installation, as they protect the entire PKI management interface.

    Basic Auth over HTTP: If you choose not to use a domain name (Let's Encrypt disabled), your web credentials will be transmitted in plain text (HTTP). It is highly recommended to use a domain to enable HTTPS encryption.

🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page or submit a Pull Request.
📄 License

This project is licensed under the MIT License. You are free to use, modify, and distribute it.
