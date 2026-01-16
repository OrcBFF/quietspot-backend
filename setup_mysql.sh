#!/bin/bash

# QuietSpot MySQL Setup Script
# This script installs and configures MySQL for the QuietSpot project

set -e

echo "🚀 Setting up MySQL for QuietSpot..."

# Check if MySQL is already installed
if command -v mysql &> /dev/null; then
    echo "✅ MySQL client is already installed"
    MYSQL_INSTALLED=true
else
    echo "📦 Installing MySQL server..."
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
    MYSQL_INSTALLED=false
fi

# Start and enable MySQL service
echo "🔄 Starting MySQL service..."
sudo systemctl start mysql
sudo systemctl enable mysql

# Wait for MySQL to be ready
echo "⏳ Waiting for MySQL to be ready..."
sleep 3

# Check MySQL version
echo "📊 MySQL version:"
sudo mysql -e "SELECT VERSION();" 2>/dev/null || mysql -e "SELECT VERSION();"

# Create database and user
echo "🗄️  Creating database and user..."

# Check if database already exists
DB_EXISTS=$(sudo mysql -e "SHOW DATABASES LIKE 'quietspot';" 2>/dev/null | grep -c quietspot || echo "0")

if [ "$DB_EXISTS" -eq "0" ]; then
    echo "Creating quietspot database..."
    
    # Create database
    sudo mysql <<EOF
CREATE DATABASE IF NOT EXISTS quietspot
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
EOF

    echo "✅ Database 'quietspot' created"
else
    echo "⚠️  Database 'quietspot' already exists"
fi

# Import schema
echo "📥 Importing database schema..."
if [ -f "Raf/quietspot.sql" ]; then
    sudo mysql quietspot < Raf/quietspot.sql
    echo "✅ Schema imported"
else
    echo "❌ Error: Raf/quietspot.sql not found"
    exit 1
fi

# Import seed data
echo "🌱 Importing seed data..."
if [ -f "Raf/seed_quietspot.sql" ]; then
    sudo mysql quietspot < Raf/seed_quietspot.sql
    echo "✅ Seed data imported"
else
    echo "⚠️  Warning: Raf/seed_quietspot.sql not found (optional)"
fi

# Verify data
echo "🔍 Verifying database setup..."
LOCATION_COUNT=$(sudo mysql -e "SELECT COUNT(*) FROM quietspot.locations;" 2>/dev/null | tail -1)
USER_COUNT=$(sudo mysql -e "SELECT COUNT(*) FROM quietspot.users;" 2>/dev/null | tail -1)

echo "📊 Database statistics:"
echo "   - Locations: $LOCATION_COUNT"
echo "   - Users: $USER_COUNT"

# Set up MySQL user for the API (optional - uses root by default)
echo ""
echo "💡 Note: The API will use root user by default."
echo "   To create a dedicated user, run:"
echo "   sudo mysql -e \"CREATE USER 'quietspot'@'localhost' IDENTIFIED BY 'password';\""
echo "   sudo mysql -e \"GRANT ALL PRIVILEGES ON quietspot.* TO 'quietspot'@'localhost';\""
echo "   sudo mysql -e \"FLUSH PRIVILEGES;\""

echo ""
echo "✅ MySQL setup complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Update backend/.env with your MySQL credentials"
echo "   2. Start the backend API: cd backend && npm install && npm start"
echo "   3. Run the Flutter app with API URL configured"

