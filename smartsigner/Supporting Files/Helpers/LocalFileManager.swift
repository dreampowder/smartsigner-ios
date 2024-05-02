//
//  FileManager.swift
//  smartsigner
//
//  Created by Serdar Coskun on 25.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit

struct LocalFileManager {

    @discardableResult static func saveFile(userId:Int, fileName:String, data:Data) -> URL?{
        let filemanager = FileManager.default
        let cachePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(userId)")
        try! filemanager.createDirectory(at: cachePath, withIntermediateDirectories: true, attributes: nil)
        let fileUrl = cachePath.appendingPathComponent(fileName)
        let _ = try? filemanager.removeItem(at: fileUrl)
        do{
            try data.write(to: fileUrl)
            return fileUrl
        }catch (let error){
            print("error writing file: \(error)")
            return nil
        }
    }
    
    static func getFileUrlIfAvailable(userId:Int, fileName:String) -> URL?{
        let filemanager = FileManager.default
        let cachePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(userId)").appendingPathComponent(fileName)
        print("\(filemanager.fileExists(atPath: cachePath.path)) path: \(cachePath.path)")
        if filemanager.fileExists(atPath: cachePath.path){
            return cachePath
        }else{
            return nil
        }
    }
    
    static func getFileName(document:PoolItem) -> String{
        return "document_\(document.id ?? -1)_\(document.documentId ?? -1).pdf".replacingOccurrences(of: " ", with: "")
    }
    
    static func getAttachmentFilename(attachment:DocumentAttachment) -> String{
        return "attachment_\(attachment.id ?? 0)_\(attachment.name ?? "")\(attachment.fileExtension ?? "")".replacingOccurrences(of: " ", with: "")
    }
    
    static func setFileCacheKeys(filename:String, fileId:Int, fileLength:Int){
        if var cacheDict = UserDefaultsManager.file_cache_dictionary.getDefaultsValue() as? [String:Any]{
            cacheDict[filename] = ["fileId":fileId,"fileLength":fileLength]
            UserDefaultsManager.file_cache_dictionary.setDefaultValue(value: cacheDict)
        }else{
            UserDefaultsManager.file_cache_dictionary.setDefaultValue(value: [filename:["fileId":fileId,"fileLength":fileLength]])
        }
    }
    
    static func getFileCacheValues(filename:String) -> (fileId:Int, fileLength:Int)?{
        guard let cacheDict = UserDefaultsManager.file_cache_dictionary.getDefaultsValue() as? [String:Any],
        let cacheKey = cacheDict[filename] as? [String:Any],
        let fileId = cacheKey["fileId"] as? Int ,
        let fileLength = cacheKey["fileLength"] as? Int,
        let _ = getFileUrlIfAvailable(userId: SessionManager.current.loginData?.loggedUserId ?? 0, fileName: filename) else{
            return nil
        }
        return (fileId,fileLength)
    }
}
