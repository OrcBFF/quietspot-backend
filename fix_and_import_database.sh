#!/bin/bash

# Fix and import QuietSpot database
# This script will drop and recreate the database

cd "/home/aragorn/projects/projectHCI (copy)"

echo "Dropping existing database (if any)..."
sudo mysql -e "DROP DATABASE IF EXISTS quietspot;"

echo "Importing database schema..."
sudo mysql < Raf/quietspot.sql

echo "Importing seed data..."
sudo mysql quietspot < Raf/seed_quietspot.sql

echo "Verifying database..."
sudo mysql quietspot -e "SELECT COUNT(*) as locations FROM locations; SELECT COUNT(*) as users FROM users; SELECT COUNT(*) as measurements FROM noise_measurements;"

echo "✅ Database setup complete!"

