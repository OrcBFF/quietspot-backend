# Troubleshooting MySQL Connection Issues

## Error: `connect ECONNREFUSED ::1:3306`

This means the connection is trying to use IPv6. Fixed by using `127.0.0.1` instead of `localhost` in `.env`.

## Error: `Access denied for user 'root'@'localhost'`

MySQL 8.0+ uses `auth_socket` plugin by default. Fix it with one of these methods:

### Option 1: Allow root without password (for development)

```bash
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';"
sudo mysql -e "FLUSH PRIVILEGES;"
```

### Option 2: Set a password for root

```bash
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_password';"
sudo mysql -e "FLUSH PRIVILEGES;"
```

Then update `backend/.env`:
```
DB_PASSWORD=your_password
```

### Option 3: Create a dedicated database user (recommended for production)

```bash
sudo mysql <<EOF
CREATE USER 'quietspot'@'localhost' IDENTIFIED BY 'quietspot123';
GRANT ALL PRIVILEGES ON quietspot.* TO 'quietspot'@'localhost';
FLUSH PRIVILEGES;
EOF
```

Then update `backend/.env`:
```
DB_USER=quietspot
DB_PASSWORD=quietspot123
```

## Test Connection

After fixing authentication, test:

```bash
cd backend
node -e "const mysql = require('mysql2/promise'); require('dotenv').config(); (async () => { try { const conn = await mysql.createConnection({host: '127.0.0.1', user: process.env.DB_USER, password: process.env.DB_PASSWORD, database: 'quietspot'}); await conn.query('SELECT 1'); await conn.end(); console.log('✅ Success'); } catch(e) { console.log('❌ Error:', e.message); } })();"
```

## Check MySQL Status

```bash
sudo systemctl status mysql
sudo systemctl start mysql  # if not running
```

## Verify Database Exists

```bash
sudo mysql -e "SHOW DATABASES LIKE 'quietspot';"
sudo mysql -e "USE quietspot; SHOW TABLES;"
```

