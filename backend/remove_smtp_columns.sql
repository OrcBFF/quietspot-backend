USE quietspot;

ALTER TABLE users 
  DROP COLUMN email_verified,
  DROP COLUMN email_verify_token,
  DROP COLUMN email_verify_expires,
  DROP COLUMN password_reset_token,
  DROP COLUMN password_reset_expires;
