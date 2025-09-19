#!/bin/bash
echo "🩺 Phase 11: Checking BillionMail system health..."

SCRIPT_DIR="/opt/BM-Scripts"
INSTALL_DIR="/opt/BillionMail"
BACKUP_DIR="$INSTALL_DIR/backups"
CRON_FILE="/etc/cron.d/bm_local_backup"

# === Check container status ===
echo ""
echo "📦 Container Status:"
docker ps --filter "name=billionmail" --format "✔ {{.Names}} is running"

# === Check latest backup ===
echo ""
echo "🗂️ Backup Status:"
LATEST_BACKUP=$(ls -1t "$BACKUP_DIR"/bm_backup_*.tar.gz 2>/dev/null | head -n 1)
if [ -n "$LATEST_BACKUP" ]; then
  BACKUP_UTC=$(date -u -r "$LATEST_BACKUP" +"%Y-%m-%d %H:%M:%S")
  BACKUP_MY=$(date -d "$BACKUP_UTC +8 hours" +"%d-%m-%Y %I:%M:%S %p")
  echo "✔ Latest backup: $LATEST_BACKUP"
  echo "🕒 Malaysia Time: $BACKUP_MY"
else
  echo "❌ No backup found in $BACKUP_DIR"
fi

# === Check cron job ===
echo ""
echo "⏱️ Cron Job Status:"
if grep -q "phase7_backup_local.sh" "$CRON_FILE"; then
  echo "✔ Backup cron job is active in $CRON_FILE"
else
  echo "❌ Backup cron job missing"
fi

# === Check system pressure ===
echo ""
echo "📊 System Usage:"
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
MEMORY=$(free -h | awk '/Mem:/ {print $3 "/" $2}')
echo "💾 Disk Usage: $DISK_USAGE"
echo "🧠 Memory Usage: $MEMORY"

# === Optional: check uptime ===
echo ""
echo "⏱️ Uptime:"
uptime -p
