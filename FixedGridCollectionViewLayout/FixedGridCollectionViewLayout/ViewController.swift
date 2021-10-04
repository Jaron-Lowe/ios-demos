//
//  ViewController.swift
//  FixedGridCollectionViewLayout
//
//  Created by Jaron Lowe on 3/8/21.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    
    // IBOutlets
    @IBOutlet weak var collectionView: SelfSizedCollectionView!
    
    // Variables
    private var cellCount = 9

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.collectionView.invalidateIntrinsicContentSize()
        })
    }
    
    // MARK: IBActions
    
    @IBAction func randomizeButtonPressed(_ sender: UIButton) {
        let newCount = Int.random(in: 3...12)
        if newCount == cellCount {
            randomizeCellCount()
            return
        }
        cellCount = newCount
        collectionView.reloadData()
    }
    
    // MARK: Methods
    
    func randomizeCellCount() {
        
    }

}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCell.idenifier, for: indexPath) as? TestCell else {
            fatalError("Could not dequeue expected cell.")
        }
        return cell
    }
}


final class TestCell: UICollectionViewCell {
    
    static let idenifier = "cell"
    
}
