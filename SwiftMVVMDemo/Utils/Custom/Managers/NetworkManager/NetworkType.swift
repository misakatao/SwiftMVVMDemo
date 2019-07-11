//
//  NetworkType.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/28.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public typealias DownloadDestination = Alamofire.DownloadRequest.DownloadFileDestination

public typealias Method = Alamofire.HTTPMethod

struct Result<T> {
    
    var value: T?
    var code: Int
    var values: [T]?
    var message: String
}

/// 请求信息
///
/// - responseMsg: 响应信息
/// - success: 成功提示
/// - failure: 失败提示
enum Message {
    case responseMsg(String)
    case success
    case failure
    
    func retMsg() -> String {
        
        switch self {
        case .responseMsg(let msg):
            return msg
        case .success:
            return NetworkConfig.kSuccessMsg
        case .failure:
            return NetworkConfig.kErrorMsg
        }
    }
}

/// 网络请求错误
struct NetError {
    var code: Int
    var message: String
}

/// 网络响应
///
/// - Success: 成功
/// - Failure: 失败
enum Response<T> {
    case success(Result<T>)
    case failure(NetError)
    
    var success: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    var failure: Bool {
        return !success
    }
    
    var value: T? {
        switch self {
        case .success(let result):
            return result.value
        case .failure:
            return nil
        }
    }
    
    var code: Int {
        switch self {
        case .success(let result):
            return result.code
        case .failure(let error):
            return error.code
        }
    }
    
    var values: [T]? {
        switch self {
        case .success(let result):
            return result.values
        case .failure:
            return nil
        }
    }
    
    var message: String {
        switch self {
        case .success(let result):
            return result.message
        case .failure(let error):
            return error.message
        }
    }
}

extension Response: CustomStringConvertible {
    var description: String {
        switch self {
        case .success:
            return "SUCCESS"
        case .failure:
            return "FAILURE"
        }
    }
}

extension Response: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .success(let value):
            return "SUCCESS: \(value)"
        case .failure(let error):
            return "FAILURE: \(error)"
        }
    }
}



typealias ConstructingBodyWithBlock = (_ formData: MultipartFormData?) -> ()

typealias ResponseBlock<T> = (_ response: Response<T>) -> ()

typealias DownloadRequest = Alamofire.DownloadRequest

typealias DownloadProgressBlock = (Progress) -> Void

typealias DownloadBlock<T> = (_ response: Response<T>, _ fileName: String) -> ()

typealias ProgressBlock = ((Progress) -> Void)?


public func netWorkRetCode(_ responseData: [String: JSON]) -> Int {
    return responseData[NetworkConfig.kRetCode]?.int ?? 0
}

public func networkRetMsg(_ responseData: [String: JSON]) -> String {
    return responseData[NetworkConfig.kRetMsg]?.string ?? ""
}

public func networkRetData(_ responseData: [String: JSON]) -> SwiftyJSON.JSON {
    guard let retData = responseData[NetworkConfig.kRetData] else {
        return JSON([:])
    }
    return retData
}



