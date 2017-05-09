//
//  AFYApplicationManager.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/3/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class AFYApplicationManager {
    
    //Constants
    let firstRunKey = "firstRunComplete"
    
    static func instance() -> AFYApplicationManager
    {
        guard let applicationDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        return applicationDelegate.applicationManager
    }
    
    let keychain = AFYKeychainService()
    let router = AFYApplicationRouter()
    
    lazy var locationService: AFYLocationService = {
        let service = AFYLocationService()
        return service
    }()
    
    lazy var instagramFeedService: AFYInstagramFeedService = {
        let service = AFYInstagramFeedService()
        return service
    }()
    
    lazy var firebaseService: AFYFirebaseService = {
        let service = AFYFirebaseService()
        return service
    }()
    
    var userService: AFYUserService?
    
    func configureUser()
    {
        instagramFeedService.getUserJSON { (result) in
            switch result {
            case .success(let value):
                guard let dictionary = value as? [String: Any] else { return }
                self.userService = AFYUserService(_with: dictionary)
                self.firebaseService.getAllSavedPhotoLinks(for: (self.userService!.userName!)) { (result) in
                    switch result {
                    case .success(let value):
                        guard let dictionary = value as? [String: Any] else { return }
                        self.userService?.userSavedPhotoLinks = Array(dictionary.values) as! [String]
                    case .failure(let error):
                        print(error ?? "")
                    }                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func clearKeychainIfThisIsTheFirstRun()
    {
        let defaults = UserDefaults.standard
        let key = firstRunKey
        let firstRunComplete = defaults.bool(forKey: key)
        if !firstRunComplete {
            keychain.clear()
            defaults.set(true, forKey: key)
        }
    }
    
    func route()
    {
        guard keychain.getToken() != nil else {
            router.showCredentialsScene()
            return
        }
        
        router.showMainScene()
    }
    
    func addFirebaseObserver()
    {
        firebaseService.observerResult = { (result) in
            switch result {
            case .success(let value):
                print(value)
                guard let links = value as? [String] else { return }
                self.userService?.userSavedPhotoLinks = links
            case .failure(let error):
                print(error ?? "")
            }
        }
    }
}
