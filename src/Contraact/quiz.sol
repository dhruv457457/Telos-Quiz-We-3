// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract QuizGame is ReentrancyGuard {
    struct Question {
        string questionText;
        string[4] options;
        uint8 correctAnswer; // Index of the correct option (0-3)
        uint256 timeLimit; // Seconds
        bool active;
    }

    struct Player {
        uint256 score;
        uint256 attemptsToday;
        uint256 lastAttempt;
    }

    Question[] private questions; // Updated to private
    mapping(address => Player) public players;

    address public admin;
    uint256 public dailyAttemptLimit = 3;

    event QuestionAdded(uint256 questionCount);
    event AnswerSubmitted(address indexed player, uint256 questionId, bool correct);
    event DailyLimitUpdated(uint256 newLimit);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /// @notice Adds a new question to the game
    function addQuestion(
        string memory _text,
        string[4] memory _options,
        uint8 _correctAnswer,
        uint256 _timeLimit
    ) external onlyAdmin {
        require(_correctAnswer < 4, "Invalid correct answer index");
        require(_timeLimit > 0, "Invalid time limit");

        questions.push(
            Question({
                questionText: _text,
                options: _options,
                correctAnswer: _correctAnswer,
                timeLimit: _timeLimit,
                active: true
            })
        );
        emit QuestionAdded(questions.length); // Emit updated count
    }

    /// @notice Submit an answer for a question
    function submitAnswer(uint256 _questionId, uint8 _answer) external nonReentrant {
        require(_questionId < questions.length, "Invalid question ID");
        require(questions[_questionId].active, "Inactive question");
        require(_answer < 4, "Invalid answer index");

        Player storage player = players[msg.sender];

        // Reset daily attempts if the last attempt was over 24 hours ago
        if (block.timestamp > player.lastAttempt + 1 days) {
            player.attemptsToday = 0;
        }

        require(player.attemptsToday < dailyAttemptLimit, "Daily limit reached");

        player.attemptsToday++;
        player.lastAttempt = block.timestamp;

        bool isCorrect = questions[_questionId].correctAnswer == _answer;
        if (isCorrect) {
            player.score += 10; // Award 10 points for a correct answer
        }

        emit AnswerSubmitted(msg.sender, _questionId, isCorrect);
    }

    /// @notice Updates the daily attempt limit
    function setDailyLimit(uint256 _limit) external onlyAdmin {
        require(_limit > 0, "Invalid limit");
        dailyAttemptLimit = _limit;
        emit DailyLimitUpdated(_limit);
    }

    /// @notice Get a specific question
    function getQuestion(uint256 _questionId)
        external
        view
        returns (
            string memory questionText,
            string[4] memory options,
            uint8 correctAnswer,
            uint256 timeLimit,
            bool active
        )
    {
        require(_questionId < questions.length, "Invalid question ID");
        Question memory q = questions[_questionId];
        return (q.questionText, q.options, q.correctAnswer, q.timeLimit, q.active);
    }

    /// @notice Get all questions
    function getAllQuestions()
        external
        view
        returns (Question[] memory)
    {
        return questions;
    }

    /// @notice Get the total number of questions
    function questionCount() external view returns (uint256) {
        return questions.length;
    }

    /// @notice Get the stats for a specific player
    function getPlayerStats(address _player)
        external
        view
        returns (uint256 score, uint256 attemptsToday, uint256 lastAttempt)
    {
        Player memory p = players[_player];
        return (p.score, p.attemptsToday, p.lastAttempt);
    }
}
