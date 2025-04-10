const express = require('express');
const crypto = require('crypto');
const fetch = require('node-fetch');
const { ObjectId } = require('mongodb');
require('dotenv').config();

const router = express.Router();

// Add this function before using it
function generateAuthToken(user) {
  const jwt = require('jsonwebtoken');
  const secretKey = process.env.JWT_SECRET || 'yourSecretKey'; // Use a secure key
  return jwt.sign({ id: user.id, email: user.email }, secretKey, { expiresIn: '1h' });
}

function getDB(req) {
  const client = req.app.locals.dbClient;
  return client.db("sample_mflix");
}

// Middleware to authenticate user
function authenticateToken(req, res, next) {
  const jwt = require('jsonwebtoken');
  const token = req.headers['authorization']?.split(' ')[1];
  const secretKey = process.env.JWT_SECRET || 'yourSecretKey';

  if (!token) return res.status(401).json({ error: 'Access denied. No token provided.' });

  jwt.verify(token, secretKey, (err, user) => {
    if (err) return res.status(403).json({ error: 'Invalid token.' });
    req.user = user;
    next();
  });
}

// Delete account endpoint
router.delete('/delete', authenticateToken, async (req, res) => {
  const db = getDB(req);
  const userEmail = req.user.email; // Extracted from the token

  try {
    const result = await db.collection('users').deleteOne({ email: userEmail });

    if (result.deletedCount === 0) {
      return res.status(404).json({ error: 'User not found.' });
    }

    res.status(200).json({ message: 'Account deleted successfully.' });
  } catch (error) {
    console.error('Error deleting account:', error);
    res.status(500).json({ error: 'An error occurred while deleting the account.' });
  }
});

// Registration endpoint
router.post('/register', async (req, res) => {
  const { firstName, lastName, email, login, password } = req.body;
  const db = getDB(req);

  try {
    const errors = [];

    // Check if username already exists
    const existingUser = await db.collection('users').findOne({ login });
    if (existingUser) {
      errors.push('Username already exists');
    }

    // Check if email already exists
    const existingEmail = await db.collection('users').findOne({ email });
    if (existingEmail) {
      errors.push('Email already exists');
    }

    // If there are errors, return them
    if (errors.length > 0) {
      return res.status(400).json({ errors });
    }
    
    // Generate verification token & link
    const verificationToken = crypto.randomBytes(32).toString('hex');
    const verificationLink = `${process.env.BASE_URL}/api/verify-email?token=${verificationToken}`;

    // Send verification email via Resend
    const response = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${process.env.RESEND_API_KEY}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        from: process.env.EMAIL_USER,
        to: email,
        subject: "Verify Your Email",
        html: `<p>Click <a href="${verificationLink}">here</a> to verify your email.</p>`
      })
    });

    const data = await response.json();
    if (!response.ok) {
      console.error("Resend API Error:", data);
      return res.status(500).json({ error: "Email sending failed. Please try again." });
    }

    // Add user to the database **only if email sending succeeds**
    await db.collection('users').insertOne({
      firstName, lastName, email, login, password,
      isVerified: false,
      verificationToken,
    });

    res.status(200).json({ message: 'Registration successful! Please check your email to verify your account.' });
  } catch (error) {
    console.error('Error during registration:', error);
    res.status(500).json({ error: "Registration failed. Please try again." });
  }
});

// GET userId by email
router.get('/get-user-id', async (req, res) => {
  const { email } = req.query;
  const db = getDB(req);

  try {
    const user = await db.collection('users').findOne({ email });
    if (!user) return res.status(404).json({ error: 'User not found' });

    return res.status(200).json({ userId: user._id });
  } catch (error) {
    console.error('Fetch user ID error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// POST profile info
router.post('/user-info', async (req, res) => {
  const { userId, gender, height, weight, age, goal } = req.body;
  const db = getDB(req);

  try {
    if (!ObjectId.isValid(userId)) {
      return res.status(404).json({ error: 'Invalid user ID' });
    }
        
    const result = await db.collection('userStats').updateOne(
      {userId: new ObjectId(userId)},
      { 
        $set : {
          userId: new ObjectId(userId),
          gender, 
          height, 
          weight, 
          age, 
          goal, 
          isProfileComplete: true, 
          updatedAt: new Date(), },
      },
      { upsert: true } // Create the document if it doesn't exist
    );

    if (result.modifiedCount === 0 && result.upsertedCount === 0) return res.status(404).json({ error: 'User not found or unchanged' });

    res.status(200).json({ message: 'Profile added' });
  } catch (err) {
    console.error('Update profile error:', err);
    res.status(500).json({ error: 'Server error' });
  }
});

// Email verification endpoint
router.get('/verify-email', async (req, res) => {
  const token = req.query.token; // Extract token from query parameters
  const db = getDB(req);

  try {
    console.log("Verification token received:", token);

    // Find user by verification token
    const user = await db.collection('users').findOne({ verificationToken: token });

    console.log("Retrieved user:", user);

    if (!user) {
      return res.status(400).json({ error: 'Invalid or expired token' });
    }

    // Update the user's verification status
    const updateResult = await db.collection('users').updateOne(
      {verificationToken: token }, // Use the userId from the token
      { 
        $set: { isVerified: true },
        $unset: { verificationToken: 1 }
      }
    );

    //console.log("Update result:", updateResult);
    res.redirect(`${process.env.FRONTEND_URL}/setup-profile?email=${user.email}`);
  } catch (error) {
    console.error('Verification error:', error);
    res.status(500).json({ error: error.message });
  }
});

// Login endpoint
router.post('/login', async (req, res) => {
  const { login, password } = req.body;
  const db = getDB(req);

  try {
    const errors = [];

    // Check if login exists
    const user = await db.collection('users').findOne({ login });
    if (!user) {
      errors.push('Invalid username');
    }

    // Check if password matches
    if (!user || (user && user.password !== password)) {
      errors.push('Invalid password');
    }

    // If not verified, block login
    if (user && !user.isVerified) {
      errors.push('Email not verified. Please check your email.');
    }

    // If there are errors, return them
    if (errors.length > 0) {
      return res.status(400).json({ errors });
    }

    // Proceed with login logic (e.g., generating a token)
    const token = generateAuthToken(user);

    // Log the user's login information to the terminal
    console.log(`User logged in: ${user.login}`);

    // Return the token and user data
    return res.status(200).json({
      token,
      user: {
        id: user._id,
        login: user.login,
        email: user.email,
      },
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
