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
    
    var location: Location!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.setNavigationBarHidden(false, animated: false)
        saveBarItem.isEnabled = false
        addFirebaseObserver()
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
            case .failure(let error):
                print(error ?? "")
                HUD.flash(.error)
            }
        })
    }
    
    fileprivate func loadImage()
    {
        imageView.sd_setImage(with: location.standartResolutionImageLink) { [weak self] (image, error, cacheType, url) in
            guard error == nil, self != nil else { return }
            DispatchQueue.main.async {
                self?.saveBarItem.isEnabled = true
            }
        }
    }
    
    func addFirebaseObserver()
    {
        applicationManager.firebaseService.observerResult = { (result) in
            switch result {
            case .success(let value):
                print(value)
                guard let links = value as? [String] else { HUD.flash(.error); return }
                self.applicationManager.userService?.userSavedPhotoLinks = links
                HUD.flash(.success)
            case .failure(let error):
                print(error ?? "")
                HUD.flash(.error)
            }
        }
    }
    
    @IBAction func onPressedSaveBarItem(_ sender: Any)
    {
        loadToFirebase()
    }
}
