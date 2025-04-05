import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { buildPath } from './Path';

function Register() {
    const [firstName, setFirstName] = useState('');
    const [lastName, setLastName] = useState('');
    const [email, setEmail] = useState('');
    const [login, setLogin] = useState('');
    const [password, setPassword] = useState('');
    const [errors, setErrors] = useState<string[]>([]); // State to store errors
    const [message, setMessage] = useState('');
    const navigate = useNavigate();

    async function doRegister(event: React.FormEvent): Promise<void> {
        event.preventDefault();
        const obj = { firstName, lastName, email, login, password };
        const js = JSON.stringify(obj);

        try {
            const response = await fetch(buildPath('api/register'), {
                method: 'POST',
                body: js,
                headers: { 'Content-Type': 'application/json' },
            });

            const data = await response.json();

            if (response.status === 400) {
                // Display errors if registration fails
                setErrors(data.errors || []);
            } else if (response.status === 200) {
                // Clear errors and navigate on successful registration
                setErrors([]);
                setMessage('Registration successful!');
                navigate('/verification'); // Replace with your desired route
            } else {
                setMessage('An unexpected error occurred.');
            }
        } catch (err) {
            console.error(err);
            setMessage('An error occurred while registering.');
        }
    }

    return (
        <div className="max-w-md mx-auto mt-10 p-6 bg-white shadow-md rounded-lg relative">
            <h1 className="absolute top-0 w-full text-5xl font-bold text-center text-[#0f172a] mt-3">
                Fit Journey
            </h1>
            <div className="mt-16">
                <h2 className="text-2xl font-bold text-center mb-6">Register</h2>
                <form onSubmit={doRegister} className="space-y-4">
                    <input
                        type="text"
                        placeholder="First Name"
                        value={firstName}
                        onChange={(e) => setFirstName(e.target.value)}
                        className="w-full px-4 py-2 border rounded-lg focus:outline-none"
                    />
                    <input
                        type="text"
                        placeholder="Last Name"
                        value={lastName}
                        onChange={(e) => setLastName(e.target.value)}
                        className="w-full px-4 py-2 border rounded-lg focus:outline-none"
                    />
                    <input
                        type="email"
                        placeholder="Email"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                        className="w-full px-4 py-2 border rounded-lg focus:outline-none"
                    />
                    <input
                        type="text"
                        placeholder="Username"
                        value={login}
                        onChange={(e) => setLogin(e.target.value)}
                        className="w-full px-4 py-2 border rounded-lg focus:outline-none"
                    />
                    <input
                        type="password"
                        placeholder="Password"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        className="w-full px-4 py-2 border rounded-lg focus:outline-none"
                    />

                    <button
                        type="submit"
                        className="w-full bg-[#0f172a] text-white py-2 rounded-lg hover:bg-[#2563eb] transition"
                    >
                        Register
                    </button>
                </form>

                {errors.length > 0 && (
                    <div className="mt-4 text-red-500">
                        <h3 className="text-center font-semibold">Errors:</h3>
                        <ul className="list-disc list-inside">
                            {errors.map((error, index) => (
                                <li key={index}>{error}</li>
                            ))}
                        </ul>
                    </div>
                )}

                {message && errors.length === 0 && (
                    <p className="text-center text-red-500 mt-4">{message}</p>
                )}

                <div className="text-center mt-4">
                    <p className="text-[#0f172a]">
                        Already have an account?{' '}
                        <button onClick={() => navigate('/login')} className="text-blue-500 underline">
                            Login
                        </button>
                    </p>
                </div>
            </div>
        </div>
    );
}

export default Register;