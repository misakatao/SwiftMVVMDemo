//
//  PlaceHolderNavBar.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/27.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit

class PlaceHolderNavBar: UINavigationBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for sub in subviews {
            
            let className = type(of: sub).description().components(separatedBy: ".").last ?? ""
            
            if className == "_UINavigationBarContentView" {
                
                sub.frame = CGRect(x: 0, y: 0, width: sub.width, height: isiPhoneX ? 88 : 64)
            } else if className == "_UIBarBackground" {
                
                sub.frame = CGRect(x: 0, y: 0, width: sub.width, height: isiPhoneX ? 88 : 64)
            }
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
