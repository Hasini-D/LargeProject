require('express');
require('mongodb');
exports.setApp = function ( app, client ){

    const db = client.db('MERNDatabase');

    app.post('/api/register', async (req, res) => {
        console.log("Received request");
        console.log("Request body", req.body);
        //res.status(200).json({ messgae: "User is added" });
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
            res.status(200).json({ message: "User is added!", error: '' });
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
}