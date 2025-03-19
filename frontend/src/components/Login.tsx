import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { buildPath } from './Path';

function Login() {
  const [loginName, setLoginName] = useState('');
  const [loginPassword, setPassword] = useState('');
  const [message, setMessage] = useState('');
  const navigate = useNavigate();

  async function doLogin(event: React.FormEvent): Promise<void> {
    event.preventDefault();
    const obj = { login: loginName, password: loginPassword };
    const js = JSON.stringify(obj);

    try {
      console.log("Making request to:", buildPath('api/login'));

      const response = await fetch(buildPath('api/login'), {
        method: 'POST',
        body: js,
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const res = await response.json();
      if (res.error) {
        setMessage('User/Password combination incorrect');
      } else {
        const user = { firstName: res.firstName, lastName: res.lastName, id: res.id };
        localStorage.setItem('user_data', JSON.stringify(user));
        setMessage('Login successful!');
        navigate('/dashboard');
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
      
        <h2 className="text-3xl font-bold text-center text-#0f172a mb-6">Login</h2>

        <form onSubmit={doLogin} className="space-y-4">
          <input
            type="text"
            placeholder="Username"
            value={loginName}
            onChange={(e) => setLoginName(e.target.value)}
            className="w-full px-4 py-2 border rounded-lg focus:outline-none"
          />

          <input
            type="password"
            placeholder="Password"
            value={loginPassword}
            onChange={(e) => setPassword(e.target.value)}
            className="w-full px-4 py-2 border rounded-lg focus:outline-none"
          />

          <button
            type="submit"
            className="w-full bg-[#0f172a] text-white py-2 rounded-lg hover:bg-[#2563eb] transition"
          >
            Login
          </button>
        </form>

        {message && <p className="text-center text-red-500 mt-4">{message}</p>}

        <div className="text-center mt-4">
          <p className="text-[#0f172a]">
            Don't have an account?{' '}
            <button onClick={() => navigate('/register')} className="text-blue-500 underline">
              Register
            </button>
          </p>
        </div>
      </div>
    </div>
  );
}

export default Login;
