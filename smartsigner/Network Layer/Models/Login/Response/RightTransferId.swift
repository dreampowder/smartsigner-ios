//
//    RightTransferId.swift
//
//    Create by Serdar Coşkun on 24/9/2018
//    Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct RightTransferId{
    
    var documentFlowTypeEnums : String!
    var id : Int!
    var templateIds : String!
    var transferrerUserId : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        documentFlowTypeEnums = dictionary["DocumentFlowTypeEnums"] as? String
        id = dictionary["Id"] as? Int
        templateIds = dictionary["TemplateIds"] as? String
        transferrerUserId = dictionary["TransferrerUserId"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if documentFlowTypeEnums != nil{
            dictionary["DocumentFlowTypeEnums"] = documentFlowTypeEnums
        }
        if id != nil{
            dictionary["Id"] = id
        }
        if templateIds != nil{
            dictionary["TemplateIds"] = templateIds
        }
        if transferrerUserId != nil{
            dictionary["TransferrerUserId"] = transferrerUserId
        }
        return dictionary
    }
    
}
