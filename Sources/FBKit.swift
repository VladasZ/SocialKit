//
//  FBKit.swift
//  SwiftTools
//
//  Created by Vladas Zakrevskis on 6/21/17.
//  Copyright © 2017 VladasZ. All rights reserved.
//

import FBSDKLoginKit
import FacebookCore

public class FBKit : SocialProvider {
    
    public static var currentUser: SocialUser?
    
    override public class var token: String? {
        get { return UserDefaults.standard.value(forKey: "FBKitToken") as? String }
        set { UserDefaults.standard.set(newValue, forKey: "FBKitToken") }
    }
    
    public override class func initialize(_ id: Any? = nil){
        
        FBSDKAppEvents.activateApp()
    }

    public static func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) {
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if isLogined { getUser { } }
    }
    
    public static func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) {
        
        FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
    
    public static func getUser(_ completion: @escaping () -> ()) {
        
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name"])) { httpResponse, result in
            switch result {
            case .success(let response):
                
                if let user = SocialUser(id:response.dictionaryValue?["id"], name: response.dictionaryValue?["name"], network: .facebook) {
                    
                    currentUser = user

                    completion()
                }
                else {
                    
                    print("FBKit: Error - failed to parse user")
                }
                
                print("Graph Request Succeeded: \(response)")
            case .failed(let error):
                print("FBKit: Error - Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
    
    public override class func login(_ completion: SocialCompletion = nil) {
        
        _onLogin = completion
        
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email", "user_birthday"], from: topmostController) { result, error in
            
            if let token = result?.token?.tokenString {
                
                self.token = token
                getUser { _onLogin?(nil) }
            }
            else {
                print("FBKit: Error - no token")
            }            
            
            if let error = error?.localizedDescription { print("FBKit: Error - " + error) }
        }
    }
    
    override public class func logout() {
        
        token = nil
        currentUser = nil
        _onLogin = nil
        FBSDKLoginManager().logOut()
        FBSDKAccessToken.setCurrent(nil)
    }
}
