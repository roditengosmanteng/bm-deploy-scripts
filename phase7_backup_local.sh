#!/bin/bash
echo "🗂️ Phase 7: Creating local backup with retention policy..."

# === Define backup directory ===
BACKUP_DIR="/opt/BillionMail/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/bm_backup_${TIMESTAMP}.tar.gz"

# === Create backup directory if missing ===
mkdir -p "$BACKUP_DIR"

# === Find valid backup target ===
TARGET=$(find /opt/BillionMail -type d \( -name "data" -o -name "config" -o -name "webmail" \) | head -n 1)

# === Archive if target found ===
if [ -n "$TARGET" ]; then
  tar -czf "$BACKUP_FILE" "$TARGET"
  echo "✅ Backup created: $BACKUP_FILE"

  # === Verify archive integrity ===
  tar -tzf "$BACKUP_FILE" > /dev/null && echo "✅ Archive verified" || { echo "❌ Archive verification failed"; exit 1; }
else
  echo "❌ No valid backup target found. Skipping backup."
  exit 1
fi

# === Retention policy: keep last 2 backups ===
echo "🧹 Applying retention policy..."
ls -1t "$BACKUP_DIR"/bm_backup_*.tar.gz | tail -n +3 | xargs -r rm -f
echo "✅ Retention applied: only latest 2 backups kept."
