import ReactDOM from 'react-dom'
import React from 'react'
import App from "./components/App";
import { AuthClient } from '@dfinity/auth-client';

const init = async () => { 

  const authClient = await AuthClient.create();
  const manualLogin = true; // just so i dont nid to login lol, change to false later

  if(await authClient.isAuthenticated() || manualLogin) {
    handleAuthenticated(authClient);
  } else {
    await authClient.login({
      identityProvider: "https://identity.ic0.app/#authorize",
      onSuccess: () => {
        handleAuthenticated(authClient);
      }
    })
  }

  
}

async function handleAuthenticated(authClient) {
  ReactDOM.render(<App />, document.getElementById("root"));
}

init();


