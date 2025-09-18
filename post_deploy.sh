#!/bin/bash
echo "🔐 Hardening BillionMail panel..."

# === Generate Unique Panel Credentials ===
UNIQUE_CODE=$(openssl rand -hex 2)
PANEL_USER="bmc-client01_${UNIQUE_CODE}"
PANEL_PASS="BmPanel#$(openssl rand -hex 4)"
SAFE_PATH="pbmailakses"

# === Apply Changes via BillionMail CLI ===
sudo bm change-user --new "$PANEL_USER"
sudo bm change-password --new "$PANEL_PASS"
sudo bm change-safe-path --new "$SAFE_PATH"

# === Output Hardened Credentials ===
echo "✅ Panel hardened:"
echo "Username: $PANEL_USER"
echo "Password: $PANEL_PASS"
echo "Access path: /$SAFE_PATH"
