const express = require('express');
const router = express.Router();

// Helper function to retrieve the database instance
function getDB(req) {
  const client = req.app.locals.dbClient;
  return client.db("sample_mflix");
}

// Registration endpoint
router.post('/register', async (req, res) => {
  const { firstName, lastName, email, login, password } = req.body;
  const db = getDB(req);
  try {
    const existingUser = await db.collection('users').findOne({ login });
    if (existingUser) {
      return res.status(400).json({ error: 'Username already exists' });
    }
    const existingEmail = await db.collection('users').findOne({ email });
    if (existingEmail) {
      return res.status(400).json({ error: 'Email already exists' });
    }
    await db.collection('users').insertOne({ firstName, lastName, email, login, password });
    res.status(200).json({ message: "User is added!", error: '' });
  } catch (error) {
    console.error('Error during registration:', error);
    res.status(500).json({ error: error.message });
  }
});

// Login endpoint
router.post('/login', async (req, res) => {
  const { login, password } = req.body;
  const db = getDB(req);
  try {
    const user = await db.collection('users').findOne({ login });
    if (!user || user.password !== password) {
      return res.status(401).json({ error: "Invalid username or password" });
    }
    res.status(200).json({
      id: user._id.toString(),
      firstName: user.firstName,
      lastName: user.lastName
    });
  } catch (error) {
    console.error("Login error:", error);
    res.status(500).json({ error: error.message });
  }
});


module.exports = router;
