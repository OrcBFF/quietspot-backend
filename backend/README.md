# QuietSpot Backend API

REST API server for the QuietSpot Flutter application using Node.js, Express, and MySQL.

## Prerequisites

- Node.js (v14 or higher)
- MySQL (v5.7 or higher)
- MySQL database created (see `../Raf/quietspot.sql`)

## Setup

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Configure database:**
   - Copy `.env.example` to `.env`
   - Update database credentials in `.env`:
     ```
     DB_HOST=localhost
     DB_USER=root
     DB_PASSWORD=your_password
     DB_NAME=quietspot
     DB_PORT=3306
     ```

3. **Create database:**
   ```bash
   mysql -u root -p < ../Raf/quietspot.sql
   mysql -u root -p < ../Raf/seed_quietspot.sql
   ```

4. **Start server:**
   ```bash
   npm start
   # Or for development with auto-reload:
   npm run dev
   ```

The API will be available at `http://localhost:3000`

## API Endpoints

### Locations (Spots)
- `GET /api/locations` - Get all locations
- `GET /api/locations/:id` - Get single location
- `POST /api/locations` - Create new location
- `PUT /api/locations/:id` - Update location
- `DELETE /api/locations/:id` - Delete location

### Measurements
- `GET /api/measurements/location/:locationId` - Get measurements for a location
- `POST /api/measurements` - Create new measurement
- `GET /api/measurements/nearby?latitude=X&longitude=Y&radiusMeters=100` - Get nearby measurements

### Favorites
- `GET /api/favorites/user/:userId` - Get user's favorites
- `POST /api/favorites` - Add favorite
- `DELETE /api/favorites/:userId/:locationId` - Remove favorite
- `GET /api/favorites/check/:userId/:locationId` - Check if favorited

### Users
- `GET /api/users` - Get all users
- `GET /api/users/:id` - Get single user
- `POST /api/users` - Create new user

### Health Check
- `GET /api/health` - Check API status

## Environment Variables

- `DB_HOST` - MySQL host (default: localhost)
- `DB_USER` - MySQL user (default: root)
- `DB_PASSWORD` - MySQL password
- `DB_NAME` - Database name (default: quietspot)
- `DB_PORT` - MySQL port (default: 3306)
- `PORT` - API server port (default: 3000)

