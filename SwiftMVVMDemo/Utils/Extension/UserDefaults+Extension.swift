//
//  UserDefaults+Extension.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/27.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit

extension UserDefaults {
    
    class func setDefaults(key: String, value: Any?) {
        
        if value == nil {
            UserDefaults.standard.removeObject(forKey: key)
        } else {
            UserDefaults.standard.set(value, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    class func removeUserDefaults(key: String?) {
        
        if key != nil {
            UserDefaults.standard.removeObject(forKey: key!)
            UserDefaults.standard.synchronize()
        }
    }
    
    class func getDefaults(key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
}
