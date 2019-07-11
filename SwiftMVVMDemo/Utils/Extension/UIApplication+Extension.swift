//
//  UIApplication+Extension.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/27.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit

extension UIApplication {
    
    private static let classSwizzleMethod: Void = {
       
        UIImagePickerController.cm_swizzleMethod
        UINavigationBar.cm_swizzleMethod
        UIViewController.cmp_swizzleMethod
    }()
    
    open override var next: UIResponder? {
        
        UIApplication.classSwizzleMethod
        return super.next
    }
}
