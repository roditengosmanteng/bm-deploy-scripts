#!/bin/bash
echo "🔐 Phase 3: Injecting GitHub SSH key..."

# === Define admin user (from Phase 2) ===
ADMIN_USER=$(ls /home | grep bmadmin_)

# === GitHub username ===
GITHUB_USER="roditengosmanteng"

# === Fetch public SSH key from GitHub ===
SSH_KEY_URL="https://github.com/${GITHUB_USER}.keys"
SSH_KEY=$(curl -s $SSH_KEY_URL)

# === Create .ssh directory ===
USER_HOME="/home/${ADMIN_USER}"
mkdir -p $USER_HOME/.ssh
echo "$SSH_KEY" > $USER_HOME/.ssh/authorized_keys

# === Set permissions ===
chown -R $ADMIN_USER:$ADMIN_USER $USER_HOME/.ssh
chmod 700 $USER_HOME/.ssh
chmod 600 $USER_HOME/.ssh/authorized_keys

echo "✅ SSH key injected for GitHub user: $GITHUB_USER"
