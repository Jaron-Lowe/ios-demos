//
//  ViewController.swift
//  TicTacToe
//
//  Created by Jaron Lowe on 10/13/21.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var resetButton: UIButton!
    
    let gameStateMachine = GameStateMachine()
    
    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameStateMachine.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: IBActions
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        gameStateMachine.triggerEvent(event: .reset)
    }
    

}

// MARK: - Private Methods

private extension ViewController {
    
    func displayGameOverAlert(endState: GameStateMachine.GameEndState) {
        let alert = UIAlertController(title: "Game Over", message: endState.title, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: { [weak self] _ in
            self?.gameStateMachine.triggerEvent(event: .reset)
        }))
        
        present(alert, animated: true)
    }
    
}

// MARK: - GameStateMachineDelegate

extension ViewController: GameStateMachineDelegate {
    
    func gameStateMachine(_ gameStateMachine: GameStateMachine, hasChangedState state: GameStateMachine.State) {
        statusLabel.text = state.title
        if case .gameOver(let endState) = state {
            displayGameOverAlert(endState: endState)
        }
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicTacToeCollectionViewCell.identifier, for: indexPath) as? TicTacToeCollectionViewCell else {
            fatalError("Could not dequeue expected cell.")
        }
        
        let (x, y) = indexPath.columnBreakdown(columnCount: 3)
        
        let value = gameStateMachine.positions[x][y]
        cell.titleLabel.text = (value == nil) ? "" : (value! == 0) ? "X" : "O"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let (x, y) = indexPath.columnBreakdown(columnCount: 3)
        gameStateMachine.triggerEvent(event: .takeTurn(turn: GameStateMachine.GameTurn(x: x, y: y)))
    }
    
}
