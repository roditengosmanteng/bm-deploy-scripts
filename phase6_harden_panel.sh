#!/bin/bash
echo "🛡️ Phase 6: Hardening BillionMail login panel..."

LOG_FILE="/opt/BM-Scripts/deploy.log"

# === Define auto credentials ===
BM_USER="admin12345"
BM_PASS="password12345"
BM_PATH="akses"

# === Wait for container to be ready ===
sleep 5

# === Override credentials inside container ===
docker exec billionmail-core-billionmail-1 bash -c "
  echo '$BM_USER' > /data/config/admin_user.txt
  echo '$BM_PASS' > /data/config/admin_pass.txt
  echo '$BM_PATH' > /data/config/safe_path.txt
"

# === Restart container to apply changes ===
docker restart billionmail-core-billionmail-1 >/dev/null

# === Display and log credentials ===
echo "✅ Panel hardened and credentials applied:"
echo "   URL: https://$(hostname -I | awk '{print $1}')/$BM_PATH"
echo "   Username: $BM_USER"
echo "   Password: $BM_PASS"
echo "Panel Username: $BM_USER" >> "$LOG_FILE"
echo "Panel Password: $BM_PASS" >> "$LOG_FILE"
echo "Panel URL: https://$(hostname -I | awk '{print $1}')/$BM_PATH" >> "$LOG_FILE"
