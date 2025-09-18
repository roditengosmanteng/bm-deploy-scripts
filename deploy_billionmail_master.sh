#!/bin/bash
echo "🧩 Starting full BillionMail deployment..."

# === Define Script Directory ===
SCRIPT_DIR="/opt/BillionMail/scripts"

# === Execute Each Phase ===
bash $SCRIPT_DIR/create_admin_user.sh || { echo "❌ Phase 1 failed"; exit 1; }
bash $SCRIPT_DIR/inject_ssh_key.sh || { echo "❌ Phase 2 failed"; exit 1; }
bash $SCRIPT_DIR/validate_system.sh || { echo "❌ Phase 3 failed"; exit 1; }
bash $SCRIPT_DIR/deploy_billionmail.sh || { echo "❌ Phase 4 failed"; exit 1; }
bash $SCRIPT_DIR/post_deploy.sh || { echo "❌ Phase 5 failed"; exit 1; }
bash $SCRIPT_DIR/backup_billionmail.sh || { echo "❌ Phase 6 failed"; exit 1; }

# === Schedule Daily Backup at 2 AM ===
(crontab -l 2>/dev/null; echo "0 2 * * * bash $SCRIPT_DIR/backup_billionmail.sh") | crontab -

echo "🎉 Deployment complete and backup scheduled."
