//
//  AFYApplicationRouter.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/8/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class AFYApplicationRouter {
    
    struct StoryboardName {
        static let initial = "AFYInitialScene"
        static let main = "AFYMainScene"
        
        private init() {}
    }

    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func showCredentialsScene()
    {
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard = UIStoryboard(name: StoryboardName.initial, bundle: nil)
        
        let rootController = mainStoryboard.instantiateInitialViewController()
        assert(rootController != nil)
        appDelegate.window?.rootViewController = rootController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func showMainScene()
    {
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard = UIStoryboard(name: StoryboardName.main, bundle: nil)
        
        let rootController = mainStoryboard.instantiateInitialViewController()
        assert(rootController != nil)
        appDelegate.window?.rootViewController = rootController
        appDelegate.window?.makeKeyAndVisible()
    }
    
}
