//
//  InitialViewController.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/3/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class AFYInitialViewController: UIViewController, UIWebViewDelegate {
    
    struct SegueIdentifier {
        static let toMainScene = "SegueToMainScene"
        
        private init() {}
    }

    @IBOutlet weak var webView: UIWebView!
    
    fileprivate let applicationManager = AFYApplicationManager.instance()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !applicationManager.instagramFeedService.needsShowCredentialsForm {
            performSegue(withIdentifier: SegueIdentifier.toMainScene, sender: nil)
        }else {
            performRequest()
        }
    }
    
    // MARK: - Main methods
    
    fileprivate func performRequest()
    {
        guard let request = applicationManager.instagramFeedService.tokenRequest else { return }
        webView.loadRequest(request)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        applicationManager.instagramFeedService.saveToken(_from: request)
        // We need to show webView's request result ONLY when we don't have user token. 
        // Under no circumstances let user see redirection URI result!
        if !applicationManager.instagramFeedService.needsShowCredentialsForm {
            performSegue(withIdentifier: SegueIdentifier.toMainScene, sender: nil)
        }
        return applicationManager.instagramFeedService.needsShowCredentialsForm
    }

}
