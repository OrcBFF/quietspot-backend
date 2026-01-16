#!/bin/bash

# Start QuietSpot Backend API Server

cd "$(dirname "$0")"

echo "🚀 Starting QuietSpot API Server..."
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found. Creating from .env.example..."
    cp .env.example .env 2>/dev/null || {
        echo "❌ Error: .env.example not found"
        exit 1
    }
    echo "✅ Created .env file. Please edit it with your database credentials."
fi

# Check if node_modules exists
if [ ! -d node_modules ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Check database connection
echo "🔍 Checking database connection..."
node -e "
const mysql = require('mysql2/promise');
require('dotenv').config();

(async () => {
    try {
        const connection = await mysql.createConnection({
            host: process.env.DB_HOST || '127.0.0.1', // Use IPv4 explicitly
            user: process.env.DB_USER || 'root',
            password: process.env.DB_PASSWORD || '',
            database: process.env.DB_NAME || 'quietspot',
        });
        await connection.query('SELECT 1');
        await connection.end();
        console.log('✅ Database connection successful');
    } catch (error) {
        console.error('❌ Database connection failed:', error.message);
        console.log('');
        console.log('💡 Make sure:');
        console.log('   1. MySQL is running: sudo systemctl status mysql');
        console.log('   2. Database exists: sudo mysql -e \"SHOW DATABASES LIKE \\\"quietspot\\\";\"');
        console.log('   3. .env file has correct credentials');
        process.exit(1);
    }
})();
" || exit 1

echo ""
echo "🌐 Starting API server on http://localhost:${PORT:-3000}"
echo "📡 API will be available at http://localhost:${PORT:-3000}/api"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Start the server
npm start

