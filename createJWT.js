const jwt = require("jsonwebtoken");
require("dotenv").config(); // Load env variables
const ACCESS_TOKEN_SECRET = process.env.ACCESS_TOKEN_SECRET || "yourSecretKey";

// 🔹 Function to create JWT token
exports.createToken = function (firstName, lastName, userId) {
    console.log("Creating JWT for:", { firstName, lastName, userId });

    try {
        const token = jwt.sign(
            { userId, firstName, lastName },
            ACCESS_TOKEN_SECRET,
            { expiresIn: "1h" }
        );

        return { accessToken: token };
    } catch (error) {
        console.error("Error generating JWT:", error);
        return { error: error.message };
    }
};
