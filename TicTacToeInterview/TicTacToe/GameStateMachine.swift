//
//  GameStateMachine.swift
//  TicTacToe
//
//  Created by Jaron Lowe on 10/17/21.
//

import Foundation

protocol GameStateMachineDelegate: AnyObject {
    
    func gameStateMachine(_ gameStateMachine: GameStateMachine, hasChangedState state: GameStateMachine.State)
    
}

final class GameStateMachine {
    
    // MARK: Properties
    
    var positions: [[Int?]] = []
    private var movesMade = 0
    private var rowScores: [Int] = []
    private var columnsScores: [Int] = []
    private var diagonalScore = 0
    private var antidiagonalScore = 0
    
    private var currentState: State = .playerTurn(playerIndex: 0) {
        didSet {
            delegate?.gameStateMachine(self, hasChangedState: currentState)
        }
    }
    weak var delegate: GameStateMachineDelegate? {
        didSet {
            delegate?.gameStateMachine(self, hasChangedState: currentState)
        }
    }
    
    // MARK: Init
    
    init() {
        resetGameState()
    }
    
    // MARK: Methods
    
    func triggerEvent(event: Event) {
        switch (currentState, event) {
        case (.playerTurn(let playerIndex), .takeTurn(let turn)):
            if isValidTurn(turn) {
                if let gameEndState = takeTurn(playerIndex: playerIndex, turn: turn) {
                    currentState = .gameOver(gameEndState)
                } else {
                    currentState = .playerTurn(playerIndex: (playerIndex + 1) % 2)
                }
            }
        case (_, .reset):
            resetGameState()
        case (.gameOver(_), _):
            break
        }
    }
    
}

// MARK: - Private Methods

private extension GameStateMachine {
    
    func resetGameState() {
        positions = Array(repeating: Array(repeating: nil, count: 3), count: 3)
        movesMade = 0
        rowScores = Array(repeating: 0, count: 3)
        columnsScores = Array(repeating: 0, count: 3)
        diagonalScore = 0
        antidiagonalScore = 0
        currentState = .playerTurn(playerIndex: 0)
    }
    
    func takeTurn(playerIndex: Int, turn: GameTurn) -> GameEndState? {
        let playerChangeScore = playerIndex == 1 ? 1 : -1
        let boardSize = 3
        
        positions[turn.x][turn.y] = playerIndex
        movesMade += 1
        rowScores[turn.y] += playerChangeScore
        columnsScores[turn.x] += playerChangeScore
        if turn.x == turn.y { diagonalScore += playerChangeScore }
        if (turn.x + turn.y) == 2 { antidiagonalScore += playerChangeScore }
        
        if abs(rowScores[turn.y]) == boardSize
            || abs(columnsScores[turn.x]) == boardSize
            || abs(diagonalScore) == boardSize
            || abs(antidiagonalScore) == boardSize {
            return .playerWin(playerIndex: playerIndex)
        }
        
        if isBoardFull() { return .tie }

        return nil
    }
    
    func isValidTurn(_ turn: GameTurn) -> Bool {
        return (positions[turn.x][turn.y] == nil)
    }
    
    func isBoardFull() -> Bool {
        return (movesMade == 9)
    }
    
}

// MARK: - Structs and Enums

extension GameStateMachine {
    
    struct GameTurn {
        let x: Int
        let y: Int
    }
    
    enum State: Equatable {
        case playerTurn(playerIndex: Int)
        case gameOver(GameEndState)
        
        var title: String {
            switch self {
            case .playerTurn(let playerIndex):
                return "Player \(playerIndex + 1)'s turn"
            case .gameOver(let endState):
                return endState.title
            }
        }
    }
    
    enum Event {
        case takeTurn(turn: GameTurn)
        case reset
    }
    
    enum GameEndState: Equatable {
        case tie
        case playerWin(playerIndex: Int)
        
        var title: String {
            switch self {
            case .tie:
                return "Tie game!"
            case .playerWin(let playerIndex):
                return "Player \(playerIndex + 1) Won!"
            }
        }
    }
    
}
