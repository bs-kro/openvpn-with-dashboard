# openvpn-with-dashboard

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
