//
//	TaskNoteLogicParameter.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct TaskNoteLogicParameter{

	var key : String!
	var value : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		key = dictionary["Key"] as? String
		value = dictionary["Value"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if key != nil{
			dictionary["Key"] = key
		}
		if value != nil{
			dictionary["Value"] = value
		}
		return dictionary
	}

}