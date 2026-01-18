-- Enhanced seed data for QuietSpot pin freshness and prediction testing
-- Current timestamp reference: 2026-01-18 14:35:00

USE quietspot;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE favorites;
TRUNCATE TABLE noise_measurements;
TRUNCATE TABLE locations;
TRUNCATE TABLE users;
SET FOREIGN_KEY_CHECKS = 1;

START TRANSACTION;

-- USERS (keep existing users)
INSERT INTO users (name, email, password, created_at) VALUES ('Nikos Ioannou', 'user1@example.com', 'password123', '2025-11-16 15:43:38');
INSERT INTO users (name, email, password, created_at) VALUES ('Maria Georgiou', 'user2@example.com', 'password123', '2025-12-06 04:24:38');
INSERT INTO users (name, email, password, created_at) VALUES ('Nikos Papadopoulos', 'user3@example.com', 'password123', '2025-12-06 16:37:38');
INSERT INTO users (name, email, password, created_at) VALUES ('Petros Georgiou', 'user4@example.com', 'password123', '2025-12-14 05:39:38');
INSERT INTO users (name, email, password, created_at) VALUES ('Petros Nikolaou', 'user5@example.com', 'password123', '2025-11-19 08:14:38');
INSERT INTO users (name, email, password, created_at) VALUES ('test', 'tsoukalnick@gmail.com', 'test', '2025-10-10 18:52:38');

-- LOCATIONS
-- Location 1: FRESH DATA (< 60 min) with 5 measurements - should show GREEN border + checkmark
INSERT INTO locations (name, description, latitude, longitude, address, city, postal_code, created_by_user_id, created_at) 
VALUES ('Central Library - FRESH', 'Just measured! Fresh data available', 37.9838, 23.7275, 'Panepistimiou 30', 'Athens', '10679', 1, '2026-01-18 13:00:00');

-- Location 2: LIMITED DATA (15 measurements) - should show GREY + help icon
INSERT INTO locations (name, description, latitude, longitude, address, city, postal_code, created_by_user_id, created_at) 
VALUES ('New Quiet Café - LIMITED', 'New spot with limited data', 37.9750, 23.7350, 'Akadimias 45', 'Athens', '10672', 2, '2026-01-10 10:00:00');

-- Location 3: MODERATE DATA (25 measurements) with temporal pattern - should show AMBER + trending icon
INSERT INTO locations (name, description, latitude, longitude, address, city, postal_code, created_by_user_id, created_at) 
VALUES ('University Garden - MODERATE', 'Moderate data with time patterns', 37.9680, 23.7320, 'Solonos 10', 'Athens', '10671', 3, '2025-12-15 09:00:00');

-- Location 4: CONFIDENT DATA (50+ measurements) with strong temporal patterns - should show BLUE + insights icon
INSERT INTO locations (name, description, latitude, longitude, address, city, postal_code, created_by_user_id, created_at) 
VALUES ('National Museum Reading Room - CONFIDENT', 'Well-known spot with lots of data', 37.9900, 23.7400, 'Patision 44', 'Athens', '10682', 4, '2025-11-01 08:00:00');

-- Location 5: OLD DATA (>60 min) but recent measurement count = 30 - should show MODERATE
INSERT INTO locations (name, description, latitude, longitude, address, city, postal_code, created_by_user_id, created_at) 
VALUES ('Campus Courtyard - MODERATE', 'Moderate data slightly old', 37.9650, 23.7280, 'Hippokratous 15', 'Athens', '10680', 5, '2025-12-01 10:00:00');

-- Location 6: VERY FRESH (< 5 min) with 45 measurements  - should show GREEN border + checkmark
INSERT INTO locations (name, description, latitude, longitude, address, city, postal_code, created_by_user_id, created_at) 
VALUES ('City Park Bench - VERY FRESH', 'Just measured moments ago!', 37.9720, 23.7260, 'Vasilissis Sofias 1', 'Athens', '10674', 1, '2026-01-18 14:00:00');

-- ==========================================
-- NOISE MEASUREMENTS
-- ==========================================

-- Location 1: FRESH DATA (< 60 min) - 5 recent measurements only
-- These should trigger DataFreshness.fresh
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (1, 1, 35.2, NOW() - INTERVAL 10 MINUTE);
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (1, 2, 36.8, NOW() - INTERVAL 25 MINUTE);
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (1, 3, 34.5, NOW() - INTERVAL 35 MINUTE);
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (1, 4, 37.1, NOW() - INTERVAL 48 MINUTE);
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (1, 5, 35.9, NOW() - INTERVAL 55 MINUTE);

-- Location 2: LIMITED DATA (15 measurements, scattered randomly)
-- These should trigger DataFreshness.predictedLimited (N < 20)
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (2, 1, 42.3, '2026-01-17 10:15:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (2, 2, 43.1, '2026-01-16 14:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (2, 3, 41.8, '2026-01-15 09:20:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (2, 4, 44.2, '2026-01-14 16:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (2, 5, 42.9, '2026-01-13 11:10:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (2, 1, 43.5, '2026-01-12 15:25:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (2, 2, 41.2, '2026-01-11 08:40:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (2, 3, 45.1, '2026-01-10 13:55:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (2, 4, 42.7, '2026-01-09 17:20:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (2, 5, 44.8, '2026-01-08 10:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (2, 1, 43.3, '2026-01-07 14:15:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (2, 2, 41.9, '2026-01-06 09:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (2, 3, 42.5, '2026-01-05 16:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (2, 4, 44.0, '2026-01-04 11:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (2, 5, 43.6, '2026-01-03 15:20:00');

-- Location 3: MODERATE DATA (25 measurements with TEMPORAL PATTERNS)
-- These should trigger DataFreshness.predictedModerate (20 ≤ N < 40)
-- Pattern: Quieter in mornings (6-12), louder in afternoons (12-18)
-- Weekday measurements
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 1, 38.5, '2026-01-13 08:30:00'); -- Monday morning
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 2, 39.2, '2026-01-13 14:45:00'); -- Monday afternoon
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 3, 37.8, '2026-01-14 09:15:00'); -- Tuesday morning
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 4, 41.3, '2026-01-14 15:30:00'); -- Tuesday afternoon
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 5, 38.1, '2026-01-15 07:45:00'); -- Wednesday morning
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 1, 42.5, '2026-01-15 16:20:00'); -- Wednesday afternoon
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 2, 37.3, '2026-01-16 08:00:00'); -- Thursday morning
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 3, 40.8, '2026-01-16 13:50:00'); -- Thursday afternoon
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 4, 38.9, '2026-01-17 09:30:00'); -- Friday morning
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 5, 41.7, '2026-01-17 14:15:00'); -- Friday afternoon
-- Week 2 (more recent - last 14 days get 2x weight)
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 1, 37.5, '2026-01-06 08:45:00'); -- Monday morning
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 2, 42.1, '2026-01-06 15:00:00'); -- Monday afternoon
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 3, 38.4, '2026-01-07 09:00:00'); -- Tuesday morning
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 4, 40.5, '2026-01-07 14:30:00'); -- Tuesday afternoon
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 5, 37.9, '2026-01-08 08:20:00'); -- Wednesday morning
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 1, 41.9, '2026-01-08 16:45:00'); -- Wednesday afternoon
-- Older data (> 2 weeks ago)
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 2, 39.1, '2025-12-30 09:15:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 3, 43.2, '2025-12-30 15:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 4, 38.7, '2025-12-29 08:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 5, 40.3, '2025-12-29 14:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 1, 37.6, '2025-12-28 09:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 2, 42.8, '2025-12-28 16:15:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 3, 38.2, '2025-12-27 08:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 4, 41.4, '2025-12-27 15:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (3, 5, 39.5, '2025-12-26 09:20:00');

-- Location 4: CONFIDENT DATA (50 measurements with STRONG TEMPORAL PATTERNS)
-- These should trigger DataFreshness.predictedConfident (N ≥ 40)
-- Pattern: Very quiet mornings, moderate afternoons, quieter on weekends
-- Last 14 days - Weekdays
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 1, 32.5, '2026-01-13 08:00:00'); -- Mon morning (quiet)
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 2, 45.2, '2026-01-13 14:30:00'); -- Mon afternoon (loud)
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 3, 33.1, '2026-01-14 09:15:00'); -- Tue morning
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 4, 44.8, '2026-01-14 15:45:00'); -- Tue afternoon
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 5, 32.8, '2026-01-15 08:30:00'); -- Wed morning
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 1, 46.1, '2026-01-15 16:00:00'); -- Wed afternoon
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 2, 33.5, '2026-01-16 09:00:00'); -- Thu morning
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 3, 45.5, '2026-01-16 14:15:00'); -- Thu afternoon
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 4, 32.2, '2026-01-17 08:45:00'); -- Fri morning
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 5, 44.3, '2026-01-17 15:30:00'); -- Fri afternoon
-- Last 14 days - Weekend (quieter overall)
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 1, 30.5, '2026-01-11 09:00:00'); -- Sat morning
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 2, 38.2, '2026-01-11 14:30:00'); -- Sat afternoon
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 3, 31.1, '2026-01-12 10:15:00'); -- Sun morning
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 4, 37.5, '2026-01-12 15:00:00'); -- Sun afternoon
-- Last 30 days (1x weight) - Weekdays
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 5, 33.2, '2026-01-06 08:20:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 1, 46.8, '2026-01-06 16:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 2, 32.9, '2026-01-07 09:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 3, 45.1, '2026-01-07 14:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 4, 33.7, '2026-01-08 08:15:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 5, 44.9, '2026-01-08 15:20:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 1, 32.4, '2026-01-09 09:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 2, 46.3, '2026-01-09 16:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 3, 33.0, '2026-01-10 08:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 4, 45.7, '2026-01-10 14:45:00');
-- Last 30 days - Weekends
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 5, 31.2, '2026-01-04 10:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 1, 36.8, '2026-01-04 15:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 2, 30.9, '2026-01-05 09:15:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 3, 37.9, '2026-01-05 14:00:00');
-- More historical data (15-30 days ago) - Weekdays
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 4, 32.7, '2025-12-30 08:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 5, 45.4, '2025-12-30 16:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 1, 33.3, '2025-12-29 09:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 2, 46.0, '2025-12-29 15:15:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 3, 32.1, '2025-12-28 08:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 4, 44.7, '2025-12-28 14:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 5, 33.8, '2025-12-27 09:20:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 1, 45.9, '2025-12-27 16:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 2, 32.6, '2025-12-26 08:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 3, 46.2, '2025-12-26 15:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 4, 33.4, '2025-12-25 09:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 5, 44.5, '2025-12-25 14:15:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 1, 32.3, '2025-12-24 08:20:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 2, 45.6, '2025-12-24 16:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 3, 33.1, '2025-12-23 09:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 4, 46.4, '2025-12-23 15:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 5, 32.9, '2025-12-22 08:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (4, 1, 44.8, '2025-12-22 14:00:00');

-- Location 5: MODERATE DATA (30 measurements, stale but not too old)
-- Last measurement > 60 min ago, should be predictedModerate
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 1, 40.5, NOW() - INTERVAL 2 HOUR);
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 2, 41.2, NOW() - INTERVAL 3 HOUR);
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 3, 39.8, '2026-01-17 10:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 4, 42.3, '2026-01-17 14:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 5, 40.1, '2026-01-16 09:15:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 1, 43.5, '2026-01-16 15:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 2, 39.3, '2026-01-15 08:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 3, 41.8, '2026-01-15 16:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 4, 40.7, '2026-01-14 10:20:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 5, 42.9, '2026-01-14 14:50:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 1, 39.5, '2026-01-13 09:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 2, 41.4, '2026-01-13 15:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 3, 40.9, '2026-01-12 08:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 4, 43.1, '2026-01-12 16:15:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 5, 39.7, '2026-01-11 10:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 1, 42.2, '2026-01-11 14:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 2, 40.3, '2026-01-10 09:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 3, 41.7, '2026-01-10 15:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 4, 39.9, '2026-01-09 08:15:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 5, 43.4, '2026-01-09 16:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 1, 40.6, '2026-01-08 10:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 2, 42.0, '2026-01-08 14:20:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 3, 39.4, '2026-01-07 09:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 4, 41.5, '2026-01-07 15:40:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 5, 40.8, '2026-01-06 08:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 1, 42.7, '2026-01-06 16:10:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 2, 39.6, '2026-01-05 10:15:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 3, 41.9, '2026-01-05 14:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 4, 40.2, '2026-01-04 09:20:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (5, 5, 43.0, '2026-01-04 15:50:00');

-- Location 6: VERY FRESH (< 5 min) with CONFIDENT data (45 measurements)
-- Should show GREEN border + checkmark despite having many measurements
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 1, 28.5, NOW() - INTERVAL 2 MINUTE); -- VERY FRESH!
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 2, 29.1, NOW() - INTERVAL 4 MINUTE);
-- Historical data for this location
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 3, 30.2, '2026-01-17 08:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 4, 35.5, '2026-01-17 14:15:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 5, 29.8, '2026-01-16 09:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 1, 36.2, '2026-01-16 15:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 2, 30.5, '2026-01-15 08:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 3, 34.8, '2026-01-15 16:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 4, 29.3, '2026-01-14 10:20:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 5, 35.9, '2026-01-14 14:50:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 1, 30.7, '2026-01-13 09:15:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 2, 36.4, '2026-01-13 15:40:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 3, 29.5, '2026-01-12 08:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 4, 34.1, '2026-01-12 16:30:00');
-- Continue with more historical data (30 more to reach 45 total)
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 5, 30.9, '2026-01-11 10:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 1, 35.7, '2026-01-11 14:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 2, 29.1, '2026-01-10 09:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 3, 36.0, '2026-01-10 15:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 4, 30.3, '2026-01-09 08:15:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 5, 34.6, '2026-01-09 16:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 1, 29.7, '2026-01-08 10:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 2, 35.3, '2026-01-08 14:20:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 3, 30.6, '2026-01-07 09:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 4, 36.1, '2026-01-07 15:40:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 5, 29.4, '2026-01-06 08:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 1, 34.9, '2026-01-06 16:10:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 2, 30.8, '2026-01-05 10:15:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 3, 35.5, '2026-01-05 14:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 4, 29.9, '2026-01-04 09:20:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 5, 36.3, '2026-01-04 15:50:00');
-- More historical
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 1, 30.1, '2025-12-30 08:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 2, 34.7, '2025-12-30 14:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 3, 29.6, '2025-12-29 09:30:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 4, 35.8, '2025-12-29 15:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 5, 30.4, '2025-12-28 10:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 1, 36.2, '2025-12-28 16:00:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 2, 29.8, '2025-12-27 08:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 3, 34.5, '2025-12-27 14:15:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 4, 30.7, '2025-12-26 09:20:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 5, 35.1, '2025-12-26 15:45:00');
INSERT INTO noise_measurements (location_id, user_id, db_value, measured_at) VALUES (6, 1, 29.2, '2025-12-25 10:30:00');

-- Update location aggregate data
UPDATE locations l
SET
    avg_db = (
        SELECT AVG(nm.db_value)
        FROM noise_measurements nm
        WHERE nm.location_id = l.location_id
    ),
    measurements_count = (
        SELECT COUNT(*)
        FROM noise_measurements nm2
        WHERE nm2.location_id = l.location_id
    );

COMMIT;

-- ==========================================
-- SUMMARY OF TEST DATA
-- ==========================================
-- Location 1: 5 measurements, all < 60 min old → FRESH (Green border + checkmark)
-- Location 2: 15 measurements (< 20) → LIMITED DATA (Grey + help icon)
-- Location 3: 25 measurements (20-39) with time patterns → MODERATE (Amber + trending icon)
-- Location 4: 50 measurements (≥ 40) with strong patterns → CONFIDENT (Blue + insights icon)
-- Location 5: 30 measurements (20-39), > 60 min old → MODERATE (Amber + trending icon)
-- Location 6: 45 measurements (≥ 40) BUT < 5 min fresh → FRESH (Green border + checkmark)
