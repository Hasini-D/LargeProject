const express = require('express');
const crypto = require('crypto');
const sgMail = require('@sendgrid/mail');
const router = express.Router();

function getDB(req) {
  const client = req.app.locals.dbClient;
  return client.db("MERNDatabase");
}

// Configure SendGrid
sgMail.setApiKey(process.env.SENDGRID_API_KEY);

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

    // Prepare the verification email
    const msg = {
      to: email,
      from: process.env.EMAIL_USER,
      subject: 'Verify Your Email',
      html: `<p>Click <a href="${verificationLink}">here</a> to verify your email.</p>`
    };

    // Send email before adding user to database
    await sgMail.send(msg);

    // Add user to the database **only if email sending succeeds**
    await db.collection('users').insertOne({
      firstName, lastName, email, login, password,
      isVerified: false,
      verificationToken,
    });

    res.status(200).json({ message: 'Registration successful! Please check your email to verify your account.' });
  } catch (error) {
    console.error('Error during registration:', error);
    
    // Specific error for email issues
    if (error.response) {
      console.error("SendGrid response error:", error.response.body);
    }
    
    res.status(500).json({ error: "Registration failed. Please try again." });
  }
});

// Email verification endpoint
router.get('/verify-email', async (req, res) => {
  const token = req.query.token; // Extract token from query parameters
  const db = getDB(req);

  try {
    // Log the token received in the request
    console.log("Verification token received:", token);

    // Find user by verification token
    const user = await db.collection('users').findOne({ verificationToken: token });

    // Log the retrieved user
    console.log("Retrieved user:", user);

    // If no user is found or the token is invalid/expired
    if (!user) {
      return res.status(400).json({ error: 'Invalid or expired token' });
    }

    // Update the user's verification status
    const updateResult = await db.collection('users').updateOne(
      { verificationToken: token }, // Find user by token
      { 
        $set: { isVerified: true },   // Set isVerified to true
        $unset: { verificationToken: 1 } // Remove the verificationToken field
      }
    );

    // Log the result of the update operation
    console.log("Update result:", updateResult);

    // Send response indicating successful verification
    res.status(200).json({ message: 'Email verified! You can now log in.' });
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
    const user = await db.collection('users').findOne({ login });
    console.log("Retrieved user:", user);

    if (!user) {
      return res.status(401).json({ error: "Invalid username or password" });
    }

    console.log("isVerified value:", user.isVerified);

    if (!user.isVerified) {
      console.log("User is not verified");
      return res.status(403).json({ error: "Please verify your email before logging in." });
    }

    if (user.password !== password) {
      return res.status(401).json({ error: "Invalid username or password" });
    }

    console.log("Login successful for user:", user.login);
    res.status(200).json({ id: user._id.toString(), firstName: user.firstName, lastName: user.lastName });
  } catch (error) {
    console.error("Login error:", error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
