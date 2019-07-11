//
//  NotificationCenter+Extension.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/27.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit

extension NotificationCenter {
    
    class func post(name: NotificationName, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        
        NotificationCenter.default.post(name: NSNotification.Name.customName(name: name), object: object, userInfo: userInfo)
    }
    
    class func post(name: Notification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
    
    class func addObserver(observer: Any, selector: Selector, name: NotificationName, object: Any? = nil) {
        
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name.customName(name: name), object: object)
    }
    
    class func addObserver(observer: Any, selector: Selector, name: Notification.Name, object: Any? = nil) {
        
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
    }
}

extension NSNotification.Name {
    
    static func customName(name: NotificationName) -> NSNotification.Name {
        return NSNotification.Name(name.rawValue)
    }
}

enum NotificationName: String {
    case loginSuccess
    case logout
}
