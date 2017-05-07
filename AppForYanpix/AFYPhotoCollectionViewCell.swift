//
//  AFYPhotoCollectionViewCell.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/7/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class AFYPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageLink: URL! {
        didSet {
            imageView.sd_setImage(with: imageLink)
        }
    }
}
