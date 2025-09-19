#!/bin/bash
echo "🛡️ Phase 6: Hardening BillionMail login panel..."

# === Attempt to locate config file ===
CONFIG_FILE=$(find /opt/BillionMail -type f -name "panel.conf" 2>/dev/null | head -n 1)

if [ -z "$CONFIG_FILE" ]; then
    echo "⚠️ panel.conf not found. Skipping config hardening."
else
    # === Backup original config ===
    cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"

    # === Apply hardening settings ===
    sed -i 's/ALLOW_WEAK_PASSWORDS=true/ALLOW_WEAK_PASSWORDS=false/' "$CONFIG_FILE"
    sed -i 's/SESSION_TIMEOUT=3600/SESSION_TIMEOUT=900/' "$CONFIG_FILE"
    sed -i 's/ENABLE_2FA=false/ENABLE_2FA=true/' "$CONFIG_FILE"

    echo "✅ Config hardened: weak passwords disabled, 2FA enabled, session timeout reduced."
fi

# === Restart service if defined ===
systemctl restart billionmail 2>/dev/null || echo "ℹ️ Manual restart may be required."

# === Define secure panel credentials ===
BM_USER="bmadmin_$(date +%s)"
BM_PASS=$(openssl rand -base64 16)
BM_PATH="panel_$(openssl rand -hex 4)"

# === Apply secure panel settings ===
sudo bm change-user "$BM_USER"
sudo bm change-password "$BM_PASS"
sudo bm change-safe-path "$BM_PATH"

# === Display hardened access ===
PANEL_IP=$(hostname -I | awk '{print $1}')
echo "✅ Panel access updated:"
echo "   Internal address: https://${PANEL_IP}/$BM_PATH"
echo "   Username: $BM_USER"
echo "   Password: $BM_PASS"
