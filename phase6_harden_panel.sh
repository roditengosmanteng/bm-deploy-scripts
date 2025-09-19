#!/bin/bash
echo "🛡️ Phase 6: Skipping panel credential override (manual mode)..."

LOG_FILE="/opt/BM-Scripts/deploy.log"

# === Confirm container is running ===
docker ps --filter "name=billionmail-core" --format "✔ Container {{.Names}} is active"

# === Log placeholder for manual credentials ===
echo "Panel Username: (set manually)" >> "$LOG_FILE"
echo "Panel Password: (set manually)" >> "$LOG_FILE"
echo "Panel URL: (set manually)" >> "$LOG_FILE"

echo "ℹ️ Panel credentials must be set manually via BillionMail dashboard or CLI."
