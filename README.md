# Stable version 1.0.0

====================================

How to deploy new server for SAAS


1. Deploy a New Server:
-OS: Ubuntu 22.04 LTS (recommended)
-Specs: 1–2 vCPU, 2–4 GB RAM for testing

2. SSH Into the Server:
ssh root@your.server.ip
Enter password

3. Clone Your Deployment Scripts

run:
git clone https://github.com/roditengosmanteng/bm-deploy-scripts.git

4. Make Scripts Executable
run: chmod +x /opt/BillionMail/scripts/phase*.sh

5. Navigate to your script directory
cd /opt/BillionMail/scripts

6. Run the Master Deploy Script
bash phase9_deploy_master.sh

====================================

📁 Phase 1 – Update System
Filename: phase0_update_system.sh
Purpose: Update Ubuntu, install essentials, enable firewall


📁 Phase 2 – Bootstrap Scripts
Filename: phase1_bootstrap.sh
Purpose: Clone repo, set permissions, prepare script directory


📁 Phase 3 – Create Admin User
Filename: phase2_create_admin.sh
Purpose: Create secure, unique admin user with sudo access


📁 Phase 4 – Validate System
Filename: phase4_validate_system.sh
Purpose: Check OS, hostname, Docker, disk, and memory


📁 Phase 5 – Install BillionMail
Filename: phase5_install_billionmail.sh
Purpose: Clone and install BillionMail app


📁 Phase 6 – Harden Panel
Filename: phase6_harden_panel.sh
Purpose: Apply security settings to login panel


📁 Phase 7 – Local Backup
Filename: phase7_backup_local.sh
Purpose: Create timestamped backup and apply retention


📁 Phase 8 – Restore Backup
Filename: phase8_restore_local.sh
Purpose: Restore app from latest backup


📁 Phase 9 – Master Deploy
Filename: phase9_deploy_master.sh
Purpose: Run all phases and schedule daily backup

====================================