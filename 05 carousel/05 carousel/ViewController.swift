//
//  ViewController.swift
//  05 carousel
//
//  Created by 1 on 07/04/2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private enum CellIdentifiers {
        static let Cell = "Cell"
    }

    var images = ["1","2","3","4","5","6"]
    var names = ["first", "second", "third", "fourth", "fifth", "sixth"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.Cell, for: indexPath) as! ImageCell
        
        cell.imageView.image = UIImage(named: images[indexPath.item])
        cell.label.text = names[indexPath.item]
        
        return cell
    }
}

