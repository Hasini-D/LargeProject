require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { MongoClient } = require('mongodb');

const app = express();
app.use(cors()); // Enable CORS
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
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

//Mern C requirement
var api = require('./api.js');
api.setApp( app, client );




// Start Server
const PORT = 5001;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));// triggering ci/cd pipeline
