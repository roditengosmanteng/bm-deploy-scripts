#!/bin/bash
echo "📦 Phase 5: Installing BillionMail..."

INSTALL_DIR="/opt/BillionMail"
REPO_URL="https://github.com/aaPanel/BillionMail"

# === Check if already installed ===
if [ -d "$INSTALL_DIR" ]; then
    echo "⚠️ $INSTALL_DIR already exists. Skipping clone."
else
    echo "🔄 Cloning BillionMail repo..."
    git clone "$REPO_URL" "$INSTALL_DIR" || { echo "❌ Clone failed"; exit 1; }
fi

cd "$INSTALL_DIR" || { echo "❌ Failed to enter $INSTALL_DIR"; exit 1; }

# === Run installer or fallback to Docker ===
if [ -f "install.sh" ]; then
    echo "🚀 Running install.sh..."
    bash install.sh || { echo "❌ install.sh failed"; exit 1; }
elif [ -f "docker-compose.yml" ]; then
    echo "🐳 Running Docker Compose..."
    docker compose up -d || { echo "❌ Docker Compose failed"; exit 1; }
else
    echo "❌ No install.sh or docker-compose.yml found. Cannot proceed."
    exit 1
fi

echo "✅ BillionMail installed successfully in $INSTALL_DIR"
