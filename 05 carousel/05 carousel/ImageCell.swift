//
//  ImageCell.swift
//  05 carousel
//
//  Created by 1 on 07/04/2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20.0
        clipsToBounds = true
    }
}
