//
//  NetworkManager.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/28.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class NetworkManager {

    static let sharedInstance = NetworkManager()
    
    private var sessionManager: SessionManager = {
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        config.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        config.timeoutIntervalForRequest = 30.0
        
        let manager = Alamofire.SessionManager(configuration: config)
        manager.delegate.sessionDidReceiveChallenge = { (session, challenge) in
            
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                
                disposition = .useCredential
                
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            } else {
             
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    
                    credential = manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            return (disposition, credential)
        }
        return manager
    }()
    
    /// 网络请求
    ///
    /// - Parameters:
    ///   - targetType: 请求数据模型
    ///   - responseHandler: 请求相应
    func request<T: Request>(_ targetType: T, responseHandler: @escaping ResponseBlock<T.EntityType>) where T.EntityType: DBModel {
        
        var url: URL!
        
        if targetType.path.contains("http") {
            url = URL(string: targetType.path)!
        } else {
            url = URL(string: targetType.baseURL.appending(targetType.path))!
        }
        
        sessionManager.request(url,
                               method: targetType.method,
                               parameters: targetType.parameters,
                               encoding: URLEncoding.default,
                               headers: nil)
            .validate(contentType: NetworkConfig.kContentType)
            .validate(statusCode: 200..<400)
            .responseJSON { [weak self] (response) in
                
                self?.handleResult(response, handler: responseHandler)
        }
    }
    
    /// 下载文件
    ///
    /// - Parameters:
    ///   - targetType: 下载对象模型
    ///   - destinationPath: 存储路径 默认在沙盒Document下
    ///   - response: 请求相应
    /// - Returns: 下载请求
    func download<T: Request>(_ targetType: T,
                              destinationPath: String = "",
                              responseHandler: ResponseBlock<T.EntityType>) -> Alamofire.DownloadRequest where T.EntityType: DBModel {
    
        var url: URL!
        
        if targetType.path.contains("http") {
            url = URL(string: targetType.path)!
        } else {
            url = URL(string: targetType.baseURL.appending(targetType.path))!
        }
        
        var destPath: URL
        
        if destinationPath.count == 0 {
            let directoryURLs = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
            
            destPath = directoryURLs[0].appendingPathComponent("/Music/")
        } else {
            destPath = URL(string: destinationPath)!
        }
        
        let destination: Alamofire.DownloadRequest.DownloadFileDestination = { (temporaryURL: URL, response) in
            
            let tempURL = destPath.appendingPathComponent("\(url.lastPathComponent.urlDecoded())")
            return (tempURL, [DownloadRequest.DownloadOptions.createIntermediateDirectories])
        }
        
        return sessionManager.download(URLRequest(url: url), to: destination).response(completionHandler: { (response) in
            
        })
    }
    
    /// 上传文件
    ///
    /// - Parameters:
    ///   - targetType: 上传对象模型
    ///   - responseHandler: 上传结果
    func upload<T: Request>(_ targetType: T, responseHandler: @escaping ResponseBlock<T.EntityType>) where T.EntityType: DBModel {
        
        assert(targetType.files != nil, "上传文件不能为空")
        
        var url: URL!
        
        if targetType.path.contains("http") {
            url = URL(string: targetType.path)!
        } else {
            url = URL(string: targetType.baseURL.appending(targetType.path))!
        }
        
        sessionManager.upload(multipartFormData: { (multiData: MultipartFormData) in
            
            guard let files = targetType.files else {
                return
            }
            
            if let params = targetType.parameters {
                
                for (key, value) in params {
                    
                    let data = JSON(value)
                    let dataStr = data.string
                    multiData.append((dataStr?.data(using: .utf8))!,
                                     withName: key)
                }
                
                for file in files {
                    if file.uploadType == .data {
                        multiData.append(file.data,
                                         withName: "file",
                                         fileName: file.name,
                                         mimeType: file.mimeType)
                    } else {
                        multiData.append(URL(string: file.filePath)!,
                                         withName: file.name,
                                         fileName: file.name + file.mimeType,
                                         mimeType: file.mimeType)
                    }
                }
            }
            
        }, to: url) { [weak self] (encodingResult: SessionManager.MultipartFormDataEncodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    self?.handleResult(response, handler: responseHandler)
                })
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    /// 处理返回数据
    ///
    /// - Parameters:
    ///   - response: resonse实例
    ///   - responseHandler: 处理后回调
    func handleResult<T: DBModel>(_ response: DataResponse<Any>, handler responseHandler: @escaping ResponseBlock<T>) {
        
        switch response.result.isSuccess {
        case true:
            if let value = response.result.value {
                
                let responseObj = JSON(value)
                
                if let responseDic = responseObj.dictionary {
                    let code = netWorkRetCode(responseDic)
                    let msg = networkRetMsg(responseDic)
                    let data = networkRetData(responseDic)
                    
                    if let resultDatas = data.arrayObject {
                        var models = [T]()
                        
                        for modelDic in resultDatas {
                            models.append(T(value: modelDic))
                        }
                        
                        let result = Result<T>(value: nil,
                                               code: code,
                                               values: models,
                                               message: Message.responseMsg(msg).retMsg())
                        responseHandler(Response<T>.success(result))
                        
                    } else if let resultData = data.dictionaryObject {
                        let model = T(value: resultData)
                        
                        let result = Result<T>(value: model,
                                               code: code,
                                               values: nil,
                                               message: Message.responseMsg(msg).retMsg())
                        responseHandler(Response<T>.success(result))
                        
                    } else {
                        DebugLog("❌❌❌❌==数据结构异常==❌❌❌")
                        
                        let error = NetError(code: code, message: msg)
                        responseHandler(Response<T>.failure(error))
                    }
                    
                } else if let responseArr = responseObj.array {
                    
                    var resultObjs = [T]()
                    
                    for item in responseArr {
                        resultObjs.append(T(value: item))
                    }
                    
                    let result = Result<T>(value: nil,
                                           code: 0,
                                           values: resultObjs,
                                           message: Message.success.retMsg())
                    responseHandler(Response<T>.success(result))
                    
                } else {
                    let responseStr = String(data: response.data!, encoding: .utf8)
                    
                    let result = Result<T>(value: T(value: responseStr ?? ""),
                                           code: 0,
                                           values: [T(value: responseStr ?? "")],
                                           message: Message.success.retMsg())
                    responseHandler(Response<T>.success(result))
                }
            }
        case false:
            DebugLog("❌❌❌❌==请求错误==❌❌❌❌")
            handleError(error: response.error, completeHandler: responseHandler)
        }
    }
    
    func handleError<T>(error: Error?, completeHandler:  ResponseBlock<T>) {
        
        var errorMsg: String!
        var errorCode = -999
        
        if let error = error as? AFError {
            
            switch error {
            case .invalidURL(let url):
                errorMsg = "无效的请求"
                DebugLog("无效 URL: \(url) - \(error.localizedDescription)")
                
            case .parameterEncodingFailed(let reason):
                errorMsg = "参数编码失败"
                DebugLog("失败理由: \(reason)")
                
            case .multipartEncodingFailed(let reason):
                errorMsg = "参数编码失败"
                DebugLog("失败理由: \(reason)")
                
            case .responseValidationFailed(let reason):
                DebugLog("Response 校验失败: \(error.localizedDescription)")
                DebugLog("失败理由: \(reason)")
                
                switch reason {
                case .dataFileNil, .dataFileReadFailed:
                    errorMsg = "文件不存在"
                    DebugLog("无法读取下载文件")
                    
                case .missingContentType(let acceptableContentTypes):
                    errorMsg = "文件类型不明"
                    DebugLog("文件类型不明: \(acceptableContentTypes)")
                    
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    errorMsg = "文件无法读取"
                    DebugLog("文件类型: \(responseContentType) 无法读取: \(acceptableContentTypes)")
                    
                case .unacceptableStatusCode(let code):
                    errorMsg = "请求被拒绝"
                    errorCode = code
                    DebugLog("请求失败: \(code)")
                }
                
            case .responseSerializationFailed(let reason):
                errorMsg = "请求返回内容解析失败"
                DebugLog("失败理由: \(reason)")
            }
            DebugLog("错误: \(String(describing: error.underlyingError))")
            
        } else if let error = error as? URLError {
            
            errorMsg = "网络异常，请检查网络"
            errorCode = error.code.rawValue
            DebugLog("网络异常，请检查网络: \(error)")
            
        } else {
            let nsError = (error! as NSError)
            errorMsg = nsError.description
            errorCode = nsError.code
        }
        
        let error = NetError(code: errorCode, message: errorMsg)
        completeHandler(Response<T>.failure(error))
    }
}
