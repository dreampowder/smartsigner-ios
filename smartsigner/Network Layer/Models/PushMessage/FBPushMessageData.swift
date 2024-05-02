//
//    FBPushMessageData.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct FBPushMessageData{

    var cN : String!
    var documentId : Int!
    var folderId : Int!
    var poolId : Int!
    var type : String!
    var userId: Int!
    var targetId: Int!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        cN = dictionary["CN"] as? String
        documentId = convertResponseToInt(value: dictionary["DocumentId"])
        folderId = convertResponseToInt(value: dictionary["FolderId"])
        poolId = convertResponseToInt(value: dictionary["PoolId"])
        type = dictionary["Type"] as? String
        userId = convertResponseToInt(value:dictionary["UserId"])
        targetId = convertResponseToInt(value:dictionary["Id"])
    }
    
    func convertResponseToInt(value:Any?) -> Int?{
        if let stringVal = value as? String{
            return Int(stringVal)
        }else if let intVal = value as? Int{
            return intVal
        }else{
            print("Failed to convert :\(value)")
            return nil
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if cN != nil{
            dictionary["CN"] = cN
        }
        if documentId != nil{
            dictionary["DocumentId"] = documentId
        }
        if folderId != nil{
            dictionary["FolderId"] = folderId
        }
        if poolId != nil{
            dictionary["PoolId"] = poolId
        }
        if type != nil{
            dictionary["Type"] = type
        }
        if userId != nil {
            dictionary["UserId"] = userId
        }
        if targetId != nil{
            dictionary["Id"] = targetId
        }
        return dictionary
    }
}


