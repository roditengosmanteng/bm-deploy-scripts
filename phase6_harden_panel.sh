#!/bin/bash
echo "🛡️ Phase 6: Hardening BillionMail login panel..."

# === Define config path ===
CONFIG_FILE="/opt/BillionMail/app/config/panel.conf"

# === Backup original config ===
cp $CONFIG_FILE ${CONFIG_FILE}.bak

# === Apply hardening settings ===
sed -i 's/ALLOW_WEAK_PASSWORDS=true/ALLOW_WEAK_PASSWORDS=false/' $CONFIG_FILE
sed -i 's/SESSION_TIMEOUT=3600/SESSION_TIMEOUT=900/' $CONFIG_FILE
sed -i 's/ENABLE_2FA=false/ENABLE_2FA=true/' $CONFIG_FILE

# === Restart service if needed ===
systemctl restart billionmail || echo "ℹ️ Manual restart may be required."

echo "✅ Panel hardened: weak passwords disabled, 2FA enabled, session timeout reduced."
