//
//  AFYPhotoDetailsViewController.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/7/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit
import PKHUD

class AFYPhotoDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveBarItem: UIBarButtonItem!
    
    fileprivate var applicationManager = AFYApplicationManager.instance()
    
    var link: URL?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.setNavigationBarHidden(false, animated: false)
        saveBarItem.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadImage()
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    // MARK: - Main methods
    
    func loadToFirebase()
    {
        HUD.show(.progress)
        guard let userName = applicationManager.userService?.userName, let image = imageView.image else { HUD.flash(.error); return }
        applicationManager.firebaseService.upload(image, for: userName, completionHandler: { [weak self]( result) in
            switch result {
            case .success(let value):
                print(value)
                guard let text = value as? String else { HUD.flash(.error); return }
                self?.applicationManager.firebaseService.save(text, for: userName)
                HUD.flash(.success)
            case .failure(let error):
                print(error ?? "")
                HUD.flash(.error)
            }
        })
    }
    
    fileprivate func loadImage()
    {
        guard let url = link else { return }
        imageView.sd_setImage(with: url) { [weak self] (image, error, cacheType, url) in
            guard error == nil, self != nil else { return }
            DispatchQueue.main.async {
                self?.saveBarItem.isEnabled = true
            }
        }
    }
    
    @IBAction func onPressedSaveBarItem(_ sender: Any)
    {
        loadToFirebase()
    }
}
