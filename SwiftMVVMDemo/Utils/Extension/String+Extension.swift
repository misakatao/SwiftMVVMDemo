//
//  String+Extension.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/27.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit

extension String {
    
    func urlEncoded() -> String {
        let encodeURLString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return encodeURLString ?? ""
    }
    
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}

