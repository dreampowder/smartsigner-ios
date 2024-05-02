//
//	DelegationItem.swift
//
//	Create by Serdar Coşkun on 30/10/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DelegationItem{

	var activeUserId : Int!
	var activeUserNameSurname : String!
	var delegationId : Int!
	var delegationTypeEnumsForCheckBox : DelegationTypeEnumsForCheckBox!
	var descriptionField : String!
	var endDate : String!
	var isEffective : Bool!
	var passiveUserId : Int!
	var passiveUserNameSurname : String!
	var startDate : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		activeUserId = dictionary["activeUserId"] as? Int
		activeUserNameSurname = dictionary["activeUserNameSurname"] as? String
		delegationId = dictionary["delegationId"] as? Int
		if let delegationTypeEnumsForCheckBoxData = dictionary["delegationTypeEnumsForCheckBox"] as? [String:Any]{
				delegationTypeEnumsForCheckBox = DelegationTypeEnumsForCheckBox(fromDictionary: delegationTypeEnumsForCheckBoxData)
			}
		descriptionField = dictionary["description"] as? String
		endDate = dictionary["endDate"] as? String
		isEffective = dictionary["isEffective"] as? Bool
		passiveUserId = dictionary["passiveUserId"] as? Int
		passiveUserNameSurname = dictionary["passiveUserNameSurname"] as? String
		startDate = dictionary["startDate"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if activeUserId != nil{
			dictionary["activeUserId"] = activeUserId
		}
		if activeUserNameSurname != nil{
			dictionary["activeUserNameSurname"] = activeUserNameSurname
		}
		if delegationId != nil{
			dictionary["delegationId"] = delegationId
		}
		if delegationTypeEnumsForCheckBox != nil{
			dictionary["delegationTypeEnumsForCheckBox"] = delegationTypeEnumsForCheckBox.toDictionary()
		}
		if descriptionField != nil{
			dictionary["description"] = descriptionField
		}
		if endDate != nil{
			dictionary["endDate"] = endDate
		}
		if isEffective != nil{
			dictionary["isEffective"] = isEffective
		}
		if passiveUserId != nil{
			dictionary["passiveUserId"] = passiveUserId
		}
		if passiveUserNameSurname != nil{
			dictionary["passiveUserNameSurname"] = passiveUserNameSurname
		}
		if startDate != nil{
			dictionary["startDate"] = startDate
		}
		return dictionary
	}

}