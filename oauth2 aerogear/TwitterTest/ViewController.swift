//
//  ViewController.swift
//  TwitterTest
//
//  Created by 1 on 06/05/2018.
//  Copyright © 2018 av. All rights reserved.
//

import UIKit
import AeroGearHttp
import AeroGearOAuth2


class ViewController: UIViewController {
    
    private let http = Http(baseURL: "https://www.googleapis.com")
    
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
        let googleConfig = GoogleConfig(clientId: "", scopes: ["https://www.googleapis.com/auth/drive"])
        let gdModule = AccountManager.addGoogleAccount(config: googleConfig)
        http.authzModule = gdModule
        guard let data = UIImageJPEGRepresentation(image, 0.5) else { return }
        let multipartData = MultiPartData(data: data, name: "image", filename: "photo", mimeType: "image/jpeg")
        let multipartArray = ["file": multipartData]
        http.request(method: .post, path: "/upload/drive/v2/files", parameters: multipartArray) { (response, error) in
            if error != nil {
                print("error: \(error)")
            } else {
                print("ok")
            }
        }
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
