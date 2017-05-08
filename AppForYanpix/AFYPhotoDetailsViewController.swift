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
    
    var location: Location!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        loadImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    // MARK: - Main methods
    
    fileprivate func loadImage()
    {
        imageView.sd_setImage(with: location.standartResolutionImageLink) { [weak self] (image, error, cacheType, url) in
            guard error == nil, self != nil else { return }
        }
    }

}
