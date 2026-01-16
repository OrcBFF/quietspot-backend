# Quick Setup Instructions

## Step 1: Install and Set Up MySQL

Run the setup script:

```bash
cd "/home/aragorn/projects/projectHCI (copy)/Φάση 3 - QuietSpot"
./setup_mysql.sh
```

**OR manually:**

```bash
# Install MySQL
sudo apt-get update
sudo apt-get install -y mysql-server

# Start MySQL
sudo systemctl start mysql
sudo systemctl enable mysql

# Create database
sudo mysql < Raf/quietspot.sql
sudo mysql < Raf/seed_quietspot.sql
```

## Step 2: Configure Backend

```bash
cd backend
npm install
cp .env.example .env
```

Edit `backend/.env`:
```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=quietspot
DB_PORT=3306
PORT=3000
```

**Note:** If you set a MySQL root password, update `DB_PASSWORD` in `.env`.

## Step 3: Start Backend API

```bash
cd backend
npm start
```

You should see: `🚀 QuietSpot API server running on http://localhost:3000`

## Step 4: Run Flutter App

```bash
cd quietspot

# For Android Emulator:
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000 --dart-define=MAPBOX_ACCESS_TOKEN=pk.your_token_here

# For Physical Device (replace with your computer's IP):
flutter run --dart-define=API_BASE_URL=http://192.168.1.100:3000 --dart-define=MAPBOX_ACCESS_TOKEN=pk.your_token_here
```

## Finding Your Computer's IP Address

For physical device testing:

```bash
# Linux
hostname -I
# Or
ip addr show | grep "inet " | grep -v 127.0.0.1
```

## Troubleshooting

### MySQL Connection Issues

**Check if MySQL is running:**
```bash
sudo systemctl status mysql
```

**Test MySQL connection:**
```bash
sudo mysql -e "SELECT VERSION();"
```

**Check if database exists:**
```bash
sudo mysql -e "SHOW DATABASES;"
```

**Check database content:**
```bash
sudo mysql -e "USE quietspot; SELECT COUNT(*) FROM locations;"
```

### API Connection Issues

**Test API health:**
```bash
curl http://localhost:3000/api/health
```

**Check API logs** in the terminal where you ran `npm start`

### Flutter App Issues

**Check API URL:**
- Android Emulator: Must use `http://10.0.2.2:3000`
- Physical Device: Must use your computer's IP (e.g., `http://192.168.1.100:3000`)
- Both devices must be on the same WiFi network

**Check Flutter console** for network errors

