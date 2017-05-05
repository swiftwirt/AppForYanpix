//
//  AppDelegate.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/3/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var applicationManager = AFYApplicationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        applicationManager.clearKeychainIfThisIsTheFirstRun()   
        return true
    }
}

