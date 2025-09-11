#!/bin/bash

# Docker Setup Validation Script
echo "🔍 Validating Docker setup files..."

# Check if required files exist
FILES=(
    "docker-compose.yml"
    "docker-compose.dev.yml"
    "FriendsBookAPI/Dockerfile"
    "FriendsBookAPI/Dockerfile.dev"
    "FriendsBookSPA/Dockerfile"
    "FriendsBookSPA/Dockerfile.dev"
    "FriendsBookAPI/.dockerignore"
    "FriendsBookSPA/.dockerignore"
    "FriendsBookAPI/appsettings.Docker.json"
    "FriendsBookSPA/nginx.conf"
    "DOCKER.md"
    "docker-setup.sh"
)

echo "📁 Checking required files..."
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file - MISSING"
    fi
done

echo ""
echo "🔧 Checking file permissions..."
if [ -x "docker-setup.sh" ]; then
    echo "✅ docker-setup.sh is executable"
else
    echo "❌ docker-setup.sh is not executable"
fi

echo ""
echo "📊 File sizes:"
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        size=$(wc -c < "$file")
        echo "📄 $file: $size bytes"
    fi
done

echo ""
echo "✅ Docker setup validation complete!"
echo "🚀 Ready to run: ./docker-setup.sh start"