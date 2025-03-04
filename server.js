const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { MongoClient } = require('mongodb');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(bodyParser.json());
app.use(express.json());

// MongoDB Connection
require('dotenv').config();
const url = process.env.MONGODB_URI;
//const url = 'mongodb+srv://hasinidaliboyina:Honey%402004@merndatabase.rv3xl.mongodb.net/?retryWrites=true&w=majority&appName=MERNDatabase';
const client = new MongoClient(url);
client.connect()
    .then(() => console.log('MongoDB Connected'))
    .catch(err => console.log(err));

const db = client.db("sample_mflix");

// Login endpoint (Now uses MongoDB)
app.post('/api/login', async (req, res) => {
    const { login, password } = req.body;
    console.log("recieved login request:", { login, password});
    //const email = 'mark_addy@gameofthron.es';
    const user = await db.collection('users').findOne({ login: login});
    console.log("here are the user details",user)
    if (user) {
        res.status(200).json({ id: user._id, firstName: user.firstName, lastname: user.lastName, error: '' });
    } else {
        console.log("incorrect password");
        res.status(401).json({ id: -1, firstName: '', lastName: '', error: 'Invalid username or password' });
    }
});

// Start Server
const PORT = 5001;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
