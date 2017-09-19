//
//  WebViewController.swift
//  SocialKit
//
//  Created by Vladas Zakrevskis on 9/19/17.
//  Copyright © 2017 VladasZ. All rights reserved.
//

import UIKit

protocol WebViewControllerDelegate : class {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
}

class WebViewController: UIViewController {
    
    var webView: UIWebView!
    var requestURL: URL!
    var delegate: WebViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if requestURL == nil || delegate == nil {
            print("WebViewController error no delegate or URl")
            return
        }

        UISetup()
        
        webView.loadRequest(URLRequest(url:requestURL))
    }
    
    func UISetup() {
        
        webView = UIWebView(frame: view.frame);
        webView.delegate = self
        view.addSubview(webView)
    }
}

extension WebViewController : UIWebViewDelegate {
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return delegate.webView(webView, shouldStartLoadWith:request, navigationType:navigationType)
    }
}
