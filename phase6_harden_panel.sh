#!/bin/bash
echo "🛡️ Phase 6: Hardening BillionMail login panel..."

LOG_FILE="/opt/BM-Scripts/deploy.log"

# === Define auto credentials ===
BM_USER="admin12345"
BM_PASS="password12345"
BM_PATH="akses"

# === Enter project directory ===
cd /opt/BillionMail || { echo "❌ Cannot access /opt/BillionMail"; exit 1; }

# === Apply credentials using CLI ===
echo "$BM_USER" | bash change_user.sh
echo "$BM_PASS" | bash change_pass.sh
echo "$BM_PATH" | bash change_safe_path.sh

# === Restart container to apply changes ===
docker restart $(docker ps -q --filter "name=billionmail-core") >/dev/null

# === Display credentials ===
echo "✅ Panel hardened and credentials applied:"
echo "   URL: https://$(hostname -I | awk '{print $1}')/$BM_PATH"
echo "   Username: $BM_USER"
echo "   Password: $BM_PASS"

# === Log credentials ===
echo "Panel Username: $BM_USER" >> "$LOG_FILE"
echo "Panel Password: $BM_PASS" >> "$LOG_FILE"
echo "Panel URL: https://$(hostname -I | awk '{print $1}')/$BM_PATH" >> "$LOG_FILE"
