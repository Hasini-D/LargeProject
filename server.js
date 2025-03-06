require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { MongoClient } = require('mongodb');

const app = express();
app.use(cors());
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
    .catch(err => console.log(err));

const db = client.db("sample_mflix");

// Login Endpoint
app.post('/api/login', async (req, res) => {
    const { login, password } = req.body;
    try {
        const user = await db.collection('users').findOne({ login: login });
        if (user && user.password === password) {
            res.status(200).json({ id: user._id, firstName: user.firstName, lastName: user.lastName, error: '' });
        } else {
            res.status(401).json({ id: -1, firstName: '', lastName: '', error: 'Invalid username or password' });
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Add Card Endpoint
app.post('/api/addcard', async (req, res) => {
    const { userId, card } = req.body;
    try {
        const result = await db.collection('cards').insertOne({ userId, card });
        res.status(200).json({ error: '' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Search Cards Endpoint
app.post('/api/searchcards', async (req, res) => {
    const { userId, search } = req.body;
    try {
        const results = await db.collection('cards').find({ userId, card: { $regex: search, $options: 'i' } }).toArray();
        res.status(200).json({ results: results.map(result => result.card), error: '' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Start Server
const PORT = 5001;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));