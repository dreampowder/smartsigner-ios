//
//    ParaphResponse.swift
//
//    Create by Serdar Coşkun on 6/11/2018
//    Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct FolderListResponse:JsonProtocol{
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return FolderListResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: exceptionMessage, exceptionCode: errorCode)
    }
    
    
    
    
    var errorCode : String!
    var exceptionMessage : String!
    var folders : [Folder]!
    var isSuccess : Bool!
    var targetSendInfos : String!
    var successMessage : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        errorCode = dictionary["ErrorCode"] as? String
        exceptionMessage = dictionary["ExceptionMessage"] as? String
        folders = [Folder]()
        if let foldersArray = dictionary["Folders"] as? [[String:Any]]{
            for dic in foldersArray{
                let value = Folder(fromDictionary: dic)
                folders.append(value)
            }
        }
        isSuccess = dictionary["IsSuccess"] as? Bool
        targetSendInfos = dictionary["TargetSendInfos"] as? String
        successMessage = dictionary["SuccessMessage"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if errorCode != nil{
            dictionary["ErrorCode"] = errorCode
        }
        if exceptionMessage != nil{
            dictionary["ExceptionMessage"] = exceptionMessage
        }
        if folders != nil{
            var dictionaryElements = [[String:Any]]()
            for foldersElement in folders {
                dictionaryElements.append(foldersElement.toDictionary())
            }
            dictionary["Folders"] = dictionaryElements
        }
        if isSuccess != nil{
            dictionary["IsSuccess"] = isSuccess
        }
        if targetSendInfos != nil{
            dictionary["TargetSendInfos"] = targetSendInfos
        }
        if successMessage != nil{
            dictionary["SuccessMessage"] = successMessage
        }
        return dictionary
    }
    
}
