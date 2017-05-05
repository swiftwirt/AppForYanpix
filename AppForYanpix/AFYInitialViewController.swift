//
//  InitialViewController.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/3/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

protocol ModalDismissable {
    var modalDismissable: Bool { get set }
}

class AFYInitialViewController: UIViewController, UIWebViewDelegate, ModalDismissable {

    @IBOutlet var webView: UIWebView!
    
    fileprivate let applicationManager = AFYApplicationManager.instance()
    
    var modalDismissable: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performRequest()
    }
    
    // MARK: - Main methods
    
    fileprivate func performRequest()
    {
        guard let request = applicationManager.instagramFeedService.tokenRequest else { return }
        webView.loadRequest(request)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        applicationManager.instagramFeedService.saveToken(_from: request)
        if !applicationManager.instagramFeedService.needsShowCredentialsForm {
            applicationManager.applicationRouter.display(<#T##viewController: ModalDismissable##ModalDismissable#>)
        }
        return applicationManager.instagramFeedService.needsShowCredentialsForm
    }

}
