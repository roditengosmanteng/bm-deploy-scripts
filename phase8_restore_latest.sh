#!/bin/bash
echo "♻️ Phase 8: Restoring BillionMail from latest local backup..."

# === Define backup directory ===
BACKUP_DIR="/opt/BillionMail/backups"

# === Find latest backup file ===
LATEST_BACKUP=$(ls -1t "$BACKUP_DIR"/bm_backup_*.tar.gz | head -n 1)

# === Validate backup exists ===
if [ -z "$LATEST_BACKUP" ]; then
    echo "❌ No backup file found in $BACKUP_DIR"
    exit 1
fi

# === Verify archive integrity ===
tar -tzf "$LATEST_BACKUP" > /dev/null || { echo "❌ Backup archive is corrupted"; exit 1; }

# === Identify top-level folder in archive ===
RESTORED=$(tar -tzf "$LATEST_BACKUP" | head -n 1 | cut -d '/' -f1)

# === Remove existing folder if present ===
if [ -n "$RESTORED" ]; then
    rm -rf "/opt/BillionMail/$RESTORED"
fi

# === Extract backup ===
tar -xzf "$LATEST_BACKUP" -C /opt/BillionMail/

echo "✅ Restored BillionMail from: $LATEST_BACKUP"
