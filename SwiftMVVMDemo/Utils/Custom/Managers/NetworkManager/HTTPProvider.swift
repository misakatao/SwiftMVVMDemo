//
//  HTTPProvider.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/28.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit
import Alamofire

class HTTPProvider<Target: Request> where Target.EntityType: DBModel {

    private let manager = NetworkManager.sharedInstance
    
    /// 网络请求
    ///
    /// - Parameters:
    ///   - targetType: API模型
    ///   - responseHandler: 请求回调
    func request(_ targetType: Target, responseHandler: @escaping ResponseBlock<Target.EntityType>) {
        
        manager.request(targetType, responseHandler: responseHandler)
    }
    
    @discardableResult
    func download(_ targetType: Target, responseHandler: ResponseBlock<Target.EntityType>) -> Alamofire.DownloadRequest {
        
        return NetworkManager.sharedInstance.download(targetType, responseHandler: responseHandler)
    }
    
    func upload(_ targetType: Target, responseHandler: @escaping ResponseBlock<Target.EntityType>) {
        
        NetworkManager.sharedInstance.upload(targetType, responseHandler: responseHandler)
    }
}
