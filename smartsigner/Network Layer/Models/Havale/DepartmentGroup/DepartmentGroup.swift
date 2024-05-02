//
//	DepartmentGroup.swift
//
//	Create by Serdar Coşkun on 26/11/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DepartmentGroup{

	var documentDistributionType : Int!
	var id : Int!
	var name : String!

    var groupItems:[DepartmentGroupItem]?

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		documentDistributionType = dictionary["DocumentDistributionType"] as? Int
		id = dictionary["Id"] as? Int
		name = dictionary["Name"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if documentDistributionType != nil{
			dictionary["DocumentDistributionType"] = documentDistributionType
		}
		if id != nil{
			dictionary["Id"] = id
		}
		if name != nil{
			dictionary["Name"] = name
		}
		return dictionary
	}

}
