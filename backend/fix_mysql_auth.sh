#!/bin/bash

# Fix MySQL authentication for root user
# This allows root to connect without password for local connections

echo "🔧 Fixing MySQL authentication..."
echo ""
echo "This will allow root user to connect from localhost without password."
echo "Run this command manually:"
echo ""
echo "sudo mysql -e \"ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';\""
echo "sudo mysql -e \"FLUSH PRIVILEGES;\""
echo ""
echo "OR if you want to set a password:"
echo ""
echo "sudo mysql -e \"ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_password';\""
echo "sudo mysql -e \"FLUSH PRIVILEGES;\""
echo ""
echo "Then update backend/.env with DB_PASSWORD=your_password"

