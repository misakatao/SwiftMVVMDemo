//
//  NSObject+Extension.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/27.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit

extension NSObject {
    
    convenience init(_ dictionary: [String: Any?]) {
        self.init()
        
        for (key, value) in dictionary {
            
            let success = setValueOfProperty(property: key, value: value)
            if success {
                DebugLog("✅assignment for \(key) sucess.")
            } else {
                DebugLog("❎assignment for \(key) failed.")
            }
        }
    }
    
    /// 获取对象对于的属性值，无对于的属性则返回nil
    ///
    /// - Parameter property: 要获取值的属性
    /// - Returns: 属性的值
    func getValueOfProperty(property: String) -> Any? {
        
        let allProperties = getAllProperties()
        
        if (allProperties.contains(property)) {
            return value(forKey: property)
        } else {
            return nil
        }
    }
    
    /// 设置对象属性的值
    ///
    /// - Parameters:
    ///   - property: 属性
    ///   - value: 值
    /// - Returns: 是否设置成功
    func setValueOfProperty(property: String, value: Any?) -> Bool {
        
        let allProperties = getAllProperties()
        
        if allProperties.contains(property) {
            setValue(value, forKey: property)
            return true
        } else {
            return false
        }
    }
    
    /// 获取对象的所有属性名称
    ///
    /// - Returns: 属性名称数组
    func getAllProperties() -> [String] {
        
        var result = [String]()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        let buff = class_copyPropertyList(object_getClass(self), count)
        let countInt = Int(count[0])
        
        for i in 0..<countInt {
            let temp = buff?[i]
            let tempProperty = property_getName(temp!)
            let property = String(validatingUTF8: tempProperty)
            
            result.append(property!)
        }
        return result
    }
}
