//
//  DataBaseManager.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/28.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit
import RealmSwift

private let dbVersion: UInt64 = 2

class DataBaseManager {
    
    public class var `default`: DataBaseManager {
        return DataBaseManager()
    }
    
    private static let fileURL: URL = {
        
        let docPath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        var path = docPath + "/DataBase/"
        path += "MVVM.realm"
        return URL(string: path)!
    }()

    private static let config = Realm.Configuration(fileURL: DataBaseManager.fileURL,
                                                    schemaVersion: dbVersion,
                                                    migrationBlock: { (migration, oldSchemaVersion) in
                                                        
                                                        if oldSchemaVersion < dbVersion {
                                                            
                                                        }
    })
    
    lazy var realm = { () -> Realm in
        
        DebugLog(DataBaseManager.config.fileURL?.absoluteString ?? "")
        
        Realm.Configuration.defaultConfiguration = DataBaseManager.config
        return try! Realm()
    }()
    
    /// 查询
    ///
    /// - Parameter type: 所查询的数据类型
    /// - Returns: 查询结果
    func queryObjects<T: DBModel>(type: T.Type) -> Results<T> {
        return realm.objects(type)
    }
    
    
    /// 插入或更新数据
    ///
    /// - Parameter objects: 需要插入的数据
    func insertOrUpdate<T: DBModel>(objects: [T]) {
        try! realm.write {
            realm.add(objects, update: true)
        }
    }
    
    
    /// 删除数据
    ///
    /// - Parameter objects: 需要删除的数据
    func deleteObjects<T: DBModel>(objects: [T]) {
        try! realm.write({
            realm.delete(objects)
        })
    }
    
    
    func deleteAllObjects<T: DBModel>(type: T.Type) {
        let objs = queryObjects(type: T.self)
        try! realm.write({
            realm.delete(objs)
        })
    }
}

extension DataBaseManager: FileToolProtocol {
    var root: String {
        return "/DataBase"
    }
}
