//
//  Extensions.swift
//  SocialKit
//
//  Created by Vladas Zakrevskis on 6/21/17.
//  Copyright © 2017 VladasZ. All rights reserved.
//

import UIKit

internal var topmostController: UIViewController {
    var topController = UIApplication.shared.keyWindow?.rootViewController;
    
    while topController?.presentedViewController != nil {
        topController = topController?.presentedViewController;
    }
    
    if let controller = topController { return controller }
    
    print("SocialKit: Error, failed to get topmost controller")
    
    return UIViewController()
}
