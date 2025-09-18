#!/bin/bash
echo "🗂️ Phase 7: Creating local backup with retention policy..."

# === Define backup directory ===
BACKUP_DIR="/opt/BillionMail/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/bm_backup_${TIMESTAMP}.tar.gz"

# === Create backup directory if missing ===
mkdir -p $BACKUP_DIR

# === Archive BillionMail app ===
tar -czf $BACKUP_FILE /opt/BillionMail/app

echo "✅ Backup created: $BACKUP_FILE"

# === Retention policy: keep last 5 backups ===
echo "🧹 Applying retention policy..."
ls -1t $BACKUP_DIR/bm_backup_*.tar.gz | tail -n +6 | xargs -r rm -f

echo "✅ Retention applied: only latest 5 backups kept."
