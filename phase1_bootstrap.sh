#!/bin/bash
echo "🚀 Phase 1: Bootstrapping deployment environment..."

# === Define target directory ===
SCRIPT_DIR="/opt/BillionMail/scripts"

# === Create directory if missing ===
mkdir -p $SCRIPT_DIR

# === Clone your private GitHub repo ===
git clone https://github.com/roditengosmanteng/bm-deploy-scripts.git $SCRIPT_DIR

# === Set executable permissions ===
chmod +x $SCRIPT_DIR/phase*.sh

echo "✅ Deployment scripts are ready in $SCRIPT_DIR"
