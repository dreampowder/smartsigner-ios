//
//    BaseRequest.swift
//
//    Create by Serdar Coşkun on 23/9/2018
//    Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct BaseRequest{
    
    var clientIPAddress : String!
    var clientTypeName : String!
    var delegationIds : [Int]!
    var departmentsWhichUserIsManagerOfIds : [Int]!
    var departmentsWhichUsersDelegationsIsManagerOfIds : [Int]!
    var inheritedDepartmentRightIds : [Int]!
    var rightTransferIds : [Int]!
    var sessionId : Int!
    var userId : Int!
    var userName : String!
    var userSurname : String!
    var nonce:String!
    var delegations:[Delegation]!
    var rightTransfers:[RightTransferId]!
    var languageEnum:Int!
    var ntUserName:String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        clientIPAddress = dictionary["ClientIPAddress"] as? String
        clientTypeName = dictionary["ClientTypeName"] as? String
        delegationIds = dictionary["DelegationIds"] as? [Int]
        departmentsWhichUserIsManagerOfIds = dictionary["DepartmentsWhichUserIsManagerOfIds"] as? [Int]
        departmentsWhichUsersDelegationsIsManagerOfIds = dictionary["DepartmentsWhichUsersDelegationsIsManagerOfIds"] as? [Int]
        inheritedDepartmentRightIds = dictionary["InheritedDepartmentRightIds"] as? [Int]
        rightTransferIds = dictionary["RightTransferIds"] as? [Int]
        sessionId = dictionary["SessionId"] as? Int
        userId = dictionary["UserId"] as? Int
        userName = dictionary["UserName"] as? String
        userSurname = dictionary["UserSurname"] as? String
        nonce = dictionary["Nonce"] as? String
        
        delegations = [Delegation]()
        if let delegationsArray = dictionary["Delegations"] as? [[String:Any]]{
            for dic in delegationsArray{
                let value = Delegation(fromDictionary: dic)
                delegations.append(value)
            }
        }
        
        rightTransfers = [RightTransferId]()
        if let rightTransferIdsArray = dictionary["RightTransferIds"] as? [[String:Any]]{
            for dic in rightTransferIdsArray{
                let value = RightTransferId(fromDictionary: dic)
                rightTransfers.append(value)
            }
        }
        
        languageEnum = dictionary["LanguageEnum"] as? Int
        ntUserName = dictionary["NtUserName"] as? String
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
        if delegationIds != nil{
            dictionary["DelegationIds"] = delegationIds
        }
        if departmentsWhichUserIsManagerOfIds != nil{
            dictionary["DepartmentsWhichUserIsManagerOfIds"] = departmentsWhichUserIsManagerOfIds
        }
        if departmentsWhichUsersDelegationsIsManagerOfIds != nil{
            dictionary["DepartmentsWhichUsersDelegationsIsManagerOfIds"] = departmentsWhichUsersDelegationsIsManagerOfIds
        }
        if inheritedDepartmentRightIds != nil{
            dictionary["InheritedDepartmentRightIds"] = inheritedDepartmentRightIds
        }
        if rightTransferIds != nil{
            dictionary["RightTransferIds"] = rightTransferIds
        }
        if sessionId != nil{
            dictionary["SessionId"] = sessionId
        }
        if userId != nil{
            dictionary["UserId"] = userId
        }
        if userName != nil{
            dictionary["UserName"] = userName
        }
        if userSurname != nil{
            dictionary["UserSurname"] = userSurname
        }
        if nonce != nil{
            dictionary["Nonce"] = nonce
        }
        
        if delegations != nil{
            var delegationArray:[[String:Any]] = []
            for delegation in delegations{
                delegationArray.append(delegation.toDictionary())
            }
            dictionary["Delegations"] = delegationArray
        }
        
        if rightTransfers != nil{
            var rightTransferarray:[[String:Any]] = []
            for rightTransfer in rightTransfers{
                rightTransferarray.append(rightTransfer.toDictionary())
            }
            dictionary["RightTransfers"] = rightTransferarray
        }
        
        if languageEnum != nil{
            dictionary["LanguageEnum"] = languageEnum
        }
        if ntUserName != nil {
            dictionary["NtUserName"] = ntUserName
        }
        
        return dictionary
    }
    
}
