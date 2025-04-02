import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { buildPath } from './Path';

function Register() {
    const [firstName, setFirstName] = useState('');
    const [lastName, setLastName] = useState('');
    const [email, setEmail] = useState('');
    const [login, setLogin] = useState('');
    const [password, setPassword] = useState('');
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

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const res = await response.json();

            if (res.error) {
                setMessage('Registration failed: ' + res.error);
            } else {
                setMessage('Registration successful!');
                navigate('/login');
            }
        } catch (error: any) {
            setMessage(error.toString());
        }
    }

    return (
        <div className="flex h-screen items-center justify-center bg-gray-100">
            <h1 className="absolute top-0 w-full text-5xl font-bold text-center text-[#0f172a] mt-3">
                Fit Journey
            </h1>
            <div className="w-full max-w-md bg-white p-8 rounded-lg shadow-lg">

                <h2 className="text-3xl font-bold text-center text-[#0f172a] mb-6">Register</h2>

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

                {message && <p className="text-center text-red-500 mt-4">{message}</p>}

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
