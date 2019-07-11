//
//  NetworkConfiguration.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/28.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit


// MARK: 网络请求配置(使用时根据需要增加、修改)
struct NetworkConfig {
    /// ***********网络请求基本配置*************
    static let kBaseURL = "http://mall.autohome.com.cn"
    static let kDomain = "com.mvvm-swift.framework"
    static let kCachePath = "MyApp.Cache"
    static let kContentType: Set<String> = [
        "application/json",
        "text/html",
        "text/javascript",
        "image/jpeg",
        "application/x-zip-compressed"
    ]
    
    /// ************返回数据正常时的键************
    static let kRetCode = "returncode"
    static let kRetMsg = "message"
    static let kRetData = "result"
    
    /// *************返回数据类型*************
    static let kErrorMsg = "返回数据格式异常"
    public static let kErrorCode = 300
    public static let kSuccessMsg = "请求成功"
}

