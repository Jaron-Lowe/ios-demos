//
//  ViewController.swift
//  MulticolorAttributedStringTest
//
//  Created by Jaron Lowe on 4/6/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var testLabelLinked: UILabel!
    @IBOutlet weak var anotherTestLabelLinked: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.testLabelLinked.attributedText = "Favorites".highlightedFirstWordString(highlightColor: .red)
        self.anotherTestLabelLinked.attributedText = "New Classes".highlightedFirstWordString(highlightColor: .systemTeal)
    }

}

extension String {
    
    func highlightedFirstWordString(highlightColor: UIColor) -> NSAttributedString {
        guard let firstWord = self.components(separatedBy: " ").first
        else { return NSAttributedString(string: self) }
        
        let firstWordRange = NSRange(location: 0, length: firstWord.count)
        let result = NSMutableAttributedString(string: self)
        result.addAttribute(NSAttributedString.Key.foregroundColor, value: highlightColor, range: firstWordRange)
        return result
    }
    
}
