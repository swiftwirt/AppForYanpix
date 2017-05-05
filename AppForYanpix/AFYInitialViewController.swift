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
        static let toMainScete = "SegueToMainScene"
        
        private init() {}
    }

    @IBOutlet var webView: UIWebView!
    
    fileprivate let applicationManager = AFYApplicationManager.instance()
    
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
//        if !applicationManager.instagramFeedService.needsShowCredentialsForm {
//            performSegue(withIdentifier: SegueIdentifier.toMainScete, sender: nil)
//        }
        return applicationManager.instagramFeedService.needsShowCredentialsForm
    }

}
