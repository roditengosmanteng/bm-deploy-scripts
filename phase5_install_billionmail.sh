#!/bin/bash
echo "📦 Phase 5: Installing BillionMail..."

# === Define install directory ===
INSTALL_DIR="/opt/BillionMail"

# === Create directory if missing ===
mkdir -p $INSTALL_DIR

# === Clone BillionMail source ===
git clone https://github.com/roditengosmanteng/billionmail $INSTALL_DIR/app

# === Navigate and run installer ===
cd $INSTALL_DIR/app
chmod +x install.sh
./install.sh

echo "✅ BillionMail installed successfully in $INSTALL_DIR/app"
