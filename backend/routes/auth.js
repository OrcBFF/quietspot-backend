const express = require('express');
const router = express.Router();
const db = require('../db');
const { Resend } = require('resend');

// Initialize Resend with API key from environment variable
const resend = new Resend(process.env.RESEND_API_KEY);

// Log email configuration status on startup
if (process.env.RESEND_API_KEY) {
    console.log('✅ Resend email service configured');
} else {
    console.log('⚠️  RESEND_API_KEY not set - emails will be logged to console');
}

// Helper function to send password reset email
async function sendPasswordResetEmail(toEmail, userName, resetCode) {
    const { data, error } = await resend.emails.send({
        from: 'QuietSpot <onboarding@resend.dev>',
        to: toEmail,
        subject: 'Password Reset Code - QuietSpot',
        html: `
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
                <div style="text-align: center; margin-bottom: 30px;">
                    <h1 style="color: #4CAF50; margin: 0;">QuietSpot</h1>
                    <p style="color: #666; margin: 5px 0;">Find Your Quiet Place</p>
                </div>
                
                <div style="background: #f5f5f5; border-radius: 10px; padding: 30px; text-align: center;">
                    <h2 style="color: #333; margin-top: 0;">Password Reset</h2>
                    <p style="color: #666;">Hi ${userName},</p>
                    <p style="color: #666;">You requested to reset your password. Use the code below:</p>
                    
                    <div style="background: #4CAF50; color: white; font-size: 32px; font-weight: bold; letter-spacing: 8px; padding: 20px 40px; border-radius: 10px; display: inline-block; margin: 20px 0;">
                        ${resetCode}
                    </div>
                    
                    <p style="color: #999; font-size: 14px;">This code expires in <strong>5 minutes</strong>.</p>
                    <p style="color: #999; font-size: 14px;">If you didn't request this, please ignore this email.</p>
                </div>
                
                <div style="text-align: center; margin-top: 30px; color: #999; font-size: 12px;">
                    <p>© 2026 QuietSpot App</p>
                </div>
            </div>
        `
    });

    if (error) {
        throw new Error(error.message);
    }
    return data;
}

// Helper function to send email verification code
async function sendVerificationEmail(toEmail, userName, verifyCode) {
    const { data, error } = await resend.emails.send({
        from: 'QuietSpot <onboarding@resend.dev>',
        to: toEmail,
        subject: 'Verify Your Email - QuietSpot',
        html: `
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
                <div style="text-align: center; margin-bottom: 30px;">
                    <h1 style="color: #4CAF50; margin: 0;">QuietSpot</h1>
                    <p style="color: #666; margin: 5px 0;">Find Your Quiet Place</p>
                </div>
                
                <div style="background: #f5f5f5; border-radius: 10px; padding: 30px; text-align: center;">
                    <h2 style="color: #333; margin-top: 0;">Welcome to QuietSpot!</h2>
                    <p style="color: #666;">Hi ${userName},</p>
                    <p style="color: #666;">Thank you for signing up! Please verify your email with the code below:</p>
                    
                    <div style="background: #2196F3; color: white; font-size: 32px; font-weight: bold; letter-spacing: 8px; padding: 20px 40px; border-radius: 10px; display: inline-block; margin: 20px 0;">
                        ${verifyCode}
                    </div>
                    
                    <p style="color: #999; font-size: 14px;">This code expires in <strong>5 minutes</strong>.</p>
                    <p style="color: #999; font-size: 14px;">If you didn't create an account, please ignore this email.</p>
                </div>
                
                <div style="text-align: center; margin-top: 30px; color: #999; font-size: 12px;">
                    <p>© 2026 QuietSpot App</p>
                </div>
            </div>
        `
    });

    if (error) {
        throw new Error(error.message);
    }
    return data;
}

// Signup endpoint - creates pending user and sends verification email
router.post('/signup', async (req, res) => {
    try {
        const { username, email, password } = req.body;

        if (!username || !email || !password) {
            return res.status(400).json({ error: 'Username, email, and password are required' });
        }

        // Check if email already exists
        const [existingEmail] = await db.execute(
            'SELECT user_id FROM users WHERE email = ?',
            [email]
        );
        if (existingEmail.length > 0) {
            return res.status(409).json({ error: 'Email already registered' });
        }

        // Check if username already exists
        const [existingUsername] = await db.execute(
            'SELECT user_id FROM users WHERE name = ?',
            [username]
        );
        if (existingUsername.length > 0) {
            return res.status(409).json({ error: 'Username already taken' });
        }

        // Generate 5-digit verification code
        const verifyToken = Math.floor(10000 + Math.random() * 90000).toString();
        const verifyExpires = new Date(Date.now() + 5 * 60 * 1000); // 5 minutes

        // Create user with pending verification
        await db.execute(`
            INSERT INTO users (name, email, password, email_verified, email_verify_token, email_verify_expires)
            VALUES (?, ?, ?, FALSE, ?, ?)
        `, [username, email, password, verifyToken, verifyExpires]);

        // Send verification email
        try {
            await sendVerificationEmail(email, username, verifyToken);
            console.log(`✅ Verification email sent to ${email}`);
        } catch (emailError) {
            console.error('❌ Failed to send verification email:', emailError.message);
            // Log to console as fallback
            console.log('\n' + '='.repeat(50));
            console.log('📧 EMAIL VERIFICATION (email failed, showing here)');
            console.log('='.repeat(50));
            console.log(`To: ${email}`);
            console.log(`Verification Code: ${verifyToken}`);
            console.log('='.repeat(50) + '\n');
        }

        res.status(201).json({ message: 'Verification code sent to your email' });

    } catch (error) {
        console.error('Signup error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Verify Email endpoint - verifies code and activates account
router.post('/verify-email', async (req, res) => {
    try {
        const { email, code } = req.body;

        if (!email || !code) {
            return res.status(400).json({ error: 'Email and verification code are required' });
        }

        // Find user with matching email, token, and non-expired token
        const [rows] = await db.execute(`
            SELECT user_id, name, email
            FROM users
            WHERE email = ? 
              AND email_verify_token = ? 
              AND email_verify_expires > NOW()
        `, [email, code]);

        if (rows.length === 0) {
            return res.status(400).json({ error: 'Invalid or expired verification code' });
        }

        const user = rows[0];

        // Mark email as verified and clear token
        await db.execute(`
            UPDATE users
            SET email_verified = TRUE, email_verify_token = NULL, email_verify_expires = NULL
            WHERE user_id = ?
        `, [user.user_id]);

        console.log(`✅ Email verified for user: ${user.name} (${email})`);

        // Return user info for auto-login
        res.json({
            id: user.user_id,
            name: user.name,
            email: user.email
        });

    } catch (error) {
        console.error('Verify email error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Login endpoint
router.post('/login', async (req, res) => {
    try {
        const { username, password } = req.body;

        if (!username || !password) {
            return res.status(400).json({ error: 'Username and password are required' });
        }

        // Query user by name
        const [rows] = await db.execute(`
      SELECT user_id as id, name, email, password, email_verified
      FROM users
      WHERE name = ?
    `, [username]);

        if (rows.length === 0) {
            return res.status(401).json({ error: 'Invalid username or password' });
        }

        const user = rows[0];

        // Check password (PLAINTEXT for demo as per instructions)
        // In production, use bcrypt.compare(password, user.password)
        if (user.password !== password) {
            return res.status(401).json({ error: 'Invalid username or password' });
        }

        // Check if email is verified
        if (user.email_verified === 0 || user.email_verified === false) {
            return res.status(403).json({ error: 'Please verify your email before logging in' });
        }

        // Return user info (excluding password)
        res.json({
            id: user.id,
            name: user.name,
            email: user.email
        });

    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Forgot Password endpoint
router.post('/forgot-password', async (req, res) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({ error: 'Email is required' });
        }

        // Check if user exists
        const [rows] = await db.execute(`
      SELECT user_id, email, name
      FROM users
      WHERE email = ?
    `, [email]);

        if (rows.length === 0) {
            // Return explicit error as requested
            return res.status(404).json({ error: 'Email address not found' });
        }

        const user = rows[0];
        const userId = user.user_id;
        // Generate 5-digit code
        const token = Math.floor(10000 + Math.random() * 90000).toString();
        const expires = new Date(Date.now() + 5 * 60 * 1000); // 5 minutes

        // Save to DB
        await db.execute(`
      UPDATE users
      SET password_reset_token = ?, password_reset_expires = ?
      WHERE user_id = ?
    `, [token, expires, userId]);

        // Send actual email
        try {
            await sendPasswordResetEmail(email, user.name, token);
            console.log(`✅ Password reset email sent to ${email}`);
        } catch (emailError) {
            console.error('❌ Failed to send email:', emailError.message);
            // Still log to console as fallback
            console.log('\n' + '='.repeat(50));
            console.log('📧 PASSWORD RESET (email failed, showing here)');
            console.log('='.repeat(50));
            console.log(`To: ${email}`);
            console.log(`Reset Code: ${token}`);
            console.log('='.repeat(50) + '\n');
        }

        res.json({ message: 'Reset code sent to your email' });

    } catch (error) {
        console.error('Forgot password error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Reset Password endpoint (Verify code + Set new password)
router.post('/reset-password', async (req, res) => {
    try {
        const { email, code, newPassword } = req.body;

        if (!email || !code || !newPassword) {
            return res.status(400).json({ error: 'Email, code, and new password are required' });
        }

        // Find user with matching email, token, and non-expired token
        const [rows] = await db.execute(`
      SELECT user_id, name, email
      FROM users
      WHERE email = ? 
        AND password_reset_token = ? 
        AND password_reset_expires > NOW()
    `, [email, code]);

        if (rows.length === 0) {
            return res.status(400).json({ error: 'Invalid or expired reset code' });
        }

        const user = rows[0];

        // Update password and clear token
        // (In production, hash newPassword here)
        await db.execute(`
      UPDATE users
      SET password = ?, password_reset_token = NULL, password_reset_expires = NULL
      WHERE user_id = ?
    `, [newPassword, user.user_id]);

        // Return user info for auto-login
        res.json({
            id: user.user_id,
            name: user.name,
            email: user.email
        });

    } catch (error) {
        console.error('Reset password error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Change Password endpoint
router.post('/change-password', async (req, res) => {
    try {
        const { userId, oldPassword, newPassword } = req.body;

        if (!userId || !oldPassword || !newPassword) {
            return res.status(400).json({ error: 'Missing required fields' });
        }

        // Get current password
        const [rows] = await db.execute(`
            SELECT password FROM users WHERE user_id = ?
        `, [userId]);

        if (rows.length === 0) {
            return res.status(404).json({ error: 'User not found' });
        }

        const user = rows[0];

        // Verify old password
        if (user.password !== oldPassword) {
            return res.status(401).json({ error: 'Incorrect old password' });
        }

        // Update password
        await db.execute(`
            UPDATE users SET password = ? WHERE user_id = ?
        `, [newPassword, userId]);

        res.json({ message: 'Password updated successfully' });

    } catch (error) {
        console.error('Change pass error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

module.exports = router;


