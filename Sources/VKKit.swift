//
//  VKKit.swift
//  SocialKit
//
//  Created by Vladas Zakrevskis on 6/16/17.
//  Copyright © 2017 VladasZ. All rights reserved.
//

import SwiftyVK

public class VKKit : SocialProvider {
    
    public static var currentUser: SocialUser?
    
    //MARK: - Properties
    
    override public class var token: String? {
        get { return UserDefaults.standard.value(forKey: "VKKitToken") as? String }
        set { UserDefaults.standard.set(newValue, forKey: "VKKitToken") }
    }
    
    private static let delegate = VKKit()
    
    override public class func initialize(_ id: Any? = nil) {
        guard let appKey = id as? String else { print("VKKit: no app id provided"); return }
        VK.setUp(appId: appKey, delegate: delegate)
    }
    
    public static func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) {
        let app = options[.sourceApplication] as? String
        VK.handle(url: url, sourceApplication: app)
    }
    
    public static func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) {
        
        VK.handle(url: url, sourceApplication: sourceApplication)
    }
    
    override public class func login(_ completion: SocialCompletion = nil) {
        
        _onLogin = completion
        
        VK.sessions?.default.logIn(onSuccess: { response in
            
            guard let token = response["access_token"] else {
                completion?("VKKit error: failed to parse login response")
                return
            }
            
            let url = URL(string: "https://api.vk.com/method/users.get?access_token=\(token)")!
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    completion?(error.localizedDescription)
                    return
                }
                
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else {
                    completion?("VKKit error: failed to parse login response")
                    return
                }
                
                guard let dict = (json?["response"] as? [Any])?.first as? [String : Any]
                    else {
                        completion?("VKKit error: failed to parse login response")
                        return
                }
                
                guard let user_id = dict["uid"] as? Int,
                      let first_name = dict["first_name"] as? String,
                      let last_name = dict["last_name"] as? String
                else {
                    completion?("VKKit error: failed to parse login response")
                    return
                }

                VKKit.currentUser = SocialUser(id: user_id,
                                               name: "\(first_name) \(last_name)",
                                               network: .vkontakte)
                
                completion?(nil)
                }.resume()
        }, onError: { completion?($0.localizedDescription) })
    }
    
    private static func getUser(_ completion: @escaping (_ error: String?, _ user: SocialUser) -> ()) {
        
        VK.API.Users.get(.empty).onSuccess { response in
            
            let json = try JSONSerialization.jsonObject(with: response)
            
            print(json)
            
            
            print(json)

            
        }
        .send()
        
        
    }
    
    override public class func logout() {
        
        token = nil
        currentUser = nil
        _onLogin = nil
        
        VK.sessions?.default.logOut()
    }
}

extension VKKit : SwiftyVKDelegate {
    
    public func vkNeedsScopes(for sessionId: String) -> Scopes {
        return [.friends, .email, .photos, .messages, .offline]
    }
    
    public func vkNeedToPresent(viewController: VKViewController) {
        // Called when SwiftyVK wants to present UI (e.g. webView or captcha)
        // Should display given view controller from current top view controller
        
        topmostController.present(viewController, animated: true, completion: nil)
    }
    
    public func vkTokenCreated(for sessionId: String, info: [String : String]) {
        VKKit.token = info["access_token"]
    }
    
    public func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        VKKit.token = info["access_token"]
    }
    
    public func vkTokenRemoved(for sessionId: String) {
        VKKit.token = nil
    }
    
//
//    /**Called when SwiftyVK need autorization permissions
//     - returns: permissions as VK.Scope type*/
//    public func vkWillAuthorize() -> Set<SwiftyVK.Scope> { return [.friends, .email, .photos, .messages] }
//    ///Called when SwiftyVK did authorize and receive token
//    public func vkDidAuthorizeWith(parameters: [String : String]){
//
//        if let token = parameters["access_token"] {
//
//            VKKit.token = token
//
//            VK.API.Users.get([VK.Arg.fields : "domain"]).send(onSuccess: { (data) in
//
//                guard let data = data.array?.first else { print("VKKit error - failed to parse user"); return }
//
//                guard let fName = data["first_name"].string,
//                      let lName = data["last_name"].string else { print("VKKit error - failed to parse user"); return }
//
//                if let user = SocialUser(id: data["domain"].string, name: fName + " " + lName) {
//                    VKKit.currentUser = user
//                    VKKit._onLogin?()
//                }
//                else {
//                    print("VKKit error - failed to parse user")
//                    VKKit._onLogin?()
//                }
//
//            }, onError: { (error) in
//
//                print(error)
//            })
//        }
//    }

}
