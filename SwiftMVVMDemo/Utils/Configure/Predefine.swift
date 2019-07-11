//
//  Predefine.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/27.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit

public let kLastWindow: UIWindow? = UIApplication.shared.windows.last
public let kKeyWindow: UIWindow? = UIApplication.shared.keyWindow

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

let isiPhoneX = ((kScreenHeight - 812) == 0 ? true : false)

public func DebugLog(_ item: Any) {
    
    #if DEBUG && FOO
        
        print(item)
        
    #endif
}
