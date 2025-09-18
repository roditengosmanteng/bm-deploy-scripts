#!/bin/bash
echo "💾 Starting BillionMail backup..."

# === Define Backup Directory and Timestamp ===
BACKUP_DIR="/opt/BM_BACKUP"
TIMESTAMP=$(date +%Y%m%d_%H%M)
mkdir -p $BACKUP_DIR/$TIMESTAMP

# === Backup Mail Data ===
tar -czf $BACKUP_DIR/$TIMESTAMP/mail_data.tar.gz /opt/BillionMail/data

# === Backup Database ===
sudo docker exec -i bm-postgres pg_dump -U bmadmin bmdb > $BACKUP_DIR/$TIMESTAMP/db_dump.sql

# === Save Panel Credentials ===
echo "Username: $(sudo bm show-user)" > $BACKUP_DIR/$TIMESTAMP/credentials.txt
echo "Password: $(sudo bm show-password)" >> $BACKUP_DIR/$TIMESTAMP/credentials.txt
echo "Access Path: /pbmailakses" >> $BACKUP_DIR/$TIMESTAMP/credentials.txt

# === Backup Installer ===
tar -czf $BACKUP_DIR/$TIMESTAMP/bm_installer.tar.gz /opt/BillionMail

# === Retention Policy: Keep Latest 2 Backups ===
cd $BACKUP_DIR
ls -1d */ | sort -r | tail -n +3 | xargs -I {} rm -rf {}

echo "✅ Backup complete. Stored at: $BACKUP_DIR/$TIMESTAMP"
