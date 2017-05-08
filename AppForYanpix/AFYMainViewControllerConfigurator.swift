//
//  AFYMainViewControllerConfigurator.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/8/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class AFYMainViewControllerConfigurator: NSObject {

    static func shared() -> AFYMainViewControllerConfigurator
    {
        return AFYMainViewControllerConfigurator()
    }
    
    func configure(_ viewController: AFYMainViewController)
    {
        let interactor = AFYMainViewControllerInteractor()
        viewController.output = interactor
        
        let presenter = AFYMainViewControllerPresenter()
        interactor.output = presenter
        
        presenter.output = viewController
    }
    
}
