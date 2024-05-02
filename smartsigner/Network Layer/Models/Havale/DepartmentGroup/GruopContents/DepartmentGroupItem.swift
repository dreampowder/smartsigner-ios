//
//	DepartmentGroupItem.swift
//
//	Create by Serdar Coşkun on 26/11/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DepartmentGroupItem{

	var departmentId : Int!
	var documentDistributionTypeEnum : Int!
	var isIncluded : Bool!
	var name : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		departmentId = dictionary["DepartmentId"] as? Int
		documentDistributionTypeEnum = dictionary["DocumentDistributionTypeEnum"] as? Int
		isIncluded = dictionary["IsIncluded"] as? Bool
		name = dictionary["Name"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if departmentId != nil{
			dictionary["DepartmentId"] = departmentId
		}
		if documentDistributionTypeEnum != nil{
			dictionary["DocumentDistributionTypeEnum"] = documentDistributionTypeEnum
		}
		if isIncluded != nil{
			dictionary["IsIncluded"] = isIncluded
		}
		if name != nil{
			dictionary["Name"] = name
		}
		return dictionary
	}

}