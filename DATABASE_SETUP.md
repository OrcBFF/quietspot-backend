# Database Integration Setup Guide

## Overview

The QuietSpot app now uses a MySQL database backend instead of local storage. This guide will help you set up everything.

## Prerequisites

1. **Node.js** (v14 or higher) - [Download](https://nodejs.org/)
2. **MySQL** (v5.7 or higher) - [Download](https://dev.mysql.com/downloads/)
3. **Flutter** (already installed)

## Step 1: Set Up MySQL Database

1. **Start MySQL server:**
   ```bash
   # On Linux/Mac
   sudo systemctl start mysql
   # Or
   sudo service mysql start
   ```

2. **Create the database:**
   ```bash
   mysql -u root -p < Raf/quietspot.sql
   mysql -u root -p < Raf/seed_quietspot.sql
   ```

   Or manually:
   ```sql
   mysql -u root -p
   source Raf/quietspot.sql;
   source Raf/seed_quietspot.sql;
   ```

## Step 2: Set Up Backend API

1. **Navigate to backend directory:**
   ```bash
   cd "Φάση 3 - QuietSpot/backend"
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Configure environment:**
   ```bash
   cp .env.example .env
   ```

4. **Edit `.env` file with your database credentials:**
   ```
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=your_mysql_password
   DB_NAME=quietspot
   DB_PORT=3306
   PORT=3000
   ```

5. **Start the API server:**
   ```bash
   npm start
   # Or for development with auto-reload:
   npm run dev
   ```

   You should see: `🚀 QuietSpot API server running on http://localhost:3000`

## Step 3: Configure Flutter App

The Flutter app needs to know where the API is running.

### For Android Emulator:
- Use: `http://10.0.2.2:3000`
- This is the special IP that points to your host machine's localhost

### For Physical Android Device:
- Find your computer's IP address:
  ```bash
  # Linux/Mac
  ip addr show | grep "inet " | grep -v 127.0.0.1
  # Or
  hostname -I
  ```
- Use: `http://YOUR_IP_ADDRESS:3000` (e.g., `http://192.168.1.100:3000`)
- Make sure your phone and computer are on the same WiFi network

### For iOS Simulator:
- Use: `http://localhost:3000`

### Setting the API URL:

**Option 1: Build-time (Recommended)**
```bash
flutter run \
  --dart-define=API_BASE_URL=http://10.0.2.2:3000 \
  --dart-define=MAPBOX_ACCESS_TOKEN=pk.your_token_here
```

**Option 2: Edit the code directly**
Edit `lib/services/api_service.dart` and change:
```dart
static const String baseUrl = 'http://10.0.2.2:3000'; // For Android emulator
// Or
static const String baseUrl = 'http://192.168.1.100:3000'; // For physical device
```

## Step 4: Test the Setup

1. **Test API health:**
   ```bash
   curl http://localhost:3000/api/health
   ```
   Should return: `{"status":"ok","message":"QuietSpot API is running"}`

2. **Test from Flutter app:**
   - Run the app
   - Check if spots load from the database
   - Try creating a new spot
   - Check if it appears in the database

## Troubleshooting

### Database Connection Issues

**Error: "ER_ACCESS_DENIED_ERROR"**
- Check your MySQL username and password in `.env`
- Make sure MySQL is running: `sudo systemctl status mysql`

**Error: "ER_BAD_DB_ERROR"**
- Database doesn't exist. Run: `mysql -u root -p < Raf/quietspot.sql`

### API Connection Issues

**Error: "Network error" in Flutter**
- Check if API server is running: `curl http://localhost:3000/api/health`
- Check API URL in Flutter app matches your setup
- For physical device: Ensure phone and computer are on same WiFi
- Check firewall isn't blocking port 3000

**Error: "Connection refused"**
- API server not running. Start it: `cd backend && npm start`
- Wrong IP address. Check your computer's IP

### Data Not Loading

- Check browser/Postman: `http://localhost:3000/api/locations`
- Should return JSON array of locations
- If empty, seed data might not be loaded: `mysql -u root -p < Raf/seed_quietspot.sql`

## API Endpoints

- `GET /api/locations` - Get all spots
- `POST /api/locations` - Create spot
- `PUT /api/locations/:id` - Update spot
- `DELETE /api/locations/:id` - Delete spot
- `GET /api/measurements/location/:id` - Get measurements
- `POST /api/measurements` - Create measurement
- `GET /api/favorites/user/:userId` - Get favorites
- `POST /api/favorites` - Add favorite
- `GET /api/health` - Health check

## Development Tips

1. **Use `npm run dev`** for auto-reload when editing backend code
2. **Check API logs** in the terminal running `npm start`
3. **Use Postman or curl** to test API endpoints directly
4. **Check Flutter console** for network errors

## Production Deployment

For production, you'll need to:
1. Deploy backend to a server (Heroku, AWS, etc.)
2. Update API_BASE_URL to production URL
3. Set up proper database credentials
4. Enable HTTPS
5. Add authentication/authorization

