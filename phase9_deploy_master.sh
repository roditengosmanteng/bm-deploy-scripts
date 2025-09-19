#!/bin/bash
echo "🚀 Phase 9: Running full BillionMail deployment..."

SCRIPT_DIR="/opt/BM-Scripts"

# === Execute each phase in order ===
bash $SCRIPT_DIR/phase1_update_system.sh || { echo "❌ Phase 1 failed"; exit 1; }
bash $SCRIPT_DIR/phase2_bootstrap.sh || { echo "❌ Phase 2 failed"; exit 1; }
bash $SCRIPT_DIR/phase3_create_admin.sh || { echo "❌ Phase 3 failed"; exit 1; }
bash $SCRIPT_DIR/phase4_validate_system.sh || { echo "❌ Phase 4 failed"; exit 1; }
bash $SCRIPT_DIR/phase5_install_billionmail.sh || { echo "❌ Phase 5 failed"; exit 1; }
bash $SCRIPT_DIR/phase6_harden_panel.sh || { echo "❌ Phase 6 failed"; exit 1; }
bash $SCRIPT_DIR/phase7_backup_local.sh || { echo "❌ Phase 7 failed"; exit 1; }

# === Optional: Restore from backup if needed ===
# bash $SCRIPT_DIR/phase8_restore_local.sh || { echo "❌ Phase 8 failed"; exit 1; }

# === Schedule daily backup via cron ===
CRON_JOB="0 2 * * * root bash $SCRIPT_DIR/phase7_backup_local.sh"
echo "$CRON_JOB" > /etc/cron.d/bm_local_backup

echo "✅ Full deployment complete. Backup scheduled daily at 2:00 AM."
