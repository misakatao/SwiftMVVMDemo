//
//  UIStoryboard+Extension.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/27.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    class func vcInMainSB(_ identifier: String, sbName: String = "Main") -> UIViewController {
        
        let storyboard = UIStoryboard(name: sbName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}
