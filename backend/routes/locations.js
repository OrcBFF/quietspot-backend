const express = require('express');
const router = express.Router();
const db = require('../db');

// Get all locations (spots)
router.get('/', async (req, res) => {
  try {
    const [rows] = await db.execute(`
      SELECT 
        l.location_id as id,
        l.name,
        l.description,
        l.latitude,
        l.longitude,
        l.address as location,
        l.city,
        l.postal_code,
        l.avg_db as noiseDb,
        l.measurements_count,
        l.place_type,
        l.created_by_user_id,
        l.created_at,
        (SELECT MAX(measured_at) FROM noise_measurements WHERE location_id = l.location_id) as last_updated
      FROM locations l
      ORDER BY l.created_at DESC
    `);

    // Convert to QuietSpot format
    const spots = rows.map(row => ({
      id: row.id.toString(),
      name: row.name,
      location: row.location || `${row.latitude}, ${row.longitude}`,
      description: row.description || '',
      noiseLevel: row.noiseDb ? Math.min(5, Math.max(1, Math.round((row.noiseDb - 20) / 15))) : 3,
      noiseDb: row.noiseDb ? parseFloat(row.noiseDb) : null,
      placeType: row.place_type || 'other',
      latitude: parseFloat(row.latitude),
      longitude: parseFloat(row.longitude),
      measurementCount: row.measurements_count || 0,
      lastUpdated: row.last_updated ? row.last_updated.toISOString() : null,
    }));

    res.json(spots);
  } catch (error) {
    console.error('Error fetching locations:', error);
    res.status(500).json({ error: 'Failed to fetch locations' });
  }
});

// Get single location by ID
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await db.execute(`
      SELECT 
        location_id as id,
        name,
        description,
        latitude,
        longitude,
        address as location,
        city,
        postal_code,
        avg_db as noiseDb,
        measurements_count,
        place_type,
        created_by_user_id,
        created_at
      FROM locations
      WHERE location_id = ?
    `, [req.params.id]);

    if (rows.length === 0) {
      return res.status(404).json({ error: 'Location not found' });
    }

    const row = rows[0];
    const spot = {
      id: row.id.toString(),
      name: row.name,
      location: row.location || `${row.latitude}, ${row.longitude}`,
      description: row.description || '',
      noiseLevel: row.noiseDb ? Math.min(5, Math.max(1, Math.round((row.noiseDb - 20) / 15))) : 3,
      noiseDb: row.noiseDb ? parseFloat(row.noiseDb) : null,
      placeType: row.place_type || 'other',
      latitude: parseFloat(row.latitude),
      longitude: parseFloat(row.longitude),
    };

    res.json(spot);
  } catch (error) {
    console.error('Error fetching location:', error);
    res.status(500).json({ error: 'Failed to fetch location' });
  }
});

// Create new location
router.post('/', async (req, res) => {
  try {
    const { name, description, latitude, longitude, location, noiseLevel, noiseDb } = req.body;

    if (!name || latitude === undefined || longitude === undefined) {
      return res.status(400).json({ error: 'Name, latitude, and longitude are required' });
    }

    // Use default user_id = NULL if not valid integer (Guest)
    let userId = req.body.userId;
    if (!Number.isInteger(userId)) {
      userId = null;
    } else {
      // Verify user exists
      const [userCheck] = await db.execute('SELECT user_id FROM users WHERE user_id = ?', [userId]);
      if (userCheck.length === 0) {
        userId = null;
      }
    }

    let newId;

    // 1. Check for existing location within 20m
    const [existingCoords] = await db.execute(`
      SELECT location_id 
      FROM locations 
      WHERE (
        6371000 * acos(
          cos(radians(?)) * cos(radians(latitude)) *
          cos(radians(longitude) - radians(?)) +
          sin(radians(?)) * sin(radians(latitude))
        )
      ) <= 20
      LIMIT 1
    `, [latitude, longitude, latitude]);

    if (existingCoords.length > 0) {
      newId = existingCoords[0].location_id;
    } else if (location) {
      // 2. Fallback: Check by exact address string
      const [existingAddr] = await db.execute(
        'SELECT location_id FROM locations WHERE address = ? LIMIT 1',
        [location]
      );
      if (existingAddr.length > 0) {
        newId = existingAddr[0].location_id;
      }
    }

    // Default placeType
    const pType = req.body.placeType || 'other';

    if (!newId) {
      // Create NEW location if no match found
      const [result] = await db.execute(`
        INSERT INTO locations (name, description, latitude, longitude, address, created_by_user_id, place_type)
        VALUES (?, ?, ?, ?, ?, ?, ?)
      `, [name, description || '', latitude, longitude, location || '', userId, pType]);
      newId = result.insertId;
    }

    // If noise measurement provided, add it
    if (noiseDb !== null && noiseDb !== undefined) {
      await db.execute(`
        INSERT INTO noise_measurements (location_id, user_id, db_value)
        VALUES (?, ?, ?)
      `, [newId, userId, noiseDb]);
    }

    // Fetch the location (created or existing)
    const [rows] = await db.execute(`
      SELECT 
        location_id as id,
        name,
        description,
        latitude,
        longitude,
        address as location,
        avg_db as noiseDb,
        place_type,
        created_by_user_id
      FROM locations
      WHERE location_id = ?
    `, [newId]);

    const row = rows[0];
    const spot = {
      id: row.id.toString(),
      name: row.name,
      location: row.location || `${row.latitude}, ${row.longitude}`,
      description: row.description || '',
      noiseLevel: row.noiseDb ? Math.min(5, Math.max(1, Math.round((row.noiseDb - 20) / 15))) : (noiseLevel || 3),
      noiseDb: row.noiseDb ? parseFloat(row.noiseDb) : (noiseDb || null),
      placeType: row.place_type || 'other',
      latitude: parseFloat(row.latitude),
      longitude: parseFloat(row.longitude),
    };

    // Return 200 OK if existing, 201 Created if new (simplified to 200 for consistency or dynamic)
    res.json(spot);
  } catch (error) {
    console.error('Error creating location:', error);
    res.status(500).json({ error: 'Failed to create location' });
  }
});

// Update location
router.put('/:id', async (req, res) => {
  try {
    const { name, description, latitude, longitude, location, noiseLevel, noiseDb } = req.body;

    const updates = [];
    const values = [];

    if (name !== undefined) {
      updates.push('name = ?');
      values.push(name);
    }
    if (description !== undefined) {
      updates.push('description = ?');
      values.push(description);
    }
    if (latitude !== undefined) {
      updates.push('latitude = ?');
      values.push(latitude);
    }
    if (longitude !== undefined) {
      updates.push('longitude = ?');
      values.push(longitude);
    }
    if (location !== undefined) {
      updates.push('address = ?');
      values.push(location);
    }

    if (updates.length > 0) {
      values.push(req.params.id);

      await db.execute(`
        UPDATE locations
        SET ${updates.join(', ')}
        WHERE location_id = ?
      `, values);
    }

    // If noiseDb is provided, add as new measurement (even if no other updates)
    if (noiseDb !== null && noiseDb !== undefined) {
      let userId = req.body.userId;
      if (!Number.isInteger(userId)) {
        userId = null;
      } else {
        // Verify user exists
        const [userCheck] = await db.execute('SELECT user_id FROM users WHERE user_id = ?', [userId]);
        if (userCheck.length === 0) {
          userId = null;
        }
      }

      await db.execute(`
        INSERT INTO noise_measurements (location_id, user_id, db_value)
        VALUES (?, ?, ?)
      `, [req.params.id, userId, noiseDb]);
    } else if (updates.length === 0) {
      // If no updates and no new measurement, verify file exists and return it
      // Or could return error, but fetching the location is safer side effect
    }

    // Fetch updated location
    const [rows] = await db.execute(`
      SELECT 
        location_id as id,
        name,
        description,
        latitude,
        longitude,
        address as location,
        avg_db as noiseDb,
        place_type
      FROM locations
      WHERE location_id = ?
    `, [req.params.id]);

    if (rows.length === 0) {
      return res.status(404).json({ error: 'Location not found' });
    }

    const row = rows[0];
    const spot = {
      id: row.id.toString(),
      name: row.name,
      location: row.location || `${row.latitude}, ${row.longitude}`,
      description: row.description || '',
      noiseLevel: row.noiseDb ? Math.min(5, Math.max(1, Math.round((row.noiseDb - 20) / 15))) : (noiseLevel || 3),
      noiseDb: row.noiseDb ? parseFloat(row.noiseDb) : (noiseDb || null),
      placeType: row.place_type || 'other',
      latitude: parseFloat(row.latitude),
      longitude: parseFloat(row.longitude),
    };

    res.json(spot);
  } catch (error) {
    console.error('Error updating location:', error);
    res.status(500).json({ error: 'Failed to update location' });
  }
});

// Delete location
router.delete('/:id', async (req, res) => {
  try {
    const [result] = await db.execute(`
      DELETE FROM locations
      WHERE location_id = ?
    `, [req.params.id]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Location not found' });
    }

    res.json({ message: 'Location deleted successfully' });
  } catch (error) {
    console.error('Error deleting location:', error);
    res.status(500).json({ error: 'Failed to delete location' });
  }
});

module.exports = router;

