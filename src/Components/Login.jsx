import React from "react";

const Login = (props) => {
    return (
        <div className="login-container">
            <h1 className="welcome-message">🌐 Welcome to the Decentralized Voting Application</h1>
            <p className="login-description">
                Secure, transparent, and decentralized voting at your fingertips. Connect your MetaMask wallet to participate!
            </p>
            <button className="login-button" onClick={props.connectWallet}>
                🔗 Connect with MetaMask
            </button>
        </div>
    );
};

export default Login;
