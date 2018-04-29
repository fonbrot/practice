//
//  PlayerView.swift
//  09 video background
//
//  Created by 1 on 08/04/2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit
import AVKit

class PlayerView: UIView {

    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
}
