//
//  ViewController.swift
//  TwitterTest
//
//  Created by 1 on 06/05/2018.
//  Copyright © 2018 av. All rights reserved.
//

import UIKit
import OAuthSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(chooseImage))
    }

    @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .savedPhotosAlbum
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func shareImage() {
        guard let image = imageView.image else { return }
        guard let data = UIImageJPEGRepresentation(image, 0.5) else { return }
        
        let oauthswift = OAuth2Swift(consumerKey: "", consumerSecret: "", authorizeUrl: "https://accounts.google.com/o/oauth2/auth", accessTokenUrl: "https://accounts.google.com/o/oauth2/token", responseType: "code")
        
        oauthswift.allowMissingStateCheck = true
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
        
        guard let rwURL = URL(string: "apple.ru.TwitterTest:/oauth2Callback") else { return}
        
        oauthswift.authorize(withCallbackURL: rwURL, scope: "https://www.googleapis.com/auth/drive", state: "", success: { (credential, response, parameters) in
            oauthswift.client.postImage("https://www.googleapis.com/upload/drive/v2/files", parameters: parameters, image: data, success: { (response) in
                if let _ = try? JSONSerialization.jsonObject(with: response.data, options: []) {
                    print("ok")
                }
            }, failure: { (error) in
                print("error")
                })
        }, failure: { (error) in
            print("error")
            })
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
    }
}
