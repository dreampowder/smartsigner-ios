//
//	ListDelegateRequest.swift
//
//	Create by Serdar Coşkun on 30/10/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ListDelegateRequest{

	var clientIPAddress : String!
	var clientTypeName : String!
	var sessionId : Int!
	var userId : Int!
	var userName : String!
	var userSurname : String!
	var activeUserId : Int!
	var btnListIsEnabled : Bool!
	var everyoneCanListAllDelegations : Bool!
	var getOnlyActives : Bool?
	var getOnlyEffectives : Bool!
	var passiveUserId : Int!
	var selectedDelegationDate : String!
	var userHasAllUsersToList : Bool!
	var userHasAllUsersToUpdate : Bool!
	var userHasSomeDepartmentsToList : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		clientIPAddress = dictionary["ClientIPAddress"] as? String
		clientTypeName = dictionary["ClientTypeName"] as? String
		sessionId = dictionary["SessionId"] as? Int
		userId = dictionary["UserId"] as? Int
		userName = dictionary["UserName"] as? String
		userSurname = dictionary["UserSurname"] as? String
		activeUserId = dictionary["activeUserId"] as? Int
		btnListIsEnabled = dictionary["btnListIsEnabled"] as? Bool
		everyoneCanListAllDelegations = dictionary["everyoneCanListAllDelegations"] as? Bool
		getOnlyActives = dictionary["getOnlyActives"] as? Bool
		getOnlyEffectives = dictionary["getOnlyEffectives"] as? Bool
		passiveUserId = dictionary["passiveUserId"] as? Int
		selectedDelegationDate = dictionary["selectedDelegationDate"] as? String
		userHasAllUsersToList = dictionary["userHasAllUsersToList"] as? Bool
		userHasAllUsersToUpdate = dictionary["userHasAllUsersToUpdate"] as? Bool
		userHasSomeDepartmentsToList = dictionary["userHasSomeDepartmentsToList"] as? Bool
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
		if activeUserId != nil{
			dictionary["activeUserId"] = activeUserId
		}
		if btnListIsEnabled != nil{
			dictionary["btnListIsEnabled"] = btnListIsEnabled
		}
		if everyoneCanListAllDelegations != nil{
			dictionary["everyoneCanListAllDelegations"] = everyoneCanListAllDelegations
		}
		if getOnlyActives != nil{
			dictionary["getOnlyActives"] = getOnlyActives
		}
		if getOnlyEffectives != nil{
			dictionary["getOnlyEffectives"] = getOnlyEffectives
		}
		if passiveUserId != nil{
			dictionary["passiveUserId"] = passiveUserId
		}
		if selectedDelegationDate != nil{
			dictionary["selectedDelegationDate"] = selectedDelegationDate
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
