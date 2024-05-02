//
//    Delegation.swift
//
//    Create by Serdar Coşkun on 24/9/2018
//    Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Delegation{
    
    var delegationType : Int!
    var id : Int!
    var passiveUserId : Int!
    var startDate : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        delegationType = dictionary["DelegationType"] as? Int
        id = dictionary["Id"] as? Int
        passiveUserId = dictionary["PassiveUserId"] as? Int
        startDate = dictionary["StartDate"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if delegationType != nil{
            dictionary["DelegationType"] = delegationType
        }
        if id != nil{
            dictionary["Id"] = id
        }
        if passiveUserId != nil{
            dictionary["PassiveUserId"] = passiveUserId
        }
        if startDate != nil{
            dictionary["StartDate"] = startDate
        }
        return dictionary
    }
    
}
