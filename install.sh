#!/bin/bash

# Avoid interruptions during updates
export DEBIAN_FRONTEND=noninteractive

if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run this script as root."
  exit 1
fi

clear
cat <<"EOF"
                                                                                                                                                                 
                                                                                                                                                                 
                                                                                                                                                                 
                                                                                                                                                                 
                                                                                                                                                                 
                                                                                                                                                                 
                                                                                ::  . :   :.    ::                                                               
                                                                                - ... .. .  : .. .    ::                                                         
                                                                                .      ..   .:    : :  ..  ::                                                    
                                                                               .                        ::   . .::                                               
                                                                               :                             -:  :  :=                                           
                                                                               .                                 ::. .                                           
                                                                               .                                     . -. .                                      
                                                                              ..                                         :                                       
                                                                              :                                         -                                        
                                                                              :                                        .                                         
                                                                             .                                        .                                          
                                                                             .                                        .                                          
                                                                             .                                       .                                           
                                                                            .                                       ..                                           
                                                                            :                                       .                                            
                                                                           ..                                       .                                            
                                                                           -              :-:.   .::.              :                                             
                                                                          .             :.           ::           ..                                             
                                                                          .           .-               = .:--.     :                                             
                                                                          .           :                 :      .-. :                                             
                                                                         -            :    .%@=         :         =                                              
                                                                        ..            :                 :         .                                              
                                                                        .             -                 :     *+   :                                             
                                                                       .              .:               -      ++   :                                             
                                                                    :::=.               :.           ::           .                                              
                                                                  .  :=.                  :::.   .:-..::.        ..                                              
                                                                  :  : ..                                  :=. .:                                                
                                                                  ..       .                                  ..                                                 
                                                                    +-. -.                                     :                                                 
                                                                   :   :  -:--                         ..     ..                                                 
                                                                  :      - .:  -.                        .:--:                                                   
                                                                :        =-    - ::                         -                                                    
                                                            -++*+-:.     .-   -    --.                     .                                                     
                                                          =**********+.    :+.    +    =:                  :                                                     
                                                   .=*******************=.   .::=.   ..   ....             :                                                     
                                                  +************************-      :-:           ::        ..                                                     
                                           .-=++*****************************=      .                   .                                                        
                                       .=**************************************= .::                                                                             
                                     +*****************************************-                                                                                 
                                   -*******************************************+.                                                                                
                                  ***#******************************************* -**-        .:-=+*************#*****************:                                                                               
                                 :+                 .+************- .+***********-                                                                               
                                 :.       ..            :+*******.     .-********:                                                                               
                                .:         =.              -****.         -******.                                                                               
                                -         =                  -*:           .#***-                                                                                
                                :        .:                   =           :****:                                                                                 
                                :        ..                  :.          .+*+-                                                                                   
                                -        ..                  :.          =** :         = s-kro.fr         -.  Bart   .**=                                                                                     
                                 :        .-                 :.         .*=                                                                                      
                                  :        .-                :.         .=                                                                                       
                                    :        -:              .:          :                                                                                       
                                      :=:.     =:             =           .                                                                                      
                                        :        .+-:..:-:     =           :                                                                                     
                                         :         :     .:    .:           ..                                                                                   
                                          :         -      :.   ::            ..                                                                                 
                                          ..         :       .   .-            .:                                                                                
                                           -         :       ..   -.            =                                                                                
                                      .---:+         :-::::::--  :=++.   .  .: ..                                                                                
                                      -::-*#.        --:::-==*+-::::-=   =  -...                                                                                 
                                      ::::::::--=-====--::::::::::-=++=++==-=.                                                                                   
                                      .==:::::::::::::::::::--=+-::::::::::* -::---:::::::::=**+=--::::::::::::-=-=                                                                                     
                                       --::::::::::::::::::::::::::--==-::=+-                                                                                    
                                      -:--=-:::::::::::::::::::-::::::::-+-::-:                                                                                  
                                      =::::::::-====----=+=+=-:::::::-+=:::::--                                                                                  
                                     =:-++-:::::::::::::::+-::::=::::::::::+-::-:                                                                                
                                      -=--::::::::::-==+===::::::::::-===-::::::::-:                                                                             
                                     .-:::::-----=:    *:+=---=+*+=-::::::::::::::::-                                                                            
                                     =::::::::::::=--=-:::--::::::::::::::::::::::::==.                                                                          
                                     =--:::::::::::::---+-.-:::::::::::::::::::::-==  :                                                                          
                                    .    .:-====-:..      -*=--:::::::::::::-=+:.   :                                                                            
                                      .:.. .        ....          ..::::..       ..                                                                              
                                                              ...      ..:-:.                                                                                    
                                                                                                                                                                 
                                                                                                                                                                 
                                                                                                                                                                 
                                                                                                                                                                 
                                                                                                                                                                 
EOF
echo ""
echo "======================================================="
echo "   AUTOMATIC OPENVPN & LIVE DASHBOARD INSTALLER        "
echo "  ULTIMATE EDITION - ELLIPTIC CURVE + BURN-AFTER-READ  "
echo "                    DEBIAN 12                          "
echo "======================================================="
echo ""

# -----------------------------------------------------
# 1. AUTO-DETECT PUBLIC IP
# -----------------------------------------------------
echo "[*] Detecting public IP address of the VPS..."
DETECTED_IP=$(curl -s ifconfig.me)
[ -z "$DETECTED_IP" ] && DETECTED_IP=$(curl -s icanhazip.com)

read -p "🌐 Public IP address of the VPS [$DETECTED_IP]: " SERVER_IP
[ -z "$SERVER_IP" ] && SERVER_IP="$DETECTED_IP"

if [ -z "$SERVER_IP" ]; then
  echo "❌ Failed to detect or validate the IP. Script aborted."
  exit 1
fi

# -----------------------------------------------------
# 2. COLLECT OTHER INFORMATION
# -----------------------------------------------------
while true; do
    read -p "🔌 Desired protocol (UDP or TCP) [UDP]: " VPN_PROTO
    VPN_PROTO=$(echo "$VPN_PROTO" | tr '[:lower:]' '[:upper:]')
    [ -z "$VPN_PROTO" ] && VPN_PROTO="UDP"
    if [ "$VPN_PROTO" = "UDP" ] || [ "$VPN_PROTO" = "TCP" ]; then break; fi
    echo "Please choose UDP or TCP."
done

read -p "👤 Web Interface Administrator Username: " WEB_USER
if [ -z "$WEB_USER" ]; then echo "Username is required."; exit 1; fi

read -s -p "🔑 Web Interface Password: " WEB_PASS
echo ""
if [ -z "$WEB_PASS" ]; then echo "Password is required."; exit 1; fi

HAS_DOMAIN="n"
read -p "🏠 Do you have a domain name for this VPS? (y/N): " DOMAIN_CHOICE
if [[ "$DOMAIN_CHOICE" =~ ^[yY]$ ]]; then
  HAS_DOMAIN="y"
  read -p "   Enter your domain name (e.g., vpn.domain.com): " DOMAIN_NAME
  if [ -z "$DOMAIN_NAME" ]; then echo "Domain name cannot be empty."; exit 1; fi
fi

# -----------------------------------------------------
# 3. GLOBAL OS UPDATE & DEPENDENCIES
# -----------------------------------------------------
echo ""
echo "[*] 🔄 Updating OS and installing packages..."
apt-get update -y
apt-get -o Dpkg::Options::="--force-confold" upgrade -y
apt-get install -y openvpn easy-rsa apache2 php libapache2-mod-php sudo iptables iproute2 apache2-utils snapd curl

# -----------------------------------------------------
# 4. SECURE WEB INTERFACE & ONE-TIME SHARE DIR
# -----------------------------------------------------
echo "[*] 🔒 Securing access and creating Share directory..."
htpasswd -b -c /etc/apache2/.htpasswd "$WEB_USER" "$WEB_PASS"

# Create public share directory with proper permissions
mkdir -p /var/www/html/share
chown -R www-data:www-data /var/www/html/share

cat <<EOF > /etc/apache2/conf-available/openvpn-admin.conf
<Directory "/var/www/html">
    AuthType Basic
    AuthName "Restricted OpenVPN Administration"
    AuthUserFile /etc/apache2/.htpasswd
    Require valid-user
    Options -Indexes +FollowSymLinks
    AllowOverride None
</Directory>

# Exception: The share folder must be public for the end-user download link
<Directory "/var/www/html/share">
    Require all granted
    Options -Indexes
</Directory>
EOF
a2enconf openvpn-admin

# -----------------------------------------------------
# 5. LET'S ENCRYPT (SSL)
# -----------------------------------------------------
VPN_REMOTE_SERVER="$SERVER_IP"
if [ "$HAS_DOMAIN" = "y" ]; then
  echo "[*] 🛡️ Configuring Let's Encrypt SSL..."
  snap install core; snap refresh core
  snap install --classic certbot
  ln -sf /snap/bin/certbot /usr/bin/certbot
  certbot --apache -d "$DOMAIN_NAME" --non-interactive --agree-tos --register-unsafely-without-email
  VPN_REMOTE_SERVER="$DOMAIN_NAME"
fi

# -----------------------------------------------------
# 6. OPENVPN & EASY-RSA (ELLIPTIC CURVE CRYPTOGRAPHY)
# -----------------------------------------------------
echo "[*] 🔑 Configuring PKI with Elliptic Curve (Super Fast & Secure)..."
rm -rf /etc/openvpn/easy-rsa
make-cadir /etc/openvpn/easy-rsa
cd /etc/openvpn/easy-rsa

cat <<EOF > vars
set_var EASYRSA_ALGO "ec"
set_var EASYRSA_CURVE "prime256v1"
EOF

export EASYRSA_BATCH=1
./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa gen-req server nopass
./easyrsa sign-req server server
openvpn --genkey secret ta.key

cp pki/ca.crt pki/issued/server.crt pki/private/server.key ta.key /etc/openvpn/server/

echo "[*] ⚙️ Generating OpenVPN configuration..."
VPN_PROTO_LOWER=$(echo "$VPN_PROTO" | tr '[:upper:]' '[:lower:]')

cat <<EOF > /etc/openvpn/server/server.conf
port 1194
proto $VPN_PROTO_LOWER
dev tun
ca ca.crt
cert server.crt
key server.key
dh none
tls-auth ta.key 0
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
cipher AES-256-GCM
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn/openvpn-status.log 10
verb 3
explicit-exit-notify 1
crl-verify /etc/openvpn/server/crl.pem
EOF

mkdir -p /var/log/openvpn
touch /var/log/openvpn/openvpn-status.log
chown nobody:www-data /var/log/openvpn
chmod 644 /var/log/openvpn/openvpn-status.log

./easyrsa gen-crl
cp pki/crl.pem /etc/openvpn/server/crl.pem

# -----------------------------------------------------
# 7. NETWORK ROUTING CONFIGURATION
# -----------------------------------------------------
echo "[*] 🌐 Configuring network routing..."
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-openvpn.conf
sysctl -p /etc/sysctl.d/99-openvpn.conf

NIC=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o $NIC -j MASQUERADE
apt-get install -y iptables-persistent
iptables-save > /etc/iptables/rules.v4

# -----------------------------------------------------
# 8. SECURE BACKEND SCRIPTS
# -----------------------------------------------------
echo "[*] 🛠️ Creating management scripts..."
mkdir -p /etc/openvpn/clients
chown -R www-data:www-data /etc/openvpn/clients

cat <<'EOF' > /usr/local/bin/ovpn-add.sh
#!/bin/bash
cd /etc/openvpn/easy-rsa
export EASYRSA_BATCH=1
./easyrsa build-client-full $1 nopass
cat <<CONFIG > /etc/openvpn/clients/$1.ovpn
client
dev tun
proto PROTO_PLACEHOLDER
remote REMOTE_SERVER_PLACEHOLDER 1194
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-GCM
key-direction 1
verb 3
<ca>
$(cat /etc/openvpn/easy-rsa/pki/ca.crt)
</ca>
<cert>
$(cat /etc/openvpn/easy-rsa/pki/issued/$1.crt)
</cert>
<key>
$(cat /etc/openvpn/easy-rsa/pki/private/$1.key)
</key>
<tls-auth>
$(cat /etc/openvpn/easy-rsa/ta.key)
</tls-auth>
CONFIG
EOF
sed -i "s/REMOTE_SERVER_PLACEHOLDER/$VPN_REMOTE_SERVER/g" /usr/local/bin/ovpn-add.sh
sed -i "s/PROTO_PLACEHOLDER/$VPN_PROTO_LOWER/g" /usr/local/bin/ovpn-add.sh
chmod +x /usr/local/bin/ovpn-add.sh

cat <<'EOF' > /usr/local/bin/ovpn-del.sh
#!/bin/bash
cd /etc/openvpn/easy-rsa
export EASYRSA_BATCH=1
./easyrsa revoke $1
./easyrsa gen-crl
cp pki/crl.pem /etc/openvpn/server/crl.pem
rm -f /etc/openvpn/clients/$1.ovpn
systemctl restart openvpn-server@server.service
EOF
chmod +x /usr/local/bin/ovpn-del.sh

echo "www-data ALL=(ALL) NOPASSWD: /usr/local/bin/ovpn-add.sh, /usr/local/bin/ovpn-del.sh" > /etc/sudoers.d/ovpn-web

# -----------------------------------------------------
# 9. LIVE DASHBOARD DEPLOYMENT
# -----------------------------------------------------
echo "[*] 💻 Deploying the Dashboard..."

# --- AJAX Backend File (live_status.php) ---
cat <<'EOF' > /var/www/html/live_status.php
<?php
header('Content-Type: application/json');

$free = shell_exec('free');
$mem = explode(" ", preg_replace('/\s+/', ' ', explode("\n", trim($free))[1]));
$ram_percent = count($mem) >= 3 ? round(($mem[2] / $mem[1]) * 100) : 0;

$load = sys_getloadavg();
$core_count = intval(trim(shell_exec("nproc")));
$cpu_percent = round(($load[0] / $core_count) * 100);
if ($cpu_percent > 100) $cpu_percent = 100;

$status_file = '/var/log/openvpn/openvpn-status.log';
$online_users = [];

if (file_exists($status_file)) {
    $lines = file($status_file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        if (strpos($line, 'CLIENT_LIST,') === 0) {
            $parts = explode(',', $line);
            if (count($parts) >= 8) {
                $username = trim($parts[1]);
                $real_ip = explode(':', trim($parts[2]))[0];
                $time_connected = explode(' ', trim($parts[7]))[1] ?? trim($parts[7]);

                $online_users[$username] = [
                    'real_ip' => $real_ip,
                    'since' => $time_connected
                ];
            }
        }
    }
}
echo json_encode(['cpu' => $cpu_percent, 'ram' => $ram_percent, 'online' => $online_users]);
EOF

# --- Frontend File (index.php) ---
cat <<'EOF' > /var/www/html/index.php
<?php
session_start();
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

// BURN-AFTER-READ: Function to create a self-destructing link
function createShareLink($user) {
    $token = bin2hex(random_bytes(16));
    $dir = "/var/www/html/share/" . $token;
    mkdir($dir, 0755, true);
    
    // The self-destructing wrapper script
    $php_code = "<?php\n"
              . "\$f = '/etc/openvpn/clients/" . addslashes($user) . ".ovpn';\n"
              . "register_shutdown_function(function() { @unlink(__FILE__); @rmdir(__DIR__); });\n"
              . "if(file_exists(\$f)){\n"
              . "header('Content-Type: application/x-openvpn-profile');\n"
              . "header('Content-Disposition: attachment; filename=\"" . addslashes($user) . ".ovpn\"');\n"
              . "header('Content-Length: ' . filesize(\$f));\n"
              . "readfile(\$f);\n"
              . "} else { echo 'Profile not found or already deleted.'; }\n";
              
    file_put_contents($dir . "/index.php", $php_code);
    return $token;
}

// Secure internal direct download for admin
if (isset($_GET['download'])) {
    $dl_user = preg_replace('/[^a-zA-Z0-9_-]/', '', $_GET['download']);
    $file_path = "/etc/openvpn/clients/" . $dl_user . ".ovpn";
    if (file_exists($file_path)) {
        header('Content-Type: application/x-openvpn-profile');
        header('Content-Disposition: attachment; filename="' . $dl_user . ".ovpn\"");
        readfile($file_path);
        exit;
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!isset($_POST['csrf_token']) || !hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
        die("Security error: Invalid CSRF token.");
    }
    
    $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http";
    $base_url = $protocol . "://" . $_SERVER['HTTP_HOST'];

    if (isset($_POST['add_user']) && !empty($_POST['username'])) {
        $user = preg_replace('/[^a-zA-Z0-9_-]/', '', $_POST['username']);
        if (!empty($user)) {
            shell_exec("sudo /usr/local/bin/ovpn-add.sh " . escapeshellarg($user));
            $token = createShareLink($user);
            $_SESSION['share_link'] = $base_url . "/share/" . $token . "/";
        }
    } elseif (isset($_POST['share_user']) && !empty($_POST['username'])) {
        $user = preg_replace('/[^a-zA-Z0-9_-]/', '', $_POST['username']);
        if (!empty($user)) {
            $token = createShareLink($user);
            $_SESSION['share_link'] = $base_url . "/share/" . $token . "/";
        }
    } elseif (isset($_POST['del_user']) && !empty($_POST['username'])) {
        $user = preg_replace('/[^a-zA-Z0-9_-]/', '', $_POST['username']);
        if (!empty($user)) shell_exec("sudo /usr/local/bin/ovpn-del.sh " . escapeshellarg($user));
    }
    header("Location: " . $_SERVER['PHP_SELF']);
    exit;
}

$all_users = [];
foreach (glob("/etc/openvpn/clients/*.ovpn") as $file) {
    $all_users[] = basename($file, '.ovpn');
}
sort($all_users, SORT_NATURAL | SORT_FLAG_CASE);
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>OpenVPN — Control Panel</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;600;700;800&display=swap" rel="stylesheet">
<style>
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
:root { --ink: #0a0e1a; --ink2: #111827; --ink3: #1c2333; --surface: #161d2e; --border: rgba(255,255,255,.07); --border2: rgba(255,255,255,.12); --text: #e8edf5; --muted: #6b7a99; --muted2: #4a5568; --green: #00e5a0; --green-dim: rgba(0,229,160,.08); --green-glow:rgba(0,229,160,.25); --red: #ff4d6d; --red-dim: rgba(255,77,109,.08); --amber: #ffb347; --blue: #4d9fff; --blue-dim: rgba(77,159,255,.1); --cyan: #00d4ff; --mono: 'Space Mono', monospace; --sans: 'Syne', sans-serif; }
html { scroll-behavior: smooth; }
body { font-family: var(--sans); background: var(--ink); color: var(--text); min-height: 100vh; overflow-x: hidden; }
body::before { content: ''; position: fixed; inset: 0; z-index: 0; background-image: linear-gradient(rgba(0,229,160,.03) 1px, transparent 1px), linear-gradient(90deg, rgba(0,229,160,.03) 1px, transparent 1px); background-size: 40px 40px; pointer-events: none; }
.blob { position: fixed; border-radius: 50%; filter: blur(120px); pointer-events: none; z-index: 0; }
.blob-1 { width: 500px; height: 500px; background: rgba(0,229,160,.06); top: -100px; right: -100px; }
.blob-2 { width: 400px; height: 400px; background: rgba(77,159,255,.05); bottom: -80px; left: -80px; }
.shell { position: relative; z-index: 1; max-width: 1280px; margin: 0 auto; padding: 0 2rem 4rem; }
header { display: flex; align-items: center; justify-content: space-between; padding: 1.75rem 0 1.5rem; border-bottom: 1px solid var(--border); margin-bottom: 2rem; }
.logo { display: flex; align-items: center; gap: 14px; }
.logo-mark { width: 44px; height: 44px; border-radius: 10px; background: linear-gradient(135deg, #00e5a0, #00b8d9); display: flex; align-items: center; justify-content: center; font-size: 20px; flex-shrink: 0; box-shadow: 0 0 20px var(--green-glow); }
.logo-text h1 { font-family: var(--sans); font-size: 18px; font-weight: 800; letter-spacing: -.3px; line-height: 1; }
.logo-text p { font-family: var(--mono); font-size: 10px; color: var(--muted); margin-top: 3px; letter-spacing: .5px; }
.header-right { display: flex; align-items: center; gap: 20px; }
.live-pill { display: flex; align-items: center; gap: 7px; background: var(--green-dim); border: 1px solid rgba(0,229,160,.2); border-radius: 999px; padding: 6px 14px; font-family: var(--mono); font-size: 11px; font-weight: 700; color: var(--green); letter-spacing: .5px; }
.pulse-dot { width: 7px; height: 7px; border-radius: 50%; background: var(--green); animation: pulse 2s ease-in-out infinite; }
@keyframes pulse { 0%,100%{opacity:1;transform:scale(1)} 50%{opacity:.4;transform:scale(.8)} }
.server-ip { font-family: var(--mono); font-size: 11px; color: var(--muted); }
.stats-row { display: grid; grid-template-columns: repeat(5, 1fr); gap: 12px; margin-bottom: 1.75rem; }
.stat-card { background: var(--surface); border: 1px solid var(--border); border-radius: 12px; padding: 18px 20px; position: relative; overflow: hidden; transition: border-color .2s, transform .2s; }
.stat-card:hover { border-color: var(--border2); transform: translateY(-1px); }
.stat-card::after { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 2px; border-radius: 12px 12px 0 0; }
.stat-card.green::after { background: linear-gradient(90deg, var(--green), transparent); }
.stat-card.blue::after  { background: linear-gradient(90deg, var(--blue), transparent); }
.stat-card.red::after   { background: linear-gradient(90deg, var(--red), transparent); }
.stat-card.amber::after { background: linear-gradient(90deg, var(--amber), transparent); }
.stat-card.cyan::after  { background: linear-gradient(90deg, var(--cyan), transparent); }
.stat-label { font-family: var(--mono); font-size: 9px; font-weight: 700; text-transform: uppercase; letter-spacing: 1.2px; color: var(--muted); margin-bottom: 8px; }
.stat-val { font-family: var(--mono); font-size: 28px; font-weight: 700; line-height: 1; }
.stat-card.green .stat-val { color: var(--green); } .stat-card.blue .stat-val { color: var(--blue); } .stat-card.red .stat-val { color: var(--red); } .stat-card.amber .stat-val { color: var(--amber); } .stat-card.cyan .stat-val { color: var(--cyan); }
.stat-sub { font-family: var(--mono); font-size: 10px; color: var(--muted); margin-top: 6px; }
.resources { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 1.75rem; }
.resource-card { background: var(--surface); border: 1px solid var(--border); border-radius: 12px; padding: 20px 24px; }
.resource-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
.resource-name { font-family: var(--mono); font-size: 10px; font-weight: 700; letter-spacing: 1.2px; text-transform: uppercase; color: var(--muted); }
.resource-pct { font-family: var(--mono); font-size: 20px; font-weight: 700; }
.resource-pct.cpu { color: var(--cyan); } .resource-pct.ram { color: var(--blue); }
.bar-track { background: var(--ink3); border-radius: 4px; height: 8px; overflow: hidden; }
.bar-fill { height: 100%; border-radius: 4px; transition: width .6s cubic-bezier(.4,0,.2,1); }
.bar-fill.cpu { background: linear-gradient(90deg, #00d4ff, #a855f7); } .bar-fill.ram { background: linear-gradient(90deg, #4d9fff, #ec4899); }
.bar-ticks { display: flex; justify-content: space-between; margin-top: 6px; font-family: var(--mono); font-size: 9px; color: var(--muted2); }
.main-grid { display: grid; grid-template-columns: 340px 1fr; gap: 20px; }
.panel { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; overflow: hidden; }
.panel-header { display: flex; align-items: center; justify-content: space-between; padding: 16px 22px; border-bottom: 1px solid var(--border); background: rgba(255,255,255,.02); flex-wrap: wrap; gap: 10px; }
.panel-title { font-family: var(--sans); font-size: 13px; font-weight: 700; letter-spacing: -.2px; }
.panel-badge { font-family: var(--mono); font-size: 10px; color: var(--muted); background: var(--ink3); padding: 3px 9px; border-radius: 6px; }
.panel-body { padding: 22px; }
.field-label { font-family: var(--mono); font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; color: var(--muted); margin-bottom: 8px; display: block; }
.input-wrap { position: relative; margin-bottom: 14px; }
input[type="text"] { width: 100%; padding: 11px 14px; background: var(--ink3); border: 1px solid var(--border2); border-radius: 9px; color: var(--text); font-family: var(--mono); font-size: 13px; outline: none; transition: border-color .2s, box-shadow .2s; appearance: none; }
input[type="text"]:focus { border-color: var(--green); box-shadow: 0 0 0 3px var(--green-glow); }
input[type="text"]::placeholder { color: var(--muted2); }
.search-bar { background: var(--ink); margin-bottom: 0; border-radius: 8px; border: 1px solid var(--border); padding: 8px 12px; width: 250px; }
.btn-create { width: 100%; padding: 12px; background: linear-gradient(135deg, #00e5a0, #00b8d9); border: none; border-radius: 9px; color: var(--ink); font-family: var(--sans); font-size: 13px; font-weight: 800; letter-spacing: .3px; cursor: pointer; transition: opacity .15s, transform .15s, box-shadow .15s; display: flex; align-items: center; justify-content: center; gap: 8px; }
.btn-create:hover { opacity: .9; transform: translateY(-1px); box-shadow: 0 4px 20px var(--green-glow); }
.btn-create:active { transform: translateY(0); }
.notice { background: var(--green-dim); border: 1px solid rgba(0,229,160,.15); border-radius: 9px; padding: 13px 15px; margin-top: 16px; font-family: var(--mono); font-size: 11px; color: var(--green); line-height: 1.5; }
.notice strong { display: block; margin-bottom: 4px; font-size: 10px; letter-spacing: .5px; }
.user-table-wrap { overflow-x: auto; max-height: 500px; overflow-y: auto; }
table { width: 100%; border-collapse: collapse; }
thead th { position: sticky; top: 0; background: var(--surface); z-index: 10; font-family: var(--mono); font-size: 9px; font-weight: 700; text-transform: uppercase; letter-spacing: 1.2px; color: var(--muted); padding: 12px 16px; text-align: left; border-bottom: 1px solid var(--border); }
tbody tr { transition: background .15s; animation: row-in .25s ease both; }
tbody tr:hover { background: rgba(255,255,255,.025); }
@keyframes row-in { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: translateY(0); } }
td { padding: 14px 16px; font-size: 13px; border-bottom: 1px solid var(--border); vertical-align: middle; }
tbody tr:last-child td { border-bottom: none; }
.user-avatar { width: 34px; height: 34px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-family: var(--mono); font-size: 12px; font-weight: 700; flex-shrink: 0; }
.user-name-cell { display: flex; align-items: center; gap: 11px; }
.user-name { font-weight: 700; font-size: 13px; }
.user-sub { font-family: var(--mono); font-size: 10px; color: var(--muted); margin-top: 1px; }
.badge { display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border-radius: 999px; font-family: var(--mono); font-size: 11px; font-weight: 700; }
.badge.online { background: var(--green-dim); color: var(--green); border: 1px solid rgba(0,229,160,.2); }
.badge.offline { background: rgba(107,122,153,.08); color: var(--muted); border: 1px solid rgba(107,122,153,.15); }
.badge .dot { width: 5px; height: 5px; border-radius: 50%; background: currentColor; }
.badge.online .dot { animation: pulse 2s infinite; }
.details-chip { font-family: var(--mono); font-size: 11px; color: var(--muted2); line-height: 1.6; }
.details-chip span { color: var(--muted); }
.action-group { display: flex; align-items: center; gap: 8px; }
.btn-dl { display: inline-flex; align-items: center; gap: 6px; background: var(--blue-dim); border: 1px solid rgba(77,159,255,.25); color: var(--blue); font-family: var(--mono); font-size: 11px; font-weight: 700; padding: 6px 12px; border-radius: 7px; text-decoration: none; cursor: pointer; transition: background .15s, border-color .15s, transform .1s; white-space: nowrap; }
.btn-dl:hover { background: rgba(77,159,255,.18); border-color: rgba(77,159,255,.4); transform: translateY(-1px); }

/* Modal Styles */
.modal-overlay { position: fixed; inset: 0; background: rgba(10,14,26,0.85); backdrop-filter: blur(5px); z-index: 9999; display: flex; align-items: center; justify-content: center; animation: fade-in 0.2s ease; }
.modal-card { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; padding: 30px; max-width: 450px; width: 100%; text-align: center; box-shadow: 0 20px 40px rgba(0,0,0,0.5); transform: translateY(0); animation: slide-up 0.3s ease; }
.modal-title { font-family: var(--sans); font-size: 18px; font-weight: 700; color: var(--text); margin-bottom: 10px; }
.modal-desc { font-family: var(--mono); font-size: 12px; color: var(--muted); margin-bottom: 20px; line-height: 1.5; }
.modal-input { width: 100%; padding: 12px; background: var(--ink); border: 1px solid var(--border2); border-radius: 8px; color: var(--green); font-family: var(--mono); font-size: 13px; text-align: center; margin-bottom: 15px; }
.btn-copy { width: 100%; padding: 12px; background: var(--blue-dim); border: 1px solid rgba(77,159,255,.25); border-radius: 8px; color: var(--blue); font-family: var(--sans); font-weight: 700; cursor: pointer; transition: all 0.2s; margin-bottom: 10px; }
.btn-copy:hover { background: rgba(77,159,255,.2); }
.btn-close { background: transparent; border: none; color: var(--muted); font-family: var(--mono); font-size: 11px; cursor: pointer; }
.btn-close:hover { color: var(--text); }
@keyframes fade-in { from { opacity: 0; } to { opacity: 1; } }
@keyframes slide-up { from { transform: translateY(20px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

.btn-share { display: inline-flex; align-items: center; gap: 6px; background: var(--green-dim); border: 1px solid rgba(0,229,160,.2); color: var(--green); font-family: var(--mono); font-size: 11px; font-weight: 700; padding: 6px 12px; border-radius: 7px; cursor: pointer; transition: background .15s, border-color .15s, transform .1s; white-space: nowrap; }
.btn-share:hover { background: rgba(0,229,160,.15); border-color: rgba(0,229,160,.4); transform: translateY(-1px); }
.btn-del-form button { display: inline-flex; align-items: center; gap: 6px; background: var(--red-dim); border: 1px solid rgba(255,77,109,.2); color: var(--red); font-family: var(--mono); font-size: 11px; font-weight: 700; padding: 6px 12px; border-radius: 7px; cursor: pointer; transition: background .15s, border-color .15s, transform .1s; white-space: nowrap; }
.btn-del-form button:hover { background: rgba(255,77,109,.18); border-color: rgba(255,77,109,.4); transform: translateY(-1px); }
.empty-row td { text-align: center; padding: 3.5rem; color: var(--muted); font-family: var(--mono); font-size: 13px; }
.empty-icon { font-size: 32px; display: block; margin-bottom: 8px; opacity: .5; }
.log-section { margin-top: 20px; }
.log-panel { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; overflow: hidden; }
.log-body { padding: 14px 22px; max-height: 120px; overflow-y: auto; display: flex; flex-direction: column; gap: 3px; }
.log-entry { display: flex; gap: 16px; align-items: baseline; font-family: var(--mono); font-size: 11px; padding: 2px 0; }
.log-time { color: var(--muted2); flex-shrink: 0; }
.log-ok { color: var(--green); } .log-info { color: var(--blue); } .log-warn { color: var(--amber); } .log-err { color: var(--red); }
::-webkit-scrollbar { width: 4px; height: 4px; } ::-webkit-scrollbar-track { background: transparent; } ::-webkit-scrollbar-thumb { background: var(--border2); border-radius: 4px; }
@media (max-width: 1100px) { .main-grid { grid-template-columns: 1fr; } }
@media (max-width: 768px)  { .stats-row { grid-template-columns: repeat(2, 1fr); } .resources { grid-template-columns: 1fr; } }
</style>
</head>
<body>

<?php if (!empty($_SESSION['share_link'])): ?>
<div class="modal-overlay" id="share-modal">
  <div class="modal-card">
    <div class="modal-title">🎉 Profile Generated!</div>
    <div class="modal-desc">Send this link to the user. It will <strong>self-destruct</strong> immediately after the first download.</div>
    <input type="text" id="share-url" class="modal-input" value="<?= htmlspecialchars($_SESSION['share_link']) ?>" readonly>
    <button class="btn-copy" onclick="navigator.clipboard.writeText(document.getElementById('share-url').value); this.innerText='✅ Link Copied!';">📋 Copy Link</button>
    <button class="btn-close" onclick="document.getElementById('share-modal').style.display='none';">Close</button>
  </div>
</div>
<?php unset($_SESSION['share_link']); endif; ?>

<div class="blob blob-1"></div>
<div class="blob blob-2"></div>
<div class="shell">
<header>
  <div class="logo">
    <div class="logo-mark">🛡</div>
    <div class="logo-text">
      <h1>OpenVPN Control Panel</h1>
      <p>ADMINISTRATION INTERFACE — DEBIAN 12</p>
    </div>
  </div>
  <div class="header-right">
    <span class="server-ip" id="server-time">—</span>
    <div class="live-pill">
      <div class="pulse-dot"></div>
      LIVE · 2s
    </div>
  </div>
</header>
<div class="stats-row">
  <div class="stat-card cyan">
    <div class="stat-label">CPU Load</div>
    <div class="stat-val" id="s-cpu">—</div>
    <div class="stat-sub" id="s-cpu-sub">waiting...</div>
  </div>
  <div class="stat-card blue">
    <div class="stat-label">RAM Usage</div>
    <div class="stat-val" id="s-ram">—</div>
    <div class="stat-sub" id="s-ram-sub">waiting...</div>
  </div>
  <div class="stat-card green">
    <div class="stat-label">Online VPN</div>
    <div class="stat-val" id="s-online">0</div>
    <div class="stat-sub">active sessions</div>
  </div>
  <div class="stat-card red">
    <div class="stat-label">Offline</div>
    <div class="stat-val" id="s-offline"><?= count($all_users) ?></div>
    <div class="stat-sub">accounts</div>
  </div>
  <div class="stat-card amber">
    <div class="stat-label">Total Accounts</div>
    <div class="stat-val" id="s-total-accounts"><?= count($all_users) ?></div>
    <div class="stat-sub">certificates</div>
  </div>
</div>
<div class="resources">
  <div class="resource-card">
    <div class="resource-header">
      <span class="resource-name">CPU — Processor</span>
      <span class="resource-pct cpu" id="cpu-pct">0%</span>
    </div>
    <div class="bar-track">
      <div class="bar-fill cpu" id="cpu-bar" style="width:0%"></div>
    </div>
    <div class="bar-ticks"><span>0%</span><span>25%</span><span>50%</span><span>75%</span><span>100%</span></div>
  </div>
  <div class="resource-card">
    <div class="resource-header">
      <span class="resource-name">RAM — Memory</span>
      <span class="resource-pct ram" id="ram-pct">0%</span>
    </div>
    <div class="bar-track">
      <div class="bar-fill ram" id="ram-bar" style="width:0%"></div>
    </div>
    <div class="bar-ticks"><span>0%</span><span>25%</span><span>50%</span><span>75%</span><span>100%</span></div>
  </div>
</div>
<div class="main-grid">
  <div class="panel">
    <div class="panel-header">
      <span class="panel-title">Create New User</span>
      <span class="panel-badge">EASY-RSA PKI</span>
    </div>
    <div class="panel-body">
      <form method="POST" id="add-form" onsubmit="return handleAdd(event)">
        <input type="hidden" name="csrf_token" value="<?= $_SESSION['csrf_token'] ?>">
        <label class="field-label" for="uname">Username</label>
        <div class="input-wrap">
          <input type="text" id="uname" name="username" placeholder="e.g. alice, office_pc" pattern="[a-zA-Z0-9_-]+" required autocomplete="off" autocapitalize="none" />
        </div>
        <button type="submit" name="add_user" class="btn-create" id="btn-create">
          <span>⊕</span> Generate Profile
        </button>
      </form>
      <div class="notice">
        <strong>HOW IT WORKS</strong>
        Creates a unique certificate, then generates a secure <strong>self-destructing link</strong> to share with the end-user.
      </div>
    </div>
  </div>
  <div class="panel">
    <div class="panel-header">
      <span class="panel-title">Users & Active Sessions</span>
      <input type="text" id="search-input" class="search-bar" placeholder="🔍 Search user..." onkeyup="filterUsers()">
    </div>
    <div class="panel-body" style="padding:0">
      <div class="user-table-wrap">
        <table>
          <thead>
            <tr>
              <th>Status</th>
              <th>User</th>
              <th>Session Info</th>
              <th>Config</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody id="user-tbody">
            <?php if (empty($all_users)): ?>
            <tr class="empty-row" id="empty-msg">
              <td colspan="5"><span class="empty-icon">👤</span>No users yet — create one to get started.</td>
            </tr>
            <?php else: ?>
            <?php
            $avatarBg = ['#0d2a1f','#0c1e2e','#2a1a0d','#2a0d1a','#1a2a0d','#1a0d2a','#1a1a2a'];
            $avatarFg = ['#00e5a0','#4d9fff','#ffb347','#ff6b9d','#a3e635','#c084fc','#60a5fa'];
            foreach ($all_users as $idx => $user):
              $bi = $idx % count($avatarBg);
              $ini = strtoupper(substr($user, 0, 2));
            ?>
            <tr data-username="<?= htmlspecialchars($user) ?>" class="user-row">
              <td><span class="badge offline" id="badge-<?= htmlspecialchars($user) ?>"><span class="dot"></span>Offline</span></td>
              <td>
                <div class="user-name-cell">
                  <div class="user-avatar" style="background:<?= $avatarBg[$bi] ?>;color:<?= $avatarFg[$bi] ?>"><?= $ini ?></div>
                  <div><div class="user-name"><?= htmlspecialchars($user) ?></div><div class="user-sub">PKI certified</div></div>
                </div>
              </td>
              <td><div class="details-chip" id="info-<?= htmlspecialchars($user) ?>">—</div></td>
              <td>
                <form method="POST" style="display:inline;">
                  <input type="hidden" name="csrf_token" value="<?= $_SESSION['csrf_token'] ?>">
                  <input type="hidden" name="username" value="<?= htmlspecialchars($user) ?>">
                  <button type="submit" name="share_user" class="btn-share" title="Generate one-time download link">🔗 Share Link</button>
                </form>
                <a href="?download=<?= htmlspecialchars($user) ?>" class="btn-dl" title="Direct download for Admin">⬇</a>
              </td>
              <td>
                <div class="action-group">
                  <form class="btn-del-form" method="POST" onsubmit="return confirm('Permanently revoke access for «<?= htmlspecialchars($user) ?>»?')">
                    <input type="hidden" name="csrf_token" value="<?= $_SESSION['csrf_token'] ?>">
                    <input type="hidden" name="username" value="<?= htmlspecialchars($user) ?>">
                    <button type="submit" name="del_user">🗑 Revoke</button>
                  </form>
                </div>
              </td>
            </tr>
            <?php endforeach; ?>
            <?php endif; ?>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
<div class="log-section">
  <div class="log-panel">
    <div class="panel-header"><span class="panel-title">Activity Log</span><span class="panel-badge" id="log-count">0 events</span></div>
    <div class="log-body" id="log-body">
      <div class="log-entry"><span class="log-time">--:--:--</span><span class="log-info">Dashboard initialized — waiting for live data...</span></div>
    </div>
  </div>
</div>
</div>
<script>
let logEntries = [];
let logCount = 0;
let prevOnline = {};

function ts() { return new Date().toTimeString().slice(0,8); }
function addLog(cls, msg) { logEntries.unshift({ t: ts(), cls, msg }); if (logEntries.length > 50) logEntries.pop(); logCount++; renderLog(); }
function renderLog() { const el = document.getElementById('log-body'); el.innerHTML = logEntries.map(e => `<div class="log-entry"><span class="log-time">${e.t}</span><span class="${e.cls}">${e.msg}</span></div>`).join(''); document.getElementById('log-count').textContent = logCount + ' events'; }
function clamp(v) { return Math.min(100, Math.max(0, v)); }
function setBar(barId, pctId, val) { document.getElementById(barId).style.width = clamp(val) + '%'; document.getElementById(pctId).textContent  = clamp(val) + '%'; }
function filterUsers() {
    let input = document.getElementById('search-input').value.toLowerCase();
    document.querySelectorAll('.user-row').forEach(row => {
        let username = row.getAttribute('data-username').toLowerCase();
        row.style.display = username.includes(input) ? "" : "none";
    });
}
function updateLive() {
  fetch('live_status.php').then(r => r.json()).then(data => {
      const cpu = data.cpu || 0; const ram = data.ram || 0;
      setBar('cpu-bar', 'cpu-pct', cpu); setBar('ram-bar', 'ram-pct', ram);
      document.getElementById('s-cpu').textContent = cpu + '%'; document.getElementById('s-ram').textContent = ram + '%';
      document.getElementById('s-cpu-sub').textContent = cpu > 80 ? 'high load' : cpu > 40 ? 'normal' : 'idle';
      document.getElementById('s-ram-sub').textContent = ram > 80 ? 'memory pressure' : 'available';

      const online = data.online || {}; let onlineCount = 0; let totalRows = 0;
      document.querySelectorAll('#user-tbody tr[data-username]').forEach(row => {
        const user = row.getAttribute('data-username'); const badge = document.getElementById('badge-' + user); const info  = document.getElementById('info-' + user);
        totalRows++;
        if (online[user]) {
          onlineCount++;
          badge.className = 'badge online'; badge.innerHTML = '<span class="dot"></span>Online';
          info.innerHTML = `<span>IP</span> ${online[user].real_ip}<br><span>Since</span> ${online[user].since}`;
          if (!prevOnline[user]) addLog('log-ok', `${user} connected — ${online[user].real_ip}`);
        } else {
          badge.className = 'badge offline'; badge.innerHTML = '<span class="dot"></span>Offline'; info.innerHTML = '—';
          if (prevOnline[user]) addLog('log-warn', `${user} disconnected`);
        }
      });
      if (cpu > 85) addLog('log-warn', `CPU spike detected: ${cpu}%`);
      prevOnline = JSON.parse(JSON.stringify(online));
      document.getElementById('s-online').textContent  = onlineCount;
      document.getElementById('s-offline').textContent = totalRows - onlineCount;
    }).catch(e => console.error('Live update failed:', e.message));
  document.getElementById('server-time').textContent = new Date().toLocaleTimeString('en-GB');
}
function handleAdd(e) { const btn = document.getElementById('btn-create'); btn.textContent = '⏳ Generating...'; btn.style.opacity = '0.7'; return true; }
setInterval(updateLive, 2000); updateLive(); addLog('log-info', 'Dashboard loaded — live monitoring active');
</script>
</body>
</html>
EOF

# Restart services
rm -f /var/www/html/index.html
systemctl restart apache2
systemctl enable openvpn-server@server.service
systemctl restart openvpn-server@server.service

clear
echo "======================================================="
echo " 🎉 INSTALLATION AND CONFIGURATION SUCCESSFUL!          "
echo "======================================================="
echo ""
if [ "$HAS_DOMAIN" = "y" ]; then
  echo " 🔐 Web Dashboard (HTTPS): https://$DOMAIN_NAME"
else
  echo " ⚠️ Web Dashboard (HTTP) : http://$SERVER_IP"
fi
echo " 👤 Username: $WEB_USER"
echo "======================================================="

