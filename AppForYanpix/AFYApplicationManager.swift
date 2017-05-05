//
//  AFYApplicationManager.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/3/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class AFYApplicationManager {
    
    static func instance() -> AFYApplicationManager
    {
        guard let applicationDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        return applicationDelegate.applicationManager
    }
    
    let keychain = AFYKeychainService()
    
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
        let key = "firstRunComplete"
        let firstRunComplete = defaults.bool(forKey: key)
        if !firstRunComplete {
            keychain.clear()
            defaults.set(true, forKey: key)
        }
    }

}
