const jwt = require('jsonwebtoken');

function createToken(firstName, lastName, userId) {
    const payload = { firstName, lastName, userId };
    const secret = process.env.JWT_SECRET || 'yourSecret'; // Secret should be in .env for security
    const options = { expiresIn: '1h' };

    // Create and return the JWT
    return jwt.sign(payload, secret, options);
}

module.exports = { createToken };
