//
//	LogicResult.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct LogicResult{

	var details : String!
	var errorCode : String!
	var isSuccess : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		details = dictionary["Details"] as? String
		errorCode = dictionary["ErrorCode"] as? String
		isSuccess = dictionary["IsSuccess"] as? Bool
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if details != nil{
			dictionary["Details"] = details
		}
		if errorCode != nil{
			dictionary["ErrorCode"] = errorCode
		}
		if isSuccess != nil{
			dictionary["IsSuccess"] = isSuccess
		}
		return dictionary
	}

}
