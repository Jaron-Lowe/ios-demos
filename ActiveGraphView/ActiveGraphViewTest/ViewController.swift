//
//  ViewController.swift
//
//  Created by Jaron Lowe on 8/3/21.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var horizontalActiveGraph: ActiveGraphView!
    @IBOutlet weak var verticalActiveGraph: ActiveGraphView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let horizontalConfiguration = ActiveGraphView.Configuration(
            colors: [.systemRed, .systemOrange, .systemYellow, .systemGreen, .systemBlue],
            axis: .horizontal,
            spacing: 2.0,
            growthWeight: 1.0,
            inactiveAlpha: 0.5,
            shouldAnimateChanges: true
        )
        
        let verticalConfiguration = ActiveGraphView.Configuration(
            colors: [.systemRed, .systemOrange, .systemYellow, .systemGreen],
            axis: .vertical,
            spacing: 2.0,
            growthWeight: 2.0,
            inactiveAlpha: 0.5,
            shouldAnimateChanges: true
        )
        horizontalActiveGraph.configure(configuration: horizontalConfiguration)
        verticalActiveGraph.configure(configuration: verticalConfiguration)
        
        
    }
    
    // MARK: - IBActions
    
    @IBAction func onePressed(_ sender: Any) {
        toggleIndex(index: 0)
    }
    
    @IBAction func twoPressed(_ sender: Any) {
        toggleIndex(index: 1)
    }
    
    @IBAction func threePressed(_ sender: Any) {
        toggleIndex(index: 2)
    }
    
    @IBAction func fourPressed(_ sender: Any) {
        toggleIndex(index: 3)
    }
    
    @IBAction func fivePressed(_ sender: Any) {
        toggleIndex(index: 4)
    }
}


// MARK: - Private Methods

private extension ViewController {
    
    func toggleIndex(index: Int) {
        for activeGraph in [horizontalActiveGraph, verticalActiveGraph] {
            if activeGraph?.activeIndex == index {
                activeGraph?.activeIndex = nil
            } else {
                activeGraph?.activeIndex = index
            }
        }
    }
    
}

