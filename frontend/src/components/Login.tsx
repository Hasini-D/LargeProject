import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { buildPath } from './Path';
import { jwtDecode } from 'jwt-decode';

interface DecodedToken {
  firstName: string;
  lastName: string;
  userId: string; // adjust type if necessary
}

function Login() {
  const [loginName, setLoginName] = useState('');
  const [loginPassword, setPassword] = useState('');
  const [message, setMessage] = useState('');
  const navigate = useNavigate();

  function handleSetLoginName(e: React.ChangeEvent<HTMLInputElement>): void {
    setLoginName(e.target.value);
  }

  function handleSetPassword(e: React.ChangeEvent<HTMLInputElement>): void {
    setPassword(e.target.value);
  }

  async function doLogin(event: React.FormEvent): Promise<void> {
    event.preventDefault();
    const obj = { login: loginName, password: loginPassword };
    const js = JSON.stringify(obj);

    try {
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

      const contentType = response.headers.get('content-type');
      if (!contentType || !contentType.includes('application/json')) {
        throw new TypeError("Received non-JSON response");
      }

      const res = await response.json();

      // Check if there's an error field in the response
      if (res.error) {
        setMessage('User/Password combination incorrect');
      } else {
        // Decode the token using jwt-decode (a plain function, not a hook)
        const decodedToken = jwtDecode<DecodedToken>(res.accessToken);
        if (!decodedToken) {
          setMessage('Error decoding token');
          return;
        }
        const user = { 
          firstName: decodedToken.firstName, 
          lastName: decodedToken.lastName, 
          id: decodedToken.userId 
        };
        
        // Store user data in localStorage
        localStorage.setItem('user_data', JSON.stringify(user));

        // Store the JWT token in localStorage
        if (res.accessToken) {
          localStorage.setItem('token_data', res.accessToken);
          console.log('JWT Token stored in localStorage:', res.accessToken);  // Add this line to log the token
        }

        setMessage('Login successful!');
        window.location.href = '/cards';
      }
    } catch (error: any) {
      setMessage(error.toString());
    }
  }

  function goToRegister() {
    navigate('/register');
  }

  return (
    <div id="loginDiv">
      <span id="inner-title">PLEASE LOG IN</span><br />
      <input
        type="text"
        id="loginName"
        placeholder="Username"
        value={loginName}
        onChange={handleSetLoginName}
      /><br />
      <input
        type="password"
        id="loginPassword"
        placeholder="Password"
        value={loginPassword}
        onChange={handleSetPassword}
      /><br />
      <input
        type="submit"
        id="loginButton"
        className="buttons"
        value="Do It"
        onClick={doLogin}
      /><br />
      <span id="loginResult">{message}</span><br />
      <button type="button" id="registerButton" className="buttons" onClick={goToRegister}>
        Register
      </button>
    </div>
  );
}

export default Login;
