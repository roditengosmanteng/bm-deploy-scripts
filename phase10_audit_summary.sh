#!/bin/bash
echo "📋 Phase 10: Auditing BillionMail deployment..."

SCRIPT_DIR="/opt/BM-Scripts"
LOG_FILE="$SCRIPT_DIR/deploy.log"
INSTALL_DIR="/opt/BillionMail"
BACKUP_DIR="$INSTALL_DIR/backups"

# === Extract server admin credentials ===
ADMIN_USER=$(grep 'Server admin user:' "$LOG_FILE" | awk '{print $4}')
ADMIN_PASS=$(grep 'Server admin password:' "$LOG_FILE" | awk '{print $4}')

# === Extract panel info (manual mode) ===
PANEL_URL=$(grep 'Panel URL:' "$LOG_FILE" | awk -F ': ' '{print $2}')
PANEL_USER=$(grep 'Panel Username:' "$LOG_FILE" | awk -F ': ' '{print $2}')
PANEL_PASS=$(grep 'Panel Password:' "$LOG_FILE" | awk -F ': ' '{print $2}')

# === Get system info ===
OS_VERSION=$(lsb_release -d | awk -F"\t" '{print $2}')
HOSTNAME=$(hostname)
IP_ADDR=$(hostname -I | awk '{print $1}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
MEMORY=$(free -h | awk '/Mem:/ {print $3 "/" $2}')

# === Get latest backup ===
LATEST_BACKUP=$(ls -1t "$BACKUP_DIR"/bm_backup_*.tar.gz 2>/dev/null | head -n 1)
BACKUP_AGE=$(date -r "$LATEST_BACKUP" +"%Y-%m-%d %H:%M:%S")

# === Check container health ===
echo ""
echo "🩺 Container status:"
docker ps --filter "name=billionmail" --format "✔ {{.Names}} is running"

# === Display audit summary ===
echo ""
echo "📦 Deployment Summary:"
echo "🔹 Hostname: $HOSTNAME"
echo "🔹 OS Version: $OS_VERSION"
echo "🔹 IP Address: $IP_ADDR"
echo "🔹 Disk Usage: $DISK_USAGE"
echo "🔹 Memory Usage: $MEMORY"
echo "🔹 Latest Backup: $LATEST_BACKUP"
echo "🔹 Backup Timestamp: $BACKUP_AGE"

echo ""
echo "🔐 Credential Summary:"
echo "1️⃣ Server Admin:"
echo "   Username: $ADMIN_USER"
echo "   Password: $ADMIN_PASS"
echo ""
echo "2️⃣ BillionMail Panel:"
echo "   URL: $PANEL_URL"
echo "   Username: $PANEL_USER"
echo "   Password: $PANEL_PASS"
