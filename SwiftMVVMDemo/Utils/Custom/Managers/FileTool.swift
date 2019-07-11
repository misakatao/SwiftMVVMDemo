//
//  FileTool.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/28.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit

protocol FileToolProtocol {
    var root: String { get }
}

class FileTool: NSObject {

    private var delegate: FileToolProtocol? = nil
    
    private var root: String {
        
        if let delegate = delegate {
            return delegate.root
        } else {
            return "/files"
        }
    }
    
    private let fileManager: FileManager = {
        return FileManager.default
    }()
    
    private var basePath: String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    }
    
    override init() {
        super.init()
    }
    
    convenience init(delegate: FileToolProtocol) {
        self.init()
        
        self.delegate = delegate
    }
    
    func data(filePath: String) -> Any? {
        do {
            let attributes = try fileManager.attributesOfFileSystem(forPath: filePath)
            return attributes
        } catch {
            print(error)
            return nil
        }
    }
    
    func creatFileIfNotExit(name filename: String) {
        
        var dirPath = basePath
        dirPath = dirPath + root + (filename.hasPrefix("/") ? "" : "/") + filename
        
        creatFileDirectoryIfNotExit("")
        
        var isDir: ObjCBool = false
        
        let fileExist = fileManager.fileExists(atPath: dirPath, isDirectory: &isDir)
        
        if !fileExist {
            let success = fileManager.createFile(atPath: dirPath, contents: Data(), attributes: nil)
            if success {
                DebugLog("creat file success")
            }
        } else {
            DebugLog("file has existed")
        }
    }
    
    func creatFileDirectoryIfNotExit(_ path: String) {
        
        var dirPath: String
        
        if path.contains(basePath) {
            dirPath = path
        } else {
            dirPath = basePath
            
            if path.isEmpty {
                dirPath = dirPath + root
            } else {
                dirPath = dirPath + root + (path.hasPrefix("/") ? "" : "/") + path
            }
        }
        
        var isDir: ObjCBool = true
        
        fileManager.fileExists(atPath: dirPath, isDirectory: &isDir)
        
        assert(isDir.boolValue, "Error: the path is not a directory")
        
        try! fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
    }
    
    func write(data: Data, toFile fileName: String, cover: Bool) {
        
        var dirPath = basePath
        dirPath = dirPath + root + (fileName.hasPrefix("/") ? "" : "/") + fileName
        
        creatFileIfNotExit(name: fileName)
        
        let fileHandle = FileHandle(forUpdatingAtPath: dirPath)
        
        if let fh = fileHandle {
            if cover {
                fh.truncateFile(atOffset: 0)
            }
            fh.seekToEndOfFile()
            fh.write(data)
            fh.closeFile()
        } else {
            DebugLog("write to file failed")
        }
    }
    
    func read(fileName: String) -> Data? {
        
        var dirPath = basePath
        dirPath = dirPath + root + (fileName.hasPrefix("/") ? "" : "/") + fileName
        
        let fileExit = fileManager.fileExists(atPath: dirPath, isDirectory: nil)
        
        if !fileExit {
            DebugLog("file not exist")
            return nil
        }
        
        let fileHandle = FileHandle(forReadingAtPath: dirPath)
        
        if let fh = fileHandle {
            let data = fh.readDataToEndOfFile()
            fh.closeFile()
            return data
            
        } else {
            DebugLog("read file content failed")
            return nil
        }
    }
    
    func delete(file fileName: String) {
        
        var dirPath = basePath
        dirPath = dirPath + root + (fileName.hasPrefix("/") ? "" : "/") + fileName
        
        try? fileManager.removeItem(atPath: dirPath)
    }
    
    func deleteDirectory(_ path: String) {
        
        assert(!path.contains(basePath), "Error: you don`t need set the base directory")
        
        var dirPath = basePath
        
        if path.isEmpty {
            dirPath = dirPath + root
        } else {
            dirPath = dirPath + root + (path.hasPrefix("/") ? "" : "/") + path
        }
        
        try? fileManager.removeItem(atPath: dirPath)
    }
    
    func deleteItems(inDir dirName: String) {
        
        deleteDirectory(dirName)
        
        creatFileDirectoryIfNotExit(dirName)
    }
}
