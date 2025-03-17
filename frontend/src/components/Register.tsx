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

    function handleSetFirstName(e: any): void {
        setFirstName(e.target.value);
    }

    function handleSetLastName(e: any): void {
        setLastName(e.target.value);
    }

    function handleSetEmail(e: any): void {
        setEmail(e.target.value);
    }

    function handleSetLogin(e: any): void {
        setLogin(e.target.value);
    }

    function handleSetPassword(e: any): void {
        setPassword(e.target.value);
    }

    async function doRegister(event: any): Promise<void> {
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

            const contentType = response.headers.get('content-type');
            if (!contentType || !contentType.includes('application/json')) {
                throw new TypeError("Received non-JSON response");
            }

            const res = await response.json();

            if (res.error) {
                alert('Registration failed: ' + res.error);
            } else {
                alert('Registration successful!');
                window.location.href = '/login';
            }
        } catch (error: any) {
            alert(error.toString());
        }
    }

    return (
        <div id="registerDiv">
            <span id="inner-title">REGISTER</span><br />
            <input type="text" id="firstName" placeholder="First Name" value={firstName} onChange={handleSetFirstName} /><br />
            <input type="text" id="lastName" placeholder="Last Name" value={lastName} onChange={handleSetLastName} /><br />
            <input type="email" id="email" placeholder="Email" value={email} onChange={handleSetEmail} /><br />
            <input type="text" id="login" placeholder="Username" value={login} onChange={handleSetLogin} /><br />
            <input type="password" id="password" placeholder="Password" value={password} onChange={handleSetPassword} /><br />
            <input type="submit" id="registerButton" className="buttons" value="Register" onClick={doRegister} />
        </div>
    );
}

export default Register;