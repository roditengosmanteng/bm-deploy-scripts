#!/bin/bash
echo "🔑 Injecting GitHub SSH key..."

# === GitHub Username ===
GH_USER="roditengosmanteng"

# === Fetch Public Key from GitHub ===
KEY_URL="https://github.com/$GH_USER.keys"
curl -s $KEY_URL >> ~/.ssh/authorized_keys

# === Confirm Injection ===
echo "✅ SSH key injected from GitHub user: $GH_USER"
