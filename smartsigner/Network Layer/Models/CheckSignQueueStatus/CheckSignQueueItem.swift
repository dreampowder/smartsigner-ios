//
//	CheckSignQueueItem.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct CheckSignQueueItem{

	var digitalSignQueueStatusEnum : Int!
	var digitalSignQueueStatusEnumAsString : String!
	var errorMessage : String!
	var id : String!
	var setId : String!
	var statusCode : String!
    var entityId: Int!
    var title:String!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		digitalSignQueueStatusEnum = dictionary["DigitalSignQueueStatusEnum"] as? Int
		digitalSignQueueStatusEnumAsString = dictionary["DigitalSignQueueStatusEnumAsString"] as? String
		errorMessage = dictionary["ErrorMessage"] as? String
		id = dictionary["Id"] as? String
		setId = dictionary["SetId"] as? String
		statusCode = dictionary["StatusCode"] as? String
        entityId = dictionary["EntityId"] as? Int
        title = dictionary["Title"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if digitalSignQueueStatusEnum != nil{
			dictionary["DigitalSignQueueStatusEnum"] = digitalSignQueueStatusEnum
		}
		if digitalSignQueueStatusEnumAsString != nil{
			dictionary["DigitalSignQueueStatusEnumAsString"] = digitalSignQueueStatusEnumAsString
		}
		if errorMessage != nil{
			dictionary["ErrorMessage"] = errorMessage
		}
		if id != nil{
			dictionary["Id"] = id
		}
		if setId != nil{
			dictionary["SetId"] = setId
		}
		if statusCode != nil{
			dictionary["StatusCode"] = statusCode
		}
        
        if entityId != nil{
            dictionary["EntityId"] = entityId
        }
        if title != nil {
            dictionary["Title"] = title
        }
		return dictionary
	}

}
