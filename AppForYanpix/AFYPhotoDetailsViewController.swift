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
    
    fileprivate var applicationManager = AFYApplicationManager.instance()
    
    var location: Location!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        applicationManager.firebaseService.observerResult = { (result) in
            switch result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error ?? "")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadImage()
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    // MARK: - Main methods
    
    fileprivate func loadImage()
    {
        imageView.sd_setImage(with: location.standartResolutionImageLink) { [weak self] (image, error, cacheType, url) in
            guard error == nil, self != nil else { return }
            guard let userName = self?.applicationManager.userService?.userName else { return }
            self?.applicationManager.firebaseService.upload(image!, for: userName, completionHandler: { ( result) in
                switch result {
                case .success(let value):
                    print(value)
                    guard let text = value as? String else { return }
                    self?.applicationManager.firebaseService.save(text, for: userName)
                case .failure(let error):
                    print(error ?? "")
                }
            })
        }
    }

}
