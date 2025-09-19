#!/bin/bash
echo "👤 Phase 2: Creating secure admin user..."

# === Generate unique username ===
ADMIN_USER="bmadmin_$(date +%s)"

# === Generate secure password ===
ADMIN_PASS=$(openssl rand -base64 16)

# === Create user ===
useradd -m -s /bin/bash $ADMIN_USER
echo "${ADMIN_USER}:${ADMIN_PASS}" | chpasswd

# === Add to sudoers ===
usermod -aG sudo $ADMIN_USER

# === Display credentials ===
echo "✅ Admin user created:"
echo "   Username: $ADMIN_USER"
echo "   Password: $ADMIN_PASS"
