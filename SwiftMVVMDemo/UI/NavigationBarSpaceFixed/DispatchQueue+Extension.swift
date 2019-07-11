//
//  DispatchQueue+Extension.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/27.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import Foundation
import UIKit

extension DispatchQueue {
    
    static var `default`: DispatchQueue {
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.`default`)
    }
    
    static var userInteractive: DispatchQueue {
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
    }
    
    static var userInitiated: DispatchQueue {
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
    }
    
    static var utility: DispatchQueue {
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
    }
    
    static var background: DispatchQueue {
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
    }
    
    func after(_ delay: TimeInterval, execute closure: @escaping () -> Void) {
        
        asyncAfter(deadline: DispatchTime.now() + delay, execute: closure)
    }
    
    private static var _onceTracker = [String]()
    
    public class func once(_ token: String, block: () -> Void) {
        
        objc_sync_enter(self)
        
        defer {
            objc_sync_exit(self)
        }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        
        block()
    }
}
