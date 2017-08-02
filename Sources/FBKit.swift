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
    
    public static func applicationDidBecomeActive() {
        
        FBSDKAppEvents.activateApp()
    }
    
    public static func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) {
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    public static func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) {
        
        FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
    
    public static func getUser(_ completion: (() -> ())?) {
        
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name"])) { httpResponse, result in
            switch result {
            case .success(let response):
                
                if let user = SocialUser(id:response.dictionaryValue?["id"], name: response.dictionaryValue?["name"]) {
                    
                    currentUser = user

                    if completion == nil {
                        _onGetUser?(user)
                    }
                    else {
                        completion?()
                    }
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
        
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email", "user_birthday"], from: topmostController) { result, error in
            
            if let token = result?.token.tokenString {
                
                _onGetToken?(token)
                
                self.token = token
            }
            
            getUser(nil)
            
            if let error = error?.localizedDescription { print("FBKit: Error - " + error) }
        }
    }
    
    override public class func logout() {
        
        token = nil
        currentUser = nil
        FBSDKLoginManager().logOut()
        FBSDKAccessToken.setCurrent(nil)
    }
}
