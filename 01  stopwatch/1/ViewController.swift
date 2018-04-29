//
//  ViewController.swift
//  1
//


import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    var counter = 0.0 {
        didSet {
            timeLabel.text = String(format: "%.1f", counter)
        }
    }
    
    var timer = Timer()
    var isActive = false
    
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    //MARK: Actions
    @IBAction func start(_ sender: UIButton) {
        playBtn.isEnabled = false
        pauseBtn.isEnabled = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [unowned self] _ in
            self.counter += 0.1
        }
    }
    
    @IBAction func pause(_ sender: UIButton) {
        playBtn.isEnabled = true
        pauseBtn.isEnabled = false
        timer.invalidate()
        isActive = false
    }
    
    @IBAction func reset(_ sender: UIButton) {
        timer.invalidate()
        isActive = false
        counter = 0.0
        timeLabel.text = String(counter)
        playBtn.isEnabled = true
        pauseBtn.isEnabled = false
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

