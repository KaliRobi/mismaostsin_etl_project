const awsconfig = {
  Auth: {
    Cognito: {
      userPoolId: process.env.REACT_APP_USER_POOL_ID,  
      identityPoolId: process.env.REACT_APP_IDENTITY_POOL_ID,  
      region: process.env.REACT_APP_AWS_REGION,  
      userPoolClientId: process.env.REACT_APP_USER_POOL_WEB_CLIENT_ID, 
    }
  },
  Storage: {
    S3: {
        bucket: process.env.REACT_APP_S3_BUCKET,  
        region: process.env.REACT_APP_AWS_REGION,  
    } 
  },
};
    
export default awsconfig;
    


