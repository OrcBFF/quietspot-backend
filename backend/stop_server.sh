#!/bin/bash

# Stop QuietSpot API Server

echo "🛑 Stopping QuietSpot API Server..."

# Find and kill processes on port 3000
PID=$(lsof -ti:3000 2>/dev/null)
if [ -n "$PID" ]; then
    echo "Found process $PID on port 3000"
    kill $PID 2>/dev/null
    sleep 1
    # Force kill if still running
    kill -9 $PID 2>/dev/null
    echo "✅ Stopped server on port 3000"
else
    # Try finding node server.js processes
    PID=$(pgrep -f "node.*server.js")
    if [ -n "$PID" ]; then
        echo "Found node server process $PID"
        kill $PID 2>/dev/null
        sleep 1
        kill -9 $PID 2>/dev/null
        echo "✅ Stopped server process"
    else
        echo "ℹ️  No server process found"
    fi
fi

# Verify port is free
sleep 1
if lsof -ti:3000 >/dev/null 2>&1; then
    echo "⚠️  Port 3000 is still in use"
else
    echo "✅ Port 3000 is now free"
fi

