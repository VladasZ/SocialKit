//
//  InstaKit.swift
//  SocialKit
//
//  Created by Vladas Zakrevskis on 9/13/17.
//  Copyright © 2017 VladasZ. All rights reserved.
//

import UIKit

public class InstaKit : SocialProvider {
    
    private static var _token: String?
    private static var appID: String!
    private static var redirectURL: String!
    private static let instance = InstaKit()
    private static var controller: WebViewController!
    
    public static var currentUser: SocialUser?
    
    public override class var token: String? { return _token }
    
    public override class func login(_ completion: SocialCompletion = nil) {
        
        _onLogin = completion
        
        guard let requestURL = URL(string:
            "https://api.instagram.com/oauth/authorize/?client_id=" + appID
                + "&redirect_uri=" + redirectURL
                + "&response_type=token&scope=basic+public_content")
            else { print("InstaKit error: failed to create request url"); return }
        
        controller = WebViewController()
        controller.requestURL = requestURL
        controller.delegate = instance
        topmostController.present(controller, animated: true, completion: nil)
    }
    
    public override class func logout() {
        
        _token = nil
    }
    
    public override class func initialize(_ id: Any? = nil){
        
        guard let (appID, redirectURL) = id as? (String, String)
            else { print("InstaKit error: no app id"); return }
        
        self.appID = appID;
        self.redirectURL = redirectURL
    }
    
    static func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        
        let requestURLString = (request.url?.absoluteString)! as String
        
        if requestURLString.hasPrefix(redirectURL) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            return false;
        }
        return true
    }
    
    static func handleAuth(authToken: String)  {
    
        print(authToken)
    
        let request = URLRequest(url: URL(string: "https://api.instagram.com/v1/users/self/?access_token=" + authToken)!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
        
            if let _ = error, data == nil { print("InstaKit error: failed to get user data"); return }
            
            guard let userData =
                (((try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers))
                    as? [String : Any])?["data"])
                    as? [String : Any]
                else { print("InstaKit error: failed to get user data"); return }
            
            guard let name = userData["username"] as? String,
                  let id = userData["id"] as? String
                else { print("InstaKit error: failed to get user data"); return }
            
            let user = SocialUser(id: id, name: name, network: .instagram)
            
            currentUser = user
            controller.dismiss(animated: true) { _onLogin?(nil) }

        }.resume()
    }
}

extension InstaKit : WebViewControllerDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return InstaKit.checkRequestForCallbackURL(request: request)
    }
}
