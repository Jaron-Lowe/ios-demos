//
//  ViewController.swift
//  FeaturedCollectionViewLayout
//
//  Created by Jaron Lowe on 3/5/21.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    
    // IBOutlets
    @IBOutlet weak var collectionViewA: UICollectionView!
    @IBOutlet weak var collectionViewB: UICollectionView!
    
    // Variables
    private var colors: [UIColor] = [.systemRed, .systemOrange, .systemYellow, .systemGreen, .systemBlue, .systemPurple, .systemPink]
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewA.register(UINib(nibName: "TestCell", bundle: nil), forCellWithReuseIdentifier: TestCell.identifier)
        collectionViewB.register(UINib(nibName: "TestCell", bundle: nil), forCellWithReuseIdentifier: TestCell.identifier)
        
        collectionViewB.decelerationRate = .fast
    }

}

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCell.identifier, for: indexPath) as? TestCell else {
            fatalError("Could not dequeue expected cell.")
        }
        
        let color: UIColor
        if collectionView === collectionViewA { color = colors[indexPath.row] }
        else { color = colors.reversed()[indexPath.row] }

        cell.configure(color: color, index: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
}
