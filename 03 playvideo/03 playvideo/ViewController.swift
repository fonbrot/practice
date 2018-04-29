//
//  ViewController.swift
//  03 playvideo
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {

    var player: AVPlayer?
    var playerViewController: AVPlayerViewController!
    
    @IBAction func play(_ sender: UIButton) {
        present(playerViewController, animated: true)
        player?.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerViewController = AVPlayerViewController()
        playerViewController.entersFullScreenWhenPlaybackBegins = true
        playerViewController.exitsFullScreenWhenPlaybackEnds = true
        
        let url = Bundle.main.url(forResource: "zone", withExtension: "mp4")
        
            player = AVPlayer(url: url!)
            playerViewController.player = player
        
        
    }


}

