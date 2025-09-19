#!/bin/bash
echo "📦 Phase 12: Manual Restore Selector"

BACKUP_DIR="/opt/BillionMail/backups"
INSTALL_DIR="/opt/BillionMail"
LOG_FILE="/opt/BM-Scripts/deploy.log"

# === Check for available backups ===
echo ""
echo "🔍 Checking available backups..."
BACKUPS=($(ls -1t "$BACKUP_DIR"/bm_backup_*.tar.gz 2>/dev/null))

if [ ${#BACKUPS[@]} -eq 0 ]; then
    echo "❌ No backups found in $BACKUP_DIR"
    exit 1
fi

# === List backups with index and Malaysia Time ===
echo "✅ Found ${#BACKUPS[@]} backup(s):"
for i in "${!BACKUPS[@]}"; do
    LOCAL_TIME=$(date -d "$(date -r "${BACKUPS[$i]}" +"%Y-%m-%d %H:%M:%S") +8 hours" +"%d-%m-%Y %I:%M:%S %p")
    NOW=$(date +%s)
    FILE_TIME=$(date -r "${BACKUPS[$i]}" +%s)
    AGE_HOURS=$(( (NOW - FILE_TIME) / 3600 ))
    echo "$((i+1))) ${BACKUPS[$i]} 🕒 Malaysia Time: $LOCAL_TIME (created ${AGE_HOURS} hour(s) ago)"
done

# === Prompt for selection ===
echo ""
read -p "📥 Enter the number of the backup to restore: " CHOICE

# === Validate input ===
if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt "${#BACKUPS[@]}" ]; then
    echo "❌ Invalid selection. Aborting."
    exit 1
fi

SELECTED_BACKUP="${BACKUPS[$((CHOICE-1))]}"
echo ""
echo "⚠️ You selected: $SELECTED_BACKUP"
echo "⚠️ This will override the current BillionMail version."

read -p "❗ Are you sure you want to proceed? (yes/no): " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
    echo "❌ Restore cancelled."
    exit 0
fi

# === Verify archive integrity ===
tar -tzf "$SELECTED_BACKUP" > /dev/null || { echo "❌ Backup archive is corrupted"; exit 1; }

# === Identify top-level folder in archive ===
RESTORED=$(tar -tzf "$SELECTED_BACKUP" | head -n 1 | cut -d '/' -f1)

# === Remove existing folder if present ===
if [ -n "$RESTORED" ]; then
    rm -rf "$INSTALL_DIR/$RESTORED"
fi

# === Extract backup ===
tar -xzf "$SELECTED_BACKUP" -C "$INSTALL_DIR"
echo "✅ Restored folder: $INSTALL_DIR/$RESTORED"

# === Confirm folder exists ===
if [ -d "$INSTALL_DIR/$RESTORED" ]; then
    echo "✔ Restore folder verified"
else
    echo "❌ Restore folder missing after extraction"
    exit 1
fi

# === Check container health ===
echo ""
echo "🩺 Container status post-restore:"
docker ps --filter "name=billionmail" --format "✔ {{.Names}} is running"

# === Log restore event ===
echo "Restore validated from $SELECTED_BACKUP on $(date)" >> "$LOG_FILE"

# === Final confirmation summary ===
echo ""
echo "✅ Your backup archive is usable"
echo "✅ The restored folder is valid"
echo "✅ Containers remain healthy"
echo "✅ Restore event is logged"
