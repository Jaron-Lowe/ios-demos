//
//  ViewController.swift
//  TicTacToe
//
//  Created by Jaron Lowe on 10/13/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

struct Player: Identifiable {
    
    let id: Int
    let name: String
    
}

protocol GameStateMachineDelegate: AnyObject {
    
    func gameStateMachine(_ gameStateMachine: GameStateMachine, hasChangedState state: GameStateMachine.State)
    
}

final class GameStateMachine {
    
    let players: [Player]
    let playerSymbols = ["X", "O"]
    var positions: [[Int?]] = []
    var currentState: State = .player1Turn {
        didSet {
            delegate?.gameStateMachine(self, hasChangedState: currentState)
        }
    }
    weak var delegate: GameStateMachineDelegate?
    let winConditions: [[[Int]]] = [
        [[0, 0], [0, 1], [0, 2]],
        [[1, 0], [1, 1], [1, 2]],
        [[2, 0], [2, 1], [2, 2]],
        [[0, 0], [1, 0], [2, 0]],
        [[0, 1], [1, 1], [2, 1]],
    ]
    
    init(player1: Player, player2: Player, delegate: GameStateMachineDelegate) {
        players = [player1, player2]
        resetGameState()
    }
    
    
    func resetGameState() {
        positions = Array(repeating: Array(repeating: nil, count: 3), count: 3)
        currentState = .player1Turn
    }
    
    func triggerEvent(event: Event) {
        switch (currentState, event) {
        case (.player1Turn, .takeTurn(let playerIndex, let x, let y)), (.player2Turn, .takeTurn(let playerIndex, let x, let y)):
            if isValidTurn(playerIndex: playerIndex, x: x, y: y) {
                if let gameEndState = takeTurn(playerIndex: playerIndex, x: x, y: y) {
                    currentState = .gameOver(gameEndState)
                } else {
                    if currentState == .player1Turn {
                        currentState = .player2Turn
                    } else {
                        currentState = .player1Turn
                    }
                }
            }
        case (_, .reset):
            resetGameState()
        case (.gameOver(_), _):
            break
        }
    }
    
    func isValidTurn(playerIndex: Int, x: Int, y: Int) -> Bool {
        return positions[x][y] == nil
    }
    
    func isBoardFull() -> Bool {
        for row in positions {
            for column in row {
            }
        }
        return true
    }
    
    func indexOfWinningPlayer(playerIndex: Int) -> Int? {
        for condition in winConditions {
            for point in condition {
                
            }
        }
        return nil
    }
    
    // TODO: Win conditions
    
    func takeTurn(playerIndex: Int, x: Int, y: Int) -> GameEndState? {
        positions[x][y] = playerIndex
        
        // TODO: Determine if game is over.
            // TODO: Check for win
            // TODO: Check board full
        return nil
    }
    
}

extension GameStateMachine {
    
    enum State: Equatable {
        case player1Turn
        case player2Turn
        case gameOver(GameEndState)
    }
    
    enum Event {
        case takeTurn(playerIndex: Int, x: Int, y: Int)
        case reset
    }
    
}

enum GameEndState: Equatable {
    
    case tie
    case playerWin(playerIndex: Int)
    
}
