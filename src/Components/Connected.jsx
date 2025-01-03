import React from "react";

const Connected = (props) => {
    return (
        <div className="connected-container">
            <h1 className="connected-header">🎉 You are Connected to MetaMask!</h1>
            <p className="connected-account">Connected Account: <strong>{props.account}</strong></p>
            <p className="connected-account">⏳ Remaining Time: <strong>{props.remainingTime} seconds</strong></p>
            
            {props.showButton ? (
                <p className="connected-message success">
                    ✅ You have already voted. Thank you for participating!
                </p>
            ) : (
                <div className="vote-section">
                    <input
                        type="number"
                        className="candidate-input"
                        placeholder="Enter Candidate Index"
                        value={props.number}
                        onChange={props.handleNumberChange}
                    />
                    <button className="vote-button" onClick={props.voteFunction}>
                        🗳️ Vote Now
                    </button>
                </div>
            )}
            
            <table id="candidatesTable" className="candidates-table">
                <thead>
                    <tr>
                        <th>Index</th>
                        <th>Candidate Name</th>
                        <th>Votes</th>
                    </tr>
                </thead>
                <tbody>
                    {props.candidates.map((candidate, index) => (
                        <tr key={index}>
                            <td>{candidate.index}</td>
                            <td>{candidate.name}</td>
                            <td>{candidate.voteCount}</td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
};

export default Connected;
