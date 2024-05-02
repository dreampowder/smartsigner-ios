//
//    LoginRequest.swift
//
//    Create by Serdar Coşkun on 20/9/2018
//    Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct LoginRequest{
    
    var clientIPAddress : String!
    var clientTypeName : String!
    var loginWithMobileSign : Bool!
    var password : String!
    var userLoginName : String!
    var verifyWithSms : Bool!
    var signedData: String!
    var transactionUUID: String!
    var setId: String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        clientIPAddress = dictionary["ClientIPAddress"] as? String
        clientTypeName = dictionary["ClientTypeName"] as? String
        loginWithMobileSign = dictionary["LoginWithMobileSign"] as? Bool
        password = dictionary["Password"] as? String
        userLoginName = dictionary["UserLoginName"] as? String
        verifyWithSms = dictionary["VerifyWithSms"] as? Bool
        signedData = dictionary["SignedData"] as? String
        transactionUUID = dictionary["TransactionUuid"] as? String
        setId = dictionary["SetId"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if clientIPAddress != nil{
            dictionary["ClientIPAddress"] = clientIPAddress
        }
        if clientTypeName != nil{
            dictionary["ClientTypeName"] = clientTypeName
        }
        if loginWithMobileSign != nil{
            dictionary["LoginWithMobileSign"] = loginWithMobileSign
        }
        if password != nil{
            dictionary["Password"] = password
        }
        if userLoginName != nil{
            dictionary["UserLoginName"] = userLoginName
        }
        if verifyWithSms != nil{
            dictionary["VerifyWithSms"] = verifyWithSms
        }
        if signedData != nil {
            dictionary["SignedData"] = signedData
        }
        if transactionUUID != nil{
            dictionary["TransactionUuid"] = transactionUUID
        }
        if setId != nil{
            dictionary["SetId"] = setId
        }
        return dictionary
    }
    
}
