//
//  File.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/28.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit

public enum UploadType {
    case data
    case path
}

public class File {

    var data: Data = Data()
    
    var name: String = ""
    
    var uploadType: UploadType = .data
    
    var mimeType: String = ""
    
    var filePath: String = ""
    
    init(data: Data? = nil, name: String, mimeType: String, filePath: String? = nil) {
        
        if let d = data {
            self.data = d
        }
        
        if let path = filePath {
            self.filePath = path
        }
        
        assert(data != nil || data != nil, "至少传入一个数据源")
        
        self.name = name
        
        self.mimeType = mimeType
        
    }
}
