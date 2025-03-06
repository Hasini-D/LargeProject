require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { MongoClient } = require('mongodb');

const app = express();
app.use(cors()); // Enable CORS
app.use(bodyParser.json());
app.use(express.json());

// MongoDB Connection
const url = process.env.MONGO_URI;
if (!url) {
    throw new Error('MONGO_URI is not defined in the environment variables');
}

const client = new MongoClient(url);
client.connect()
    .then(() => console.log('MongoDB Connected'))
    .catch(err => console.log('MongoDB Connection Error:', err));

const db = client.db("sample_mflix");

// Register Endpoint
app.post('/api/register', async (req, res) => {
    const { firstName, lastName, email, login, password } = req.body;
    try {
        console.log('Register request received:', { firstName, lastName, email, login, password });
        const existingUser = await db.collection('users').findOne({ login: login });
        if (existingUser) {
            res.status(400).json({ error: 'Username already exists' });
            return;
        }

        const existingEmail = await db.collection('users').findOne({ email: email });
        if (existingEmail) {
            res.status(400).json({ error: 'Email already exists' });
            return;
        }

        const result = await db.collection('users').insertOne({ firstName, lastName, email, login, password });
        res.status(200).json({ error: '' });
    } catch (error) {
        console.error('Error during registration:', error);
        res.status(500).json({ error: error.message });
    }
});

// Login Endpoint
app.post('/api/login', async (req, res) => {
    const { login, password } = req.body;
    try {
        console.log('Login request received:', { login, password });
        const user = await db.collection('users').findOne({ login: login });
        if (user && user.password === password) {
            res.status(200).json({ id: user._id, firstName: user.firstName, lastName: user.lastName, error: '' });
        } else {
            res.status(401).json({ id: -1, firstName: '', lastName: '', error: 'Invalid username or password' });
        }
    } catch (error) {
        console.error('Error during login:', error);
        res.status(500).json({ error: error.message });
    }
});

// Add Card Endpoint
app.post('/api/addcard', async (req, res) => {
    const { userId, card } = req.body;
    try {
        console.log('Add card request received:', { userId, card });
        const result = await db.collection('cards').insertOne({ userId, card });
        res.status(200).json({ error: '' });
    } catch (error) {
        console.error('Error during add card:', error);
        res.status(500).json({ error: error.message });
    }
});

// Search Cards Endpoint
app.post('/api/searchcards', async (req, res) => {
    const { userId, search } = req.body;
    try {
        console.log('Search cards request received:', { userId, search });
        const results = await db.collection('cards').find({ userId, card: { $regex: search, $options: 'i' } }).toArray();
        res.status(200).json({ results: results.map(result => result.card), error: '' });
    } catch (error) {
        console.error('Error during search cards:', error);
        res.status(500).json({ error: error.message });
    }
});

// Start Server
const PORT = 5001;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));