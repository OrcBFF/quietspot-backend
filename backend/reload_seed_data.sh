#!/bin/bash

# Script to clear old data and load new seed data for QuietSpot
# TiDB is MySQL-compatible, so we can use mysql command

# Database credentials from .env
DB_HOST="127.0.0.1"
DB_USER="root"
DB_PASSWORD=""
DB_NAME="quietspot"
DB_PORT="3306"

echo "🗑️  Clearing old data from QuietSpot database..."

# Execute the new seed file which already includes TRUNCATE commands
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" ${DB_PASSWORD:+-p"$DB_PASSWORD"} "$DB_NAME" < seed_data_freshness_test.sql

if [ $? -eq 0 ]; then
    echo "✅ Successfully loaded new seed data!"
    echo ""
    echo "📊 Summary of test data loaded:"
    echo "  - Location 1: Central Library (FRESH - 5 measurements, <10 min old)"
    echo "  - Location 2: New Quiet Café (LIMITED - 15 measurements)"
    echo "  - Location 3: University Garden (MODERATE - 25 measurements with time patterns)"
    echo "  - Location 4: National Museum (CONFIDENT - 50 measurements with strong patterns)"
    echo "  - Location 5: Campus Courtyard (MODERATE - 30 measurements, 2 hours old)"
    echo "  - Location 6: City Park (VERY FRESH - 45 measurements, <2 min old)"
    echo ""
    echo "🔄 Restart your Flutter app to see the new pins!"
else
    echo "❌ Error loading seed data. Check your TiDB connection."
    exit 1
fi
