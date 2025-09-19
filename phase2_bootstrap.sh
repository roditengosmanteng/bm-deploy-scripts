#!/bin/bash
echo "🚀 Phase 1: Bootstrapping deployment environment..."

# === Define target directory ===
SCRIPT_DIR="/opt/BM-Scripts"

# === Create directory if missing ===
mkdir -p $SCRIPT_DIR

# === Set executable permissions ===
chmod +x $SCRIPT_DIR/phase*.sh

echo "✅ Deployment scripts are ready in $SCRIPT_DIR"
