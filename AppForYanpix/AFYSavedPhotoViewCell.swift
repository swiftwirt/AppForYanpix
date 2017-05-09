//
//  AFYSavedPhotoesViewCell.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/9/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class AFYSavedPhotoViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var link: String! {
        didSet {
            guard let url = URL(string: link) else { return }
            imageView.sd_setImage(with: url)
        }
    }
}
