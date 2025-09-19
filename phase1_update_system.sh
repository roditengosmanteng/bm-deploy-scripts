#!/bin/bash
echo "🔧 Phase 0: Updating and securing Ubuntu..."

# === Update Package Index ===
sudo apt update -y

# === Upgrade Installed Packages ===
sudo apt upgrade -y

# === Install Essentials (No Git) ===
sudo apt install -y curl ufw fail2ban

# === Enable Firewall ===
sudo ufw allow OpenSSH
sudo ufw --force enable

echo "✅ System is updated, secured, and ready for deployment."
