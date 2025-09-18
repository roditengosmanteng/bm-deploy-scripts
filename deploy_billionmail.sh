#!/bin/bash
echo "🚀 Deploying BillionMail..."

# === Define Install Directory ===
INSTALL_DIR="/opt/BillionMail"

# === Clone BillionMail ===
sudo git clone https://github.com/aaPanel/BillionMail $INSTALL_DIR || { echo "❌ Clone failed"; exit 1; }

# === Run Installer ===
cd $INSTALL_DIR
sudo bash install.sh

# === Start and Check Status ===
sudo bash bm.sh start
sudo bash bm.sh status

echo "✅ BillionMail deployed and running."
