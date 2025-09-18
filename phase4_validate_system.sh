#!/bin/bash
echo "🧪 Phase 4: Validating system environment..."

# === Check OS version ===
OS_VERSION=$(lsb_release -d | awk -F"\t" '{print $2}')
echo "🔍 OS Version: $OS_VERSION"

# === Check hostname ===
HOSTNAME=$(hostname)
echo "🔍 Hostname: $HOSTNAME"

# === Check Docker installation ===
if command -v docker &> /dev/null; then
    echo "✅ Docker is installed"
else
    echo "❌ Docker is NOT installed"
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    echo "✅ Docker installed successfully"
fi

# === Check disk space ===
echo "🔍 Disk usage:"
df -h /

# === Check memory ===
echo "🔍 Memory usage:"
free -h

echo "✅ System validation complete."
