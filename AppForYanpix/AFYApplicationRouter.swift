//
//  AFYApplicationRouter.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/5/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class AFYApplicationRouter {
    
    func showMainScreen()
    {
        
    }

    func display<T>(_ viewController: T) where T: UIViewController, T: ModalDismissable
    {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? AFYInitialViewController else { return }
        
        var viewController = viewController
        viewController.modalDismissable = true
        if rootViewController.presentedViewController is ModalDismissable {
                rootViewController.presentedViewController?.dismiss(animated: false, completion: nil)
            }
        rootViewController.present(viewController, animated: false, completion: nil)
    }
}

