# Stable version 1.0.0

====================================

How to deploy new server for SAAS


1. Deploy a New Server:
-OS: Ubuntu 22.04 LTS (recommended)
-Specs: 1–2 vCPU, 2–4 GB RAM for testing

2. SSH Into the Server:
ssh root@your.server.ip
Enter password

3. Create folder, clone repo, start auto Deployment Master Scripts (phase9_deploy_master.sh)

sudo bash -c 'mkdir -p /opt/BM-Scripts && cd /opt/BM-Scripts && git clone https://github.com/roditengosmanteng/bm-deploy-scripts.git . && chmod +x /opt/BM-Scripts/phase*.sh && bash /opt/BM-Scripts/phase9_deploy_master.sh'

4. Manual Run: Creating local backup with retention policy (save 2 latest backup)
Run: bash /opt/BM-Scripts/phase7_backup_local.sh

5. Manual Run: Auditing deployment summary (see system specs)
Run: bash /opt/BM-Scripts/phase10_audit_summary.sh

6. Manual Run: Health Check
Run: bash /opt/BM-Scripts/phase11_monitor_health.sh

✅ Real-time container status
✅ Latest backup timestamp
✅ Cron job confirmation
✅ Disk and memory pressure
✅ Uptime snapshot

7. Manual Restore from backup
Run: bash /opt/BM-Scripts/phase12_restore_manual.sh

8. Delete credentials from deploy.log
Run: bash /opt/BM-Scripts/phase13_clean_credentials.sh


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


📁 Phase 10 – Audit Summary
Filename: phase10_audit_summary.sh
Purpose: Generate a summary of system state, backup integrity, and container health for audit logging


📁 Phase 11 – Monitor Health
Filename: phase11_monitor_health.sh
Purpose: Check container status, backup freshness, cron job activity, and system resource usage


📁 Phase 12 – Manual Restore
Filename: phase12_restore_manual.sh
Purpose: Allow manual selection and restoration of available backups with timestamp and age indicators


📁 Phase 13 – Credential Log Cleaner
Filename: phase13_clean_credentials.sh
Purpose: Surgically remove sensitive credential traces from logs and temporary files for security hygiene


====================================