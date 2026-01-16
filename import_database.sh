#!/bin/bash

# Import QuietSpot database
# Run this script and enter your password when prompted

cd "/home/aragorn/projects/projectHCI (copy)"

echo "Importing database schema..."
sudo mysql < Raf/quietspot.sql

echo "Importing seed data..."
sudo mysql quietspot < Raf/seed_quietspot.sql

echo "Verifying database..."
sudo mysql quietspot -e "SELECT COUNT(*) as locations FROM locations; SELECT COUNT(*) as users FROM users; SELECT COUNT(*) as measurements FROM noise_measurements;"

echo "✅ Database setup complete!"

