import { useState } from 'react';

const app_name = 'fitjourneyhome.com';

function buildPath(route: string): string {
    if (process.env.NODE_ENV !== 'development') {
        return 'https://' + app_name + '/' + route;
    } else {
        return 'http://localhost:5001/' + route;
    }
}

function Register() {
    const [firstName, setFirstName] = useState('');
    const [lastName, setLastName] = useState('');
    const [email, setEmail] = useState('');
    const [login, setLogin] = useState('');
    const [password, setPassword] = useState('');
    const [message, setMessage] = useState('');

    async function doRegister(event: any): Promise<void> {
        event.preventDefault();
        setMessage(''); // Reset message before new request

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

            const contentType = response.headers.get('content-type');
            if (!contentType || !contentType.includes('application/json')) {
                throw new TypeError("Received non-JSON response");
            }

            const res = await response.json();

            if (res.error) {
                setMessage(`Registration failed: ${res.error}`);
            } else {
                setMessage('Registration successful! Please check your email to verify your account before logging in.');
            }
        } catch (error: any) {
            setMessage(error.toString());
        }
    }

    return (
        <div id="registerDiv">
            <span id="inner-title">REGISTER</span><br />
            <input type="text" id="firstName" placeholder="First Name" value={firstName} onChange={(e) => setFirstName(e.target.value)} /><br />
            <input type="text" id="lastName" placeholder="Last Name" value={lastName} onChange={(e) => setLastName(e.target.value)} /><br />
            <input type="email" id="email" placeholder="Email" value={email} onChange={(e) => setEmail(e.target.value)} /><br />
            <input type="text" id="login" placeholder="Username" value={login} onChange={(e) => setLogin(e.target.value)} /><br />
            <input type="password" id="password" placeholder="Password" value={password} onChange={(e) => setPassword(e.target.value)} /><br />
            <input type="submit" id="registerButton" className="buttons" value="Register" onClick={doRegister} />
            <p>{message}</p>
        </div>
    );
}

export default Register;
