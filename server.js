require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { MongoClient } = require('mongodb');

const app = express();
const port = 5001; // ensure this is the port you're trying to access

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});

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
//const PORT = 5001;
//app.listen(PORT, () => console.log(`Server running on port ${PORT}`));// triggering ci/cd pipeline
//Now this port is removed