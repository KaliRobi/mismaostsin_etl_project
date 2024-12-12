
import React, { useState } from 'react';
import { signOut } from 'aws-amplify/auth';  
import FileUpload from './components/FileUpload';  
import LogIn from './components/LogIn';  


const App = () => {
  const [user, setUser] = useState(null);
  const [error, setError] = useState('');

  //  logout
  const handleLogout = async () => {
    try {
      await signOut();
      setUser(null);  
    } catch (err) {
      setError('Logout failed: ' + err.message);
    }
  };

  return (
    <div className="container">
      {!user ? (
        <LogIn setUser={setUser} setError={setError} /> 
      ) : (
        <div className="logged-in">
          <h2>Welcome, {user.username}!</h2>
          <button className="logout" onClick={() => handleLogout()}>Log Out</button>
          <FileUpload /> 
        </div>
      )}
      {error && <p>{error}</p>} 
    </div>
  );
};

export default App;