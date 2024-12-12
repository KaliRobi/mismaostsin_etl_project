// https://docs.amplify.aws/gen1/javascript/build-a-backend/auth/enable-sign-up/

import React, { useState } from 'react';
import { signIn } from 'aws-amplify/auth';

const LogIn = ({ setUser, setError }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  //  login
  const handleLogin = async (e) => {
    e.preventDefault();
    setError('');
    try {
      const loggedInUser = await signIn({
        username: username,
        password: password,
        options: {
          authFlowType: 'USER_PASSWORD_AUTH',
          preferredChallenge: 'PASSWORD',
        },
        autoSignIn: true
      });
      setUser(loggedInUser);
      localStorage.setItem('user', JSON.stringify(loggedInUser)); 
      console.log(loggedInUser)
    } catch (err) {
      setError('Login failed: ' + err);
    }
  };

  return (
    <div className="login-container">
      <h2 className="login-title">2Mo</h2>
      <form className="login-form" onSubmit={handleLogin}>
        <input
          type="text"
          className="login-input"
          placeholder="Username"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
          required
        />
        <input
          type="password"
          className="login-input"
          placeholder="Password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
        />
        <button type="submit" className="login-button">Sign In</button>
      </form>
    </div>
  );
};

export default LogIn;



