require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { MongoClient } = require('mongodb');

const app = express();
const port = 5001; // ensure this is the port you're trying to access

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

// Middleware
app.use(cors()); // Enable CORS
app.use(express.json()); // Body parser for JSON requests

// Logging middleware to track all incoming requests
app.use((req, res, next) => {
    console.log(`Received request: ${req.method} ${req.url}`);
    next();
});

// Import API routes
var api = require('./api.js');
api.setApp(app, client);

// Start Server
app.listen(port, '0.0.0.0', () => {
    console.log(`Server running on http://localhost:${port}`);
});
