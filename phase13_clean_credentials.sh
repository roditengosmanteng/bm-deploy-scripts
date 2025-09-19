#!/bin/bash
echo "🧼 Phase 13: Delete credentials from deploy.log..."

LOG_FILE="/opt/BM-Scripts/deploy.log"

# === Remove only credential lines ===
sed -i '/Server admin user:/d' "$LOG_FILE"
sed -i '/Server admin password:/d' "$LOG_FILE"
sed -i '/Panel URL:/d' "$LOG_FILE"
sed -i '/Panel Username:/d' "$LOG_FILE"
sed -i '/Panel Password:/d' "$LOG_FILE"

echo "✅ Credentials removed from $LOG_FILE"
