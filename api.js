require('express');
require('mongodb');


exports.setApp = function (app, client) {
    const db = client.db("sample_mflix");

    app.post('/api/register', async (req, res) => {
        const { firstName, lastName, email, login, password } = req.body;
        try {
            console.log('Register request received:', { firstName, lastName, email, login, password });

            const existingUser = await db.collection('users').findOne({ login: login });
            if (existingUser) {
                return res.status(400).json({ error: 'Username already exists' });
            }

            const existingEmail = await db.collection('users').findOne({ email: email });
            if (existingEmail) {
                return res.status(400).json({ error: 'Email already exists' });
            }

            const result = await db.collection('users').insertOne({ firstName, lastName, email, login, password });
            return res.status(200).json({ message: "User is added!", error: '' });
        } catch (error) {
            console.error('Error during registration:', error);
            return res.status(500).json({ error: error.message });
        }
    });

    const jwt = require("jsonwebtoken");
    require("dotenv").config();
    const ACCESS_TOKEN_SECRET = process.env.ACCESS_TOKEN_SECRET || "yourSecretKey";
    
    app.post('/api/login', async (req, res) => {
        const { login, password } = req.body;
        console.log("Login request received:", { login, password });
    
        try {
            const user = await db.collection('users').findOne({ login: login });
    
            if (!user) {
                console.log("User not found");
                return res.status(401).json({ error: "Invalid username or password" });
            }
    
            if (user.password !== password) {
                console.log("Incorrect password");
                return res.status(401).json({ error: "Invalid username or password" });
            }
    
            console.log("User found:", user); // 🔹 This log is missing in your logs
    
            // Debug: Check if SECRET is properly loaded
            console.log("ACCESS_TOKEN_SECRET:", ACCESS_TOKEN_SECRET);
            if (!ACCESS_TOKEN_SECRET) {
                console.error("JWT Secret is missing!");
                return res.status(500).json({ error: "Server misconfiguration: Missing JWT Secret" });
            }
    
            // Generate JWT token
            let token;
            try {
                token = jwt.sign(
                    { userId: user._id, firstName: user.firstName, lastName: user.lastName },
                    ACCESS_TOKEN_SECRET,
                    { expiresIn: "1h" }
                );
                console.log("Generated Token:", token);
            } catch (jwtError) {
                console.error("JWT Error:", jwtError);
                return res.status(500).json({ error: "JWT generation failed" });
            }
    
            // Debug: Show full response being sent
            console.log("Sending response:", {
                id: user._id,
                firstName: user.firstName,
                lastName: user.lastName,
                accessToken: token
            });
    
            // Send user data + token in response
            res.status(200).json({
                id: user._id,
                firstName: user.firstName,
                lastName: user.lastName,
                accessToken: token
            });
    
        } catch (error) {
            console.error("Login error:", error);
            res.status(500).json({ error: error.message });
        }
    });
    


    
    


    // Add Card Endpoint
    app.post('/api/addcard', async (req, res) => {
        const { userId, card, jwtToken } = req.body;
        const tokenModule = require("./createJWT.js");

        // Check if the token is expired
        try {
            if (tokenModule.isExpired(jwtToken)) {
                let refreshedToken = tokenModule.refresh(jwtToken);
                return res.status(200).json({ error: 'The JWT is no longer valid', jwtToken: refreshedToken });
            }
        } catch (e) {
            console.log(e.message);
        }

        // Process the card addition
        const newCard = { Card: card, UserId: userId };
        let error = '';
        try {
            await db.collection('cards').insertOne(newCard);
        } catch (e) {
            error = e.toString();
        }

        // Refresh the JWT
        let refreshedToken = null;
        try {
            refreshedToken = tokenModule.refresh(jwtToken);
        } catch (e) {
            console.log(e.message);
        }

        res.status(200).json({ error: error, jwtToken: refreshedToken });
    });

    // Search Cards Endpoint
    app.post('/api/searchcards', async (req, res) => {
        const { userId, search, jwtToken } = req.body;
        const tokenModule = require("./createJWT.js");

        // Check if the token is expired
        try {
            if (tokenModule.isExpired(jwtToken)) {
                let refreshedToken = tokenModule.refresh(jwtToken);
                return res.status(200).json({ error: 'The JWT is no longer valid', jwtToken: refreshedToken });
            }
        } catch (e) {
            console.log(e.message);
        }

        let error = '';
        const _search = search.trim();
        let results = [];
        try {
            results = await db.collection('cards').find({ "Card": { $regex: _search + '.*', $options: 'i' } }).toArray();
        } catch (e) {
            error = e.toString();
        }

        // Format the results: extract the "Card" property from each result.
        let _ret = results.map(item => item.Card);

        // Refresh the JWT
        let refreshedToken = null;
        try {
            refreshedToken = tokenModule.refresh(jwtToken);
        } catch (e) {
            console.log(e.message);
        }

        res.status(200).json({ results: _ret, error: error, jwtToken: refreshedToken });
    });
}
