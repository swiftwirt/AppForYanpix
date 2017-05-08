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
}
