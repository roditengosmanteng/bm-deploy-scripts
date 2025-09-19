#!/bin/bash
echo "👤 Phase 3: Creating secure admin user..."

LOG_FILE="/opt/BM-Scripts/deploy.log"

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

# === Log credentials ===
echo "Server admin user: $ADMIN_USER" >> "$LOG_FILE"

# === Transfer ownership of deployment and app folders ===
if [ "$(stat -c %U /opt/BillionMail 2>/dev/null)" != "$ADMIN_USER" ]; then
    chown -R $ADMIN_USER:$ADMIN_USER /opt/BillionMail /opt/BM-Scripts
    echo "✅ Ownership transferred to $ADMIN_USER"
else
    echo "ℹ️ Ownership already set to $ADMIN_USER"
fi
