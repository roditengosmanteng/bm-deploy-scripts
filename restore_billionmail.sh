#!/bin/bash
echo "🔁 Restoring BillionMail from latest backup..."

# === Define Backup Directory ===
BACKUP_DIR="/opt/BM_BACKUP"

# === Find Latest Backup Folder ===
LATEST=$(ls -1d $BACKUP_DIR/*/ | sort -r | head -n 1)

echo "📦 Using backup: $LATEST"

# === Restore Installer ===
tar -xzf $LATEST/bm_installer.tar.gz -C /opt/

# === Restore Mail Data ===
tar -xzf $LATEST/mail_data.tar.gz -C /

# === Restore Database ===
cat $LATEST/db_dump.sql | sudo docker exec -i bm-postgres psql -U bmadmin bmdb

# === Show Credentials ===
echo "🔐 Restored Credentials:"
cat $LATEST/credentials.txt

echo "✅ Restore complete."
