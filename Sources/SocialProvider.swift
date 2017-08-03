//
//  SocialProvider.swift
//  SocialKit
//
//  Created by Vladas Zakrevskis on 6/16/17.
//  Copyright © 2017 VladasZ. All rights reserved.
//

import Foundation

public typealias SocialCompletion = (() -> ())?

open class SocialProvider {
    
    //MARK: - Properties
    
    public class var token: String?  { get { return nil } }
    public class var isLogined: Bool { get { return token != nil } }
    
    //MARK: - Callbacks
    
    public static var _onLogin: SocialCompletion    
    public static func onLogin   (_ action: SocialCompletion)      { _onLogin    = action }
    
    public class func initializeWithAppID(_ id: String)           { fatalError("Subclasses need to implement the `initializeWithAppID()` method.") }
    public class func login(_ completion: SocialCompletion = nil) { fatalError("Subclasses need to implement the `login()` method.")               }
    public class func logout()                                    { fatalError("Subclasses need to implement the `logout()` method.")              }
}
