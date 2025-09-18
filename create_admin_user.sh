#!/bin/bash
echo "👤 Creating secure admin user..."

# === Generate Unique Username ===
UNAME="bmclient_$(date +%Y%m%d)_$(openssl rand -hex 2)"

# === Generate Secure Password ===
PASSWD=$(openssl rand -base64 12)

# === Create User and Set Password ===
sudo useradd -m -s /bin/bash "$UNAME"
echo "$UNAME:$PASSWD" | sudo chpasswd

# === Add to Sudo Group ===
sudo usermod -aG sudo "$UNAME"

# === Output Credentials ===
echo "✅ Admin user created:"
echo "Username: $UNAME"
echo "Password: $PASSWD"
