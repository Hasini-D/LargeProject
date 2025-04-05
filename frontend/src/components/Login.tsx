import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { buildPath } from './Path';

function Login() {
  const [loginName, setLoginName] = useState('');
  const [loginPassword, setPassword] = useState('');
  const [message, setMessage] = useState('');
  const [errors, setErrors] = useState<string[]>([]); // State to store errors
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

      const data = await response.json();

      if (response.ok) {
        // Save the token and user data in localStorage
        localStorage.setItem('token_data', data.token);
        localStorage.setItem('user_data', JSON.stringify(data.user));

        // Navigate to the dashboard
        navigate('/dashboard');
      } else if (response.status === 400) {
        // Display errors if login fails
        setErrors(data.errors || []);
      } else {
        setMessage('An unexpected error occurred.');
      }
    } catch (error) {
      console.error('Error during login:', error);
      setMessage('An error occurred while logging in.');
    }
  }

  return (
    <div className="max-w-md mx-auto mt-10 p-6 bg-white shadow-md rounded-lg">
      <h1 className="text-2xl font-bold text-center mb-6">Login</h1>
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
  );
}

export default Login;