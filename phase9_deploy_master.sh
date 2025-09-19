#!/bin/bash
echo "🚀 Phase 9: Running full BillionMail deployment..."

SCRIPT_DIR="/opt/BM-Scripts"
LOG_FILE="$SCRIPT_DIR/deploy.log"

# === Clear previous log ===
> "$LOG_FILE"

# === Execute each phase ===
bash "$SCRIPT_DIR/phase1_update_system.sh" || { echo "❌ Phase 1 failed"; exit 1; }
bash "$SCRIPT_DIR/phase2_bootstrap.sh" || { echo "❌ Phase 2 failed"; exit 1; }
bash "$SCRIPT_DIR/phase3_create_admin.sh" >> "$LOG_FILE" || { echo "❌ Phase 3 failed"; exit 1; }
bash "$SCRIPT_DIR/phase4_validate_system.sh" || { echo "❌ Phase 4 failed"; exit 1; }
bash "$SCRIPT_DIR/phase5_install_billionmail.sh" || { echo "❌ Phase 5 failed"; exit 1; }
bash "$SCRIPT_DIR/phase6_harden_panel.sh" >> "$LOG_FILE" || { echo "❌ Phase 6 failed"; exit 1; }
bash "$SCRIPT_DIR/phase7_backup_local.sh" || { echo "❌ Phase 7 failed"; exit 1; }

# === Schedule daily backup ===
CRON_JOB="0 2 * * * root bash $SCRIPT_DIR/phase7_backup_local.sh"
echo "$CRON_JOB" > /etc/cron.d/bm_local_backup

echo "✅ Full deployment complete. Backup scheduled daily at 2:00 AM."

# === Extract server admin credentials from log ===
ADMIN_USER=$(grep 'Server admin user:' "$LOG_FILE" | awk '{print $4}')
ADMIN_PASS=$(grep 'Server admin password:' "$LOG_FILE" | awk '{print $4}')

# === Display final credentials ===
echo ""
echo "🔐 Important credentials:"
echo "1️⃣ Server admin user:"
echo "   Username: $ADMIN_USER"
echo "   Password: $ADMIN_PASS"
echo ""
echo "2️⃣ BillionMail login panel:"
echo "   ⚠️ Credentials must be set manually via dashboard or CLI"
echo "   URL: (check Phase 6 output or dashboard)"
