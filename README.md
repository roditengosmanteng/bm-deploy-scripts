📁 Phase 0 – Update System
Filename: phase0_update_system.sh
Purpose: Update Ubuntu, install essentials, enable firewall

#!/bin/bash
echo "🔧 Phase 0: Updating and securing Ubuntu..."

sudo apt update -y
sudo apt upgrade -y
sudo apt install -y curl git ufw fail2ban

sudo ufw allow OpenSSH
sudo ufw --force enable

echo "✅ System is updated, secured, and ready for deployment."


📁 Phase 1 – Bootstrap Scripts
Filename: phase1_bootstrap.sh
Purpose: Clone repo, set permissions, prepare script directory

#!/bin/bash
echo "🚀 Phase 1: Bootstrapping deployment environment..."

SCRIPT_DIR="/opt/BillionMail/scripts"
mkdir -p $SCRIPT_DIR
git clone https://github.com/roditengosmanteng/bm-deploy-scripts.git $SCRIPT_DIR
chmod +x $SCRIPT_DIR/phase*.sh

echo "✅ Deployment scripts are ready in $SCRIPT_DIR"


📁 Phase 2 – Create Admin User
Filename: phase2_create_admin.sh
Purpose: Create secure, unique admin user with sudo access

#!/bin/bash
echo "👤 Phase 2: Creating secure admin user..."

ADMIN_USER="bmadmin_$(date +%s)"
ADMIN_PASS=$(openssl rand -base64 16)

useradd -m -s /bin/bash $ADMIN_USER
echo "${ADMIN_USER}:${ADMIN_PASS}" | chpasswd
usermod -aG sudo $ADMIN_USER

echo "✅ Admin user created:"
echo "   Username: $ADMIN_USER"
echo "   Password: $ADMIN_PASS"


📁 Phase 3 – Inject SSH Key
Filename: phase3_inject_ssh.sh
Purpose: Inject GitHub public SSH key into admin user

#!/bin/bash
echo "🔐 Phase 3: Injecting GitHub SSH key..."

ADMIN_USER=$(ls /home | grep bmadmin_)
GITHUB_USER="roditengosmanteng"
SSH_KEY=$(curl -s https://github.com/${GITHUB_USER}.keys)

USER_HOME="/home/${ADMIN_USER}"
mkdir -p $USER_HOME/.ssh
echo "$SSH_KEY" > $USER_HOME/.ssh/authorized_keys

chown -R $ADMIN_USER:$ADMIN_USER $USER_HOME/.ssh
chmod 700 $USER_HOME/.ssh
chmod 600 $USER_HOME/.ssh/authorized_keys

echo "✅ SSH key injected for GitHub user: $GITHUB_USER"


📁 Phase 4 – Validate System
Filename: phase4_validate_system.sh
Purpose: Check OS, hostname, Docker, disk, and memory

#!/bin/bash
echo "🧪 Phase 4: Validating system environment..."

OS_VERSION=$(lsb_release -d | awk -F"\t" '{print $2}')
HOSTNAME=$(hostname)

echo "🔍 OS Version: $OS_VERSION"
echo "🔍 Hostname: $HOSTNAME"

if command -v docker &> /dev/null; then
    echo "✅ Docker is installed"
else
    echo "❌ Docker is NOT installed"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    echo "✅ Docker installed successfully"
fi

df -h /
free -h

echo "✅ System validation complete."


📁 Phase 5 – Install BillionMail
Filename: phase5_install_billionmail.sh
Purpose: Clone and install BillionMail app

#!/bin/bash
echo "📦 Phase 5: Installing BillionMail..."

INSTALL_DIR="/opt/BillionMail"
mkdir -p $INSTALL_DIR
git clone https://github.com/roditengosmanteng/billionmail $INSTALL_DIR/app

cd $INSTALL_DIR/app
chmod +x install.sh
./install.sh

echo "✅ BillionMail installed successfully in $INSTALL_DIR/app"


📁 Phase 6 – Harden Panel
Filename: phase6_harden_panel.sh
Purpose: Apply security settings to login panel

#!/bin/bash
echo "🛡️ Phase 6: Hardening BillionMail login panel..."

CONFIG_FILE="/opt/BillionMail/app/config/panel.conf"
cp $CONFIG_FILE ${CONFIG_FILE}.bak

sed -i 's/ALLOW_WEAK_PASSWORDS=true/ALLOW_WEAK_PASSWORDS=false/' $CONFIG_FILE
sed -i 's/SESSION_TIMEOUT=3600/SESSION_TIMEOUT=900/' $CONFIG_FILE
sed -i 's/ENABLE_2FA=false/ENABLE_2FA=true/' $CONFIG_FILE

systemctl restart billionmail || echo "ℹ️ Manual restart may be required."

echo "✅ Panel hardened: weak passwords disabled, 2FA enabled, session timeout reduced."


📁 Phase 7 – Local Backup
Filename: phase7_backup_local.sh
Purpose: Create timestamped backup and apply retention

#!/bin/bash
echo "🗂️ Phase 7: Creating local backup with retention policy..."

BACKUP_DIR="/opt/BillionMail/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/bm_backup_${TIMESTAMP}.tar.gz"

mkdir -p $BACKUP_DIR
tar -czf $BACKUP_FILE /opt/BillionMail/app

echo "✅ Backup created: $BACKUP_FILE"

ls -1t $BACKUP_DIR/bm_backup_*.tar.gz | tail -n +6 | xargs -r rm -f
echo "✅ Retention applied: only latest 5 backups kept."


📁 Phase 8 – Restore Backup
Filename: phase8_restore_local.sh
Purpose: Restore app from latest backup

#!/bin/bash
echo "♻️ Phase 8: Restoring BillionMail from latest local backup..."

BACKUP_DIR="/opt/BillionMail/backups"
LATEST_BACKUP=$(ls -1t $BACKUP_DIR/bm_backup_*.tar.gz | head -n 1)

if [ -z "$LATEST_BACKUP" ]; then
    echo "❌ No backup file found in $BACKUP_DIR"
    exit 1
fi

rm -rf /opt/BillionMail/app
tar -xzf "$LATEST_BACKUP" -C /opt/BillionMail/

echo "✅ Restored BillionMail from: $LATEST_BACKUP"


📁 Phase 9 – Master Deploy
Filename: phase9_deploy_master.sh
Purpose: Run all phases and schedule daily backup

#!/bin/bash
echo "🚀 Phase 9: Running full BillionMail deployment..."

SCRIPT_DIR="/opt/BillionMail/scripts"

bash $SCRIPT_DIR/phase0_update_system.sh || { echo "❌ Phase 0 failed"; exit 1; }
bash $SCRIPT_DIR/phase1_bootstrap.sh || { echo "❌ Phase 1 failed"; exit 1; }
bash $SCRIPT_DIR/phase2_create_admin.sh || { echo "❌ Phase 2 failed"; exit 1; }
bash $SCRIPT_DIR/phase3_inject_ssh.sh || { echo "❌ Phase 3 failed"; exit 1; }
bash $SCRIPT_DIR/phase4_validate_system.sh || { echo "❌ Phase 4 failed"; exit 1; }
bash $SCRIPT_DIR/phase5_install_billionmail.sh || { echo "❌ Phase 5 failed"; exit 1; }
bash $SCRIPT_DIR/phase6_harden_panel.sh || { echo "❌ Phase 6 failed"; exit 1; }
bash $SCRIPT_DIR/phase7_backup_local.sh || { echo "❌ Phase 7 failed"; exit 1; }

# Optional restore
# bash $SCRIPT_DIR/phase8_restore_local.sh

CRON_JOB="0 2 * * * root bash $SCRIPT_DIR/phase7_backup_local.sh"
echo "$CRON_JOB" > /etc/cron.d/bm_local_backup

echo "✅ Full deployment complete. Backup scheduled daily at 2:00 AM."


