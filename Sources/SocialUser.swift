//
//  SocialUser.swift
//  SocialKit
//
//  Created by Vladas Zakrevskis on 8/2/17.
//  Copyright © 2017 VladasZ. All rights reserved.
//

import Foundation

public class SocialUser : CustomStringConvertible {
    
    public var id:   String
    public var name: String
    public var network: SocialNetwork

    public init?(id: Any?, name: Any?, network: SocialNetwork) {
        
        guard let name = name as? String else { return nil }
        
        self.network = network
        self.name = name
        
        if let id = id as? Int { self.id = String(id) }
        else if let id = id as? String { self.id = id }
        else { return nil }
    }
    
    public var description: String {
        return "\(network.rawValue.capitalized) user. \(name)"
    }
}
