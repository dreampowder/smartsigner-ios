//
//	WorkFlowClientActionParameter.swift
//
//	Create by Serdar Coşkun on 22/1/2019
//	Copyright © 2019 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct WorkFlowClientActionParameter{

	var key : String!
	var value : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		key = dictionary["Key"] as? String
		value = dictionary["Value"] as? Bool
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