import { useState } from 'react';

const app_name = 'fitjourneyhome.com';

function buildPath(route:string): string {
    if (process.env.NODE_ENV !== 'development') {
        return 'http://' + app_name + ':5001/' + route;
    } else {
        return 'http://localhost:5001/' + route;
    }
}

function Login() {
    const [loginName, setLoginName] = useState('');
    const [loginPassword, setPassword] = useState('');
    const [message, setMessage] = useState('');

    function handleSetLoginName(e: any): void {
        setLoginName(e.target.value);
    }

    function handleSetPassword(e: any): void {
        setPassword(e.target.value);
    }

    async function doLogin(event: any): Promise<void> {
        event.preventDefault();
        const obj = { login: loginName, password: loginPassword };
        const js = JSON.stringify(obj);

        try {
            const response = await fetch(buildPath('api/login'), {
                method: 'POST',
                body: js,
                headers: { 'Content-Type': 'application/json' },
            });

            const res = await response.json();

            if (res.id <= 0) {
                setMessage('User/Password combination incorrect');
            } else {
                const user = { firstName: res.firstName, lastName: res.lastName, id: res.id };
                localStorage.setItem('user_data', JSON.stringify(user));

                setMessage('Login successful!');
                window.location.href = '/cards';
            }
        } catch (error: any) {
            alert(error.toString());
        }
    }

    return (
        <div id="loginDiv">
            <span id="inner-title">PLEASE LOG IN</span><br />
            <input type="text" id="loginName" placeholder="Username" value={loginName} onChange={handleSetLoginName} /><br />
            <input type="password" id="loginPassword" placeholder="Password" value={loginPassword} onChange={handleSetPassword} /><br />
            <input type="submit" id="loginButton" className="buttons" value="Do It" onClick={doLogin} />
            <br />
            <span id="loginResult">{message}</span>
        </div>
    );
}

export default Login;
