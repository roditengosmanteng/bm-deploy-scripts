#!/bin/bash
echo "🧪 Validating system..."

# === OS Info ===
echo "📦 OS Info:"
lsb_release -a

# === Disk Space ===
echo "💽 Disk Usage:"
df -h /

# === Docker Version ===
echo "🐳 Docker Version:"
docker --version

# === Git Version ===
echo "🔧 Git Version:"
git --version

# === Network Test ===
echo "🌐 Network Connectivity:"
ping -c 2 github.com

echo "✅ System validation complete."
