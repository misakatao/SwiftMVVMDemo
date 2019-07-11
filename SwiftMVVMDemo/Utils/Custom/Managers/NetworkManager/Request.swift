//
//  Request.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/28.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit
import Alamofire

public protocol Request {
    var baseURL: String { get }
    var path: String { get }
    var method: Method { get }
    var parameters: [String: Any]? { get }
    var files: [File]? { get }
    
    associatedtype EntityType
}

public extension Request {
    
    var baseURL: String {
        return NetworkConfig.kBaseURL
    }
    
    var method: Method {
        return .get
    }
    
    var parameters: [String: Any]? {
        return [:]
    }
    
    var files: [File]? {
        return []
    }
}
