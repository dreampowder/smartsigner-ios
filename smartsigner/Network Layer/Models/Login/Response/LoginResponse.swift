//
//    LoginResponse.swift
//
//    Create by Serdar Coşkun on 24/9/2018
//    Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct LoginResponse:JsonProtocol{
    
    func canMultiMobileSign() -> Bool{
        return phoneNumbers?.contains(where: { phone in
            phone.mobileOperator == .Turkcell
        }) ?? false
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.exceptionMessage, exceptionCode: self.errorCode)
    }
    
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return LoginResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    var codeKey : Int!
    var delegationPrompt : String!
    var delegations : [Delegation]!
    var departmentsWhichUserIsManagerOfIds : [Int]!
    var departmentsWhichUsersDelegationsIsManagerOfIds : [Int]!
    var errorCode : String!
    var exceptionMessage : String!
    var folders : [Folder]!
    var functionNameEnums : [Int]!
    var inheritedDepartmentRightIds : [Int]!
    var loggedUserCitizenShipNo : String!
    var loggedUserId : Int!
    var loggedUserName : String!
    var loggedUserPassword : String!
    var loggedUserSurname : String!
    var loggedUserUserName : String!
    var mobileNumber : String!
    var operatorId : Int!
    var passiveUserId : Int!
    var rightTransferIds : [Int]!
    var rightTransfers : [RightTransferId]!
    var serverDateTime : Int!
    var serverDateTimeString : String!
    var sessionId : Int!
    var userActiveDelegationId : Int!
    var userActiveDelegationUserId : Int!
    var userDepartmentRightId : Int!
    var userNeedToEnterVerificationCode : Bool!
    var usersDepartmentsManagementDepartmentId : Int!
    var nonce : String!
    
    //Serdar Coskun
    //Deacxtivate Delegate için eklendi
    var unencryptedPass:String!
    var deactivateDelegationUsername:String!
    
    //Yeni gelecek olan user setting json
    var userSettings:[UserSettingItem]!
    
    var canUseReadOnly:Bool!
    
    var ntUserName:String!
    
    var canUseArkSignerApp:Bool!
    var canUseIosSignCard:Bool!
    
    var accessToken:String?
    
    var phoneNumbers:[LoginResponsePhone]?
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        codeKey = dictionary["CodeKey"] as? Int
        delegationPrompt = dictionary["DelegationPrompt"] as? String
        delegations = [Delegation]()
        if let delegationsArray = dictionary["Delegations"] as? [[String:Any]]{
            for dic in delegationsArray{
                let value = Delegation(fromDictionary: dic)
                delegations.append(value)
            }
        }
        departmentsWhichUserIsManagerOfIds = dictionary["DepartmentsWhichUserIsManagerOfIds"] as? [Int]
        departmentsWhichUsersDelegationsIsManagerOfIds = dictionary["DepartmentsWhichUsersDelegationsIsManagerOfIds"] as? [Int]
        errorCode = dictionary["ErrorCode"] as? String
        exceptionMessage = dictionary["ExceptionMessage"] as? String
        folders = [Folder]()
        if let foldersArray = dictionary["Folders"] as? [[String:Any]]{
            for dic in foldersArray{
                let value = Folder(fromDictionary: dic)
                folders.append(value)
            }
        }
        functionNameEnums = dictionary["FunctionNameEnums"] as? [Int]
        inheritedDepartmentRightIds = dictionary["InheritedDepartmentRightIds"] as? [Int]
        loggedUserCitizenShipNo = dictionary["LoggedUserCitizenShipNo"] as? String
        loggedUserId = dictionary["LoggedUserId"] as? Int
        loggedUserName = dictionary["LoggedUserName"] as? String
        loggedUserPassword = dictionary["LoggedUserPassword"] as? String
        loggedUserSurname = dictionary["LoggedUserSurname"] as? String
        loggedUserUserName = dictionary["LoggedUserUserName"] as? String
        mobileNumber = dictionary["MobileNumber"] as? String
        operatorId = dictionary["operatorId"] as? Int
        passiveUserId = dictionary["PassiveUserId"] as? Int
        rightTransfers = [RightTransferId]()
        if let rightTransferIdsArray = dictionary["RightTransferIds"] as? [[String:Any]]{
            for dic in rightTransferIdsArray{
                let value = RightTransferId(fromDictionary: dic)
                rightTransfers.append(value)
            }
        }

        serverDateTime = dictionary["ServerDateTime"] as? Int
        serverDateTimeString = dictionary["ServerDateTimeString"] as? String
        sessionId = dictionary["SessionId"] as? Int
        userActiveDelegationId = dictionary["UserActiveDelegationId"] as? Int
        userActiveDelegationUserId = dictionary["UserActiveDelegationUserId"] as? Int
        userDepartmentRightId = dictionary["UserDepartmentRightId"] as? Int
        userNeedToEnterVerificationCode = dictionary["UserNeedToEnterVerificationCode"] as? Bool
        usersDepartmentsManagementDepartmentId = dictionary["UsersDepartmentsManagementDepartmentId"] as? Int
        
        nonce = dictionary["Nonce"] as? String

        if let userSettingDict = dictionary["UserSettings"] as? [[String:Any]]{
            self.userSettings = userSettingDict.map({UserSettingItem(fromDictionary:$0)})
        }else{
            self.userSettings = []
        }
        canUseReadOnly = dictionary["CanUseReadOnly"] as? Bool ?? false
        ntUserName = dictionary["NtUserName"] as? String
        
        canUseIosSignCard = dictionary["CanUseIosSignCard"] as? Bool
        canUseArkSignerApp = dictionary["CanUseArkSignerApp"] as? Bool
        accessToken = dictionary["AccessToken"] as? String
        
        if let phoneNumbersArray = dictionary["MobilePhoneNumbers"] as? [[String:Any]]{
            phoneNumbers = phoneNumbersArray.map({ map in
                    LoginResponsePhone(fromDictionary: map)
            })
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if codeKey != nil{
            dictionary["CodeKey"] = codeKey
        }
        if delegationPrompt != nil{
            dictionary["DelegationPrompt"] = delegationPrompt
        }
        if delegations != nil{
            var dictionaryElements = [[String:Any]]()
            for delegationsElement in delegations {
                dictionaryElements.append(delegationsElement.toDictionary())
            }
            dictionary["Delegations"] = dictionaryElements
        }
        if departmentsWhichUserIsManagerOfIds != nil{
            dictionary["DepartmentsWhichUserIsManagerOfIds"] = departmentsWhichUserIsManagerOfIds
        }
        if departmentsWhichUsersDelegationsIsManagerOfIds != nil{
            dictionary["DepartmentsWhichUsersDelegationsIsManagerOfIds"] = departmentsWhichUsersDelegationsIsManagerOfIds
        }
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
        if functionNameEnums != nil{
            dictionary["FunctionNameEnums"] = functionNameEnums
        }
        if inheritedDepartmentRightIds != nil{
            dictionary["InheritedDepartmentRightIds"] = inheritedDepartmentRightIds
        }
        if loggedUserCitizenShipNo != nil{
            dictionary["LoggedUserCitizenShipNo"] = loggedUserCitizenShipNo
        }
        if loggedUserId != nil{
            dictionary["LoggedUserId"] = loggedUserId
        }
        if loggedUserName != nil{
            dictionary["LoggedUserName"] = loggedUserName
        }
        if loggedUserPassword != nil{
            dictionary["LoggedUserPassword"] = loggedUserPassword
        }
        if loggedUserSurname != nil{
            dictionary["LoggedUserSurname"] = loggedUserSurname
        }
        if loggedUserUserName != nil{
            dictionary["LoggedUserUserName"] = loggedUserUserName
        }
        if mobileNumber != nil{
            dictionary["MobileNumber"] = mobileNumber
        }
        if operatorId != nil{
            dictionary["operatorId"] = operatorId
        }
        if passiveUserId != nil{
            dictionary["PassiveUserId"] = passiveUserId
        }
        if rightTransfers != nil{
            var dictionaryElements = [[String:Any]]()
            for rightTransferIdsElement in rightTransfers {
                dictionaryElements.append(rightTransferIdsElement.toDictionary())
            }
            dictionary["RightTransfers"] = dictionaryElements
        }
        if serverDateTime != nil{
            dictionary["ServerDateTime"] = serverDateTime
        }
        if serverDateTimeString != nil{
            dictionary["ServerDateTimeString"] = serverDateTimeString
        }
        if sessionId != nil{
            dictionary["SessionId"] = sessionId
        }
        if userActiveDelegationId != nil{
            dictionary["UserActiveDelegationId"] = userActiveDelegationId
        }
        if userActiveDelegationUserId != nil{
            dictionary["UserActiveDelegationUserId"] = userActiveDelegationUserId
        }
        if userDepartmentRightId != nil{
            dictionary["UserDepartmentRightId"] = userDepartmentRightId
        }
        if userNeedToEnterVerificationCode != nil{
            dictionary["UserNeedToEnterVerificationCode"] = userNeedToEnterVerificationCode
        }
        if usersDepartmentsManagementDepartmentId != nil{
            dictionary["UsersDepartmentsManagementDepartmentId"] = usersDepartmentsManagementDepartmentId
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
        
        if canUseReadOnly != nil{
            dictionary["CanUseReadOnly"] = canUseReadOnly
        }
        
        if ntUserName != nil{
            dictionary["NtUserName"] = ntUserName
        }
        
        if accessToken != nil {
            dictionary["AccessToken"] = accessToken ?? ""
        }
        /*
        if phoneNumbers != nil {
            dictionary["MobilePhoneNumbers"] = phoneNumbers?.map({ phone in
                return {"PhoneNumber":phone.phoneNumber, "MobileOperatorEnum":phone.mobileOperator.rawValue}
            })
        }
         */
        return dictionary
    }
    
}

struct LoginResponsePhone{
    let phoneNumber:String
    let mobileOperator:MobileOperatorEnum

    init(fromDictionary dictionary: [String:Any]){
        phoneNumber = (dictionary["PhoneNumber"] as? String) ?? ""
        mobileOperator = MobileOperatorEnum(rawValue: (dictionary["Operator"] as? Int) ?? -1) ?? .unknown
    }
}

enum MobileOperatorEnum:Int
{
    case Turkcell = 0
    case TurkTelekom = 1
    case Vodafone = 2
    case unknown = -1
}
