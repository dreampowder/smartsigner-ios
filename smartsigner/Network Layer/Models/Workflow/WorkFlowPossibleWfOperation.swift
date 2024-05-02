//
//	WorkFlowPossibleWfOperation.swift
//
//	Create by Serdar Coşkun on 21/1/2019
//	Copyright © 2019 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct WorkFlowPossibleWfOperation{

	var displayName : String!
	var id : Int!
	var operation : WorkFlowOperation!
	var userMessage : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		displayName = dictionary["DisplayName"] as? String
		id = dictionary["Id"] as? Int
		if let operationData = dictionary["Operation"] as? [String:Any]{
				operation = WorkFlowOperation(fromDictionary: operationData)
			}
		userMessage = dictionary["UserMessage"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if displayName != nil{
			dictionary["DisplayName"] = displayName
		}
		if id != nil{
			dictionary["Id"] = id
		}
		if operation != nil{
			dictionary["Operation"] = operation.toDictionary()
		}
		if userMessage != nil{
			dictionary["UserMessage"] = userMessage
		}
		return dictionary
	}

}