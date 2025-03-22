require('express');
require('mongodb');

exports.setApp = function (app, client) {
    const db = client.db("sample_mflix");

    app.post('/api/register', async (req, res) => {
        const { firstName, lastName, email, login, password } = req.body;
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
            return res.status(200).json({ message: "User is added!", error: '' });
        } catch (error) {
            console.error('Error during registration:', error);
            return res.status(500).json({ error: error.message });
        }
    });

    app.post('/api/login', async (req, res) => {
        const { login, password } = req.body;
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

    app.post('/api/addcard', async (req, res) => {
        const { userId, card } = req.body;

        const newCard = { Card: card, UserId: userId };
        let error = '';

        try {
            await db.collection('cards').insertOne(newCard);
        } catch (e) {
            error = e.toString();
        }

        res.status(200).json({ error: error });
    });

    app.post('/api/searchcards', async (req, res) => {
        const { userId, search } = req.body;

        let error = '';
        const _search = search.trim();
        let results = [];

        try {
            results = await db.collection('cards')
                .find({ "Card": { $regex: _search + '.*', $options: 'i' }, "UserId": userId })
                .toArray();
        } catch (e) {
            error = e.toString();
        }

        let _ret = results.map(item => item.Card);

        res.status(200).json({ results: _ret, error: error });
    });
};
