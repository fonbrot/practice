//
//  ViewController.swift
//  09 video background
//
//  Created by 1 on 08/04/2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    
    enum Constants {
        static let buttonHeight = 40
    }

    var player: AVPlayer?
    var playerView: PlayerView!
    var loginBtn: UIButton!
    var signupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playerView.snp.makeConstraints {(make) in
            make.edges.equalTo(view)
        }
        
        configureButtons()
    }
    
    func configurePlayer() {
        playerView = PlayerView()
        view.addSubview(playerView)

        playerView.backgroundColor = UIColor.clear

       guard let url = Bundle.main.url(forResource: "moments.mp4", withExtension: nil) else {return}
        player = AVPlayer(url: url)
        playerView.player = player
        playerView.playerLayer.videoGravity = .resizeAspectFill
        player?.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loopVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func configureButtons() {
        signupBtn = UIButton()
        view.addSubview(signupBtn)
        signupBtn.setTitle("SignUp", for: .normal)
        signupBtn.backgroundColor = UIColor.white
        signupBtn.setTitleColor(UIColor.green, for: .normal)
        
        signupBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20).priority(750)
            make.right.equalTo(view).offset(-20).priority(750)
            make.width.lessThanOrEqualTo(400)
            make.bottom.equalTo(view).offset(-20)
            make.height.equalTo(Constants.buttonHeight)
            make.centerX.equalTo(view)
        }
        
        loginBtn = UIButton()
        view.addSubview(loginBtn)
        loginBtn.setTitle("Login", for: .normal)
        loginBtn.backgroundColor = UIColor.green
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        
        loginBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20).priority(750)
            make.right.equalTo(view).offset(-20).priority(750)
            make.width.equalTo(signupBtn)
            make.bottom.equalTo(signupBtn.snp.top).offset(-20)
            make.height.equalTo(Constants.buttonHeight)
            make.centerX.equalTo(view)
        }
    }
    
    @objc func loopVideo() {
        player?.seek(to: kCMTimeZero)
        player?.play()
    }


}

