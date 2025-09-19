#!/bin/bash
echo "📦 Phase 5: Installing BillionMail..."

# === Define install directory ===
INSTALL_DIR="/opt/BillionMail"

# === Clone official BillionMail repo ===
git clone https://github.com/aaPanel/BillionMail $INSTALL_DIR

# === Navigate and run installer ===
cd $INSTALL_DIR
bash install.sh

echo "✅ BillionMail installed successfully in $INSTALL_DIR"
