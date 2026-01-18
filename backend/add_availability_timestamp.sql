ALTER TABLE locations
ADD COLUMN availability_updated_at DATETIME DEFAULT NULL;

-- Initialize existing unavailable spots with current time (or verify they are available)
UPDATE locations SET availability_updated_at = NOW() WHERE is_available = 0;
