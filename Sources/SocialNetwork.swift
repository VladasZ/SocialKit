//
//  SocialNetwork.swift
//  SocialKit
//
//  Created by Vladas Zakrevskis on 8/3/17.
//  Copyright © 2017 VladasZ. All rights reserved.
//

import Foundation

public enum SocialNetwork : String {
    
    case facebook
    case vkontakte
    case instagram
    
    public var provider: SocialProvider.Type {
        
        switch self {
        case .facebook:  return FBKit.self
        case .vkontakte: return VKKit.self
        default: print("SocialKit error instagramm not implemented yet"); return VKKit.self
        }
    }
    
    public static func logoutAll() {
        
        all.forEach { $0.logout() }
    }
    
    public static var all: [SocialProvider.Type] {
        
        return [FBKit.self, VKKit.self]
    }
}
