//
//  AFYPhotoDetailsViewController.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/7/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class AFYPhotoDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var imageLink: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        loadImage()
    }
    
    
    fileprivate func loadImage()
    {
        imageView.sd_setImage(with: imageLink) { [weak self] (image, error, cacheType, url) in
            guard error == nil, self != nil else { return }
        }
    }

}
