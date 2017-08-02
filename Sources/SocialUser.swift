//
//  SocialUser.swift
//  SocialKit
//
//  Created by Vladas Zakrevskis on 8/2/17.
//  Copyright © 2017 VladasZ. All rights reserved.
//

import Foundation

public class SocialUser {
    
    public var id:   String
    public var name: String
    
    public init?(id: Any?, name: Any?) {
        
        guard let name = name as? String else { return nil }
        
        self.name = name
        
        if let id = id as? Int { self.id = String(id) }
        else if let id = id as? String { self.id = id }
        else { return nil }
    }
}
