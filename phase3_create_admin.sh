#!/bin/bash
echo "👤 Phase 3: Creating secure admin user..."

LOG_FILE="/opt/BM-Scripts/deploy.log"

# === Generate unique username and password ===
ADMIN_USER="bmadmin_$(date +%s)"
ADMIN_PASS=$(openssl rand -base64 16)

# === Create user and add to sudoers ===
useradd -m -s /bin/bash "$ADMIN_USER"
echo "${ADMIN_USER}:${ADMIN_PASS}" | chpasswd
usermod -aG sudo "$ADMIN_USER"

# === Display and log credentials ===
echo "✅ Admin user created:"
echo "   Username: $ADMIN_USER"
echo "   Password: $ADMIN_PASS"
echo "Server admin user: $ADMIN_USER" >> "$LOG_FILE"
echo "Server admin password: $ADMIN_PASS" >> "$LOG_FILE"
