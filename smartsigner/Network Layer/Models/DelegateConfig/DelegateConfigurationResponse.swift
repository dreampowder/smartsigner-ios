//
//	DelegateConfiruationResponse.swift
//
//	Create by Serdar Coşkun on 30/10/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DelegateConfigurationResponse:JsonProtocol{
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.exceptionMessage, exceptionCode: self.errorCode)
    }
    
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return DelegateConfigurationResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
	var errorCode : String!
	var exceptionMessage : String!
	var btnListIsEnabled : Bool!
	var delegationConfiguration : DelegationConfiguration!
	var everyoneCanListAllDelegations : Bool!
	var isUserCanGiveDelegationForAnyone : Bool!
	var userHasAllUsersToList : Bool!
	var userHasAllUsersToUpdate : Bool!
	var userHasSomeDepartmentsToList : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		errorCode = dictionary["ErrorCode"] as? String
		exceptionMessage = dictionary["ExceptionMessage"] as? String
		btnListIsEnabled = dictionary["btnListIsEnabled"] as? Bool
		if let delegationConfigurationData = dictionary["delegationTypeEnumsForCheckBox"] as? [String:Any]{
				delegationConfiguration = DelegationConfiguration(fromDictionary: delegationConfigurationData)
			}
		everyoneCanListAllDelegations = dictionary["everyoneCanListAllDelegations"] as? Bool
		isUserCanGiveDelegationForAnyone = dictionary["isUserCanGiveDelegationForAnyone"] as? Bool
		userHasAllUsersToList = dictionary["userHasAllUsersToList"] as? Bool
		userHasAllUsersToUpdate = dictionary["userHasAllUsersToUpdate"] as? Bool //DELEGATE EKRANINDA KENDİSİ GELMELİ
		userHasSomeDepartmentsToList = dictionary["userHasSomeDepartmentsToList"] as? Bool
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
		if btnListIsEnabled != nil{
			dictionary["btnListIsEnabled"] = btnListIsEnabled
		}
		if delegationConfiguration != nil{
			dictionary["delegationTypeEnumsForCheckBox"] = delegationConfiguration.toDictionary()
		}
		if everyoneCanListAllDelegations != nil{
			dictionary["everyoneCanListAllDelegations"] = everyoneCanListAllDelegations
		}
		if isUserCanGiveDelegationForAnyone != nil{
			dictionary["isUserCanGiveDelegationForAnyone"] = isUserCanGiveDelegationForAnyone
		}
		if userHasAllUsersToList != nil{
			dictionary["userHasAllUsersToList"] = userHasAllUsersToList
		}
		if userHasAllUsersToUpdate != nil{
			dictionary["userHasAllUsersToUpdate"] = userHasAllUsersToUpdate
		}
		if userHasSomeDepartmentsToList != nil{
			dictionary["userHasSomeDepartmentsToList"] = userHasSomeDepartmentsToList
		}
		return dictionary
	}

}
