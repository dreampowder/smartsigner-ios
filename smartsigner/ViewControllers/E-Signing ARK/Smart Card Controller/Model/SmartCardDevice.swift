//
//    SmartCardDevice.swift
//
//    Create by Serdar Coşkun on 11/12/2018
//    Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class SmartCardDevice:NSObject{
    
    @objc public var deviceId : String!
    @objc public var qrCode : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    
    convenience init(deviceId:String, qrCode:String) {
        self.init(fromDictionary: ["deviceId" : deviceId,"qrCode":qrCode])
    }
    
    init(fromDictionary dictionary: [String:Any]){
        deviceId = dictionary["deviceId"] as? String
        qrCode = dictionary["qrCode"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func dictionaryRepresantation() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if deviceId != nil{
            dictionary["deviceId"] = deviceId
        }
        if qrCode != nil{
            dictionary["qrCode"] = qrCode
        }
        return dictionary
    }
    
}
