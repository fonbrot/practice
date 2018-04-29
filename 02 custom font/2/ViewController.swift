//
//  ViewController.swift
//  2
//


import UIKit

class ViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var text1: UITextView!
    @IBOutlet weak var text2: UITextView!
    @IBOutlet weak var text3: UITextView!
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let font1 = UIFont(name: "HiMelody-Regular", size: UIFont.labelFontSize) else {
            fatalError("error load font")
        }
        guard let font2 = UIFont(name: "PoorStory-Regular", size: UIFont.labelFontSize) else {
            fatalError("error load font")
        }
        guard let font3 = UIFont(name: "Jua-Regular", size: UIFont.labelFontSize) else {
            fatalError("error load font")
        }
        
        text1.font = UIFontMetrics.default.scaledFont(for: font1)
        text1.adjustsFontForContentSizeCategory = true
        text2.font = UIFontMetrics.default.scaledFont(for: font2)
        text2.adjustsFontForContentSizeCategory = true
        text3.font = UIFontMetrics.default.scaledFont(for: font3)
        text3.adjustsFontForContentSizeCategory = true
    }

   
}

