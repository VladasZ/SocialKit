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
    
    override public class func initializeWithAppID(_ id: String) {
        
        VK.configure(withAppId: id, delegate: delegate)
    }
    
    override public class func login(_ completion: SocialCompletion = nil) {
        
        VK.logIn()
    }
    
    override public class func logout() {
        
        token = nil
        currentUser = nil
        VK.logOut()
    }

}

extension VKKit : VKDelegate {
    /**Called when SwiftyVK need autorization permissions
     - returns: permissions as VK.Scope type*/
    public func vkWillAuthorize() -> Set<VK.Scope> { return [.friends, .email, .photos] }
    ///Called when SwiftyVK did authorize and receive token
    public func vkDidAuthorizeWith(parameters: [String : String]){
        
        if let token = parameters["access_token"] {
            
            VKKit.token = token
            VKKit._onGetToken?(token)
            
            VK.API.Users.get([VK.Arg.fields : "domain"]).send(onSuccess: { (data) in
                
                guard let data = data.array?.first else { print("VKKit error - failed to parse user"); return }
                
                guard let fName = data["first_name"].string,
                      let lName = data["last_name"].string else { print("VKKit error - failed to parse user"); return }
                
                if let user = SocialUser(id: data["domain"].string, name: fName + " " + lName) {
                    VKKit.currentUser = user
                    VKKit._onGetUser?(user)
                }
                else {
                    print("VKKit error - failed to parse user")
                }
                
            }, onError: { (error) in
                
                print(error)
            })
        }
    }
    ///Called when SwiftyVK did unauthorize and remove token
    public func vkDidUnauthorize(){
        
        
    }
    ///Called when SwiftyVK did failed autorization
    public func vkAutorizationFailedWith(error: AuthError){
        print(error)
        
        
    }
    /** ---DEPRECATED. TOKEN NOW STORED IN KEYCHAIN--- Called when SwiftyVK need know where a token is located
     - returns: Path to save/read token or nil if should save token to UserDefaults*/
    public func vkShouldUseTokenPath() -> String? { return nil }
    /**Called when need to display a view from SwiftyVK
     - returns: UIViewController that should present autorization view controller*/
    public func vkWillPresentView() -> UIViewController { return topmostController }
    
}
