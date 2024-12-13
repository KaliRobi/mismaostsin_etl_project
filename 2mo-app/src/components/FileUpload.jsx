import React, { useState, useEffect } from 'react';
import { uploadData } from 'aws-amplify/storage';
import { getCurrentUser } from 'aws-amplify/auth';

function FileUpload() {
  const [file, setFile] = useState(null);
  const [uploading, setUploading] = useState(false);
  const [message, setMessage] = useState('');
  const [user, setUser] = useState(null);

 
  useEffect(() => {
    // Check if a user session is stored in localStorage
    const storedUser = localStorage.getItem('user');
    if (storedUser) {
      setUser(JSON.parse(storedUser));
    } else {
      getAuthenticatedUser();
    }
  }, []);

  // Fetch user session from Amplify
  
  const getAuthenticatedUser = async  () => {
      const sessionUser = await getCurrentUser(); 
      if (sessionUser) {
        setUser(sessionUser);
        localStorage.setItem('user', JSON.stringify(sessionUser)); 
      } else {
        setMessage('User is not authenticated.');
      }
  }

  const handleFileChange = (e) => {
    setFile(e.target.files[0]);
  };

  const handleFileUpload = async () => {
    if (!file) {
      setMessage('Please select a file to upload');
      return;
    }

    setUploading(true); // Start uploading
    if (!user ) {
      setMessage('User is not authenticated.');
      setUploading(false);
      return;
    }

    try {
      const result = await uploadData({
        identityID: user.identityId,  
        path: `uploads/${file.name}`, 
        // fileName: file.name,
        // contentType: file.type,
        data: file
      });

      setMessage('File uploaded successfully');
    } catch (error) {
      console.error('Error uploading file:', error);
      setMessage('Error uploading file: ' + error.message);
    } finally {
      setUploading(false);
    }
  };

  return (
    <div className="upload-container">
      <h3 className="upload-title">Upload Image to S3</h3>
      <input
        type="file"
        accept="image/*"
        className="upload-input"
        onChange={handleFileChange}
      />
      <button
        className="upload-button"
        onClick={handleFileUpload}
        disabled={uploading}
      >
        {uploading ? 'Uploading...' : 'Upload File'}
      </button>
      {message && <p className="upload-message">{message}</p>}
    </div>
  );
}

export default FileUpload;
