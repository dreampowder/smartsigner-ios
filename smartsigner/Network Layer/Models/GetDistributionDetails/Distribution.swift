//
//	Distribution.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Distribution{

	var documentDistributionTypeEnum : Int!
	var groupDistributionTypes : AnyObject!
	var groupIds : AnyObject!
	var name : String!
	var orderNumber : Int!
	var targetDepartmentGroupId : Int!
	var targetDepartmentId : Int!
	var targetUserId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		documentDistributionTypeEnum = dictionary["DocumentDistributionTypeEnum"] as? Int
		groupDistributionTypes = dictionary["GroupDistributionTypes"] as? AnyObject
		groupIds = dictionary["GroupIds"] as? AnyObject
		name = dictionary["Name"] as? String
		orderNumber = dictionary["OrderNumber"] as? Int
		targetDepartmentGroupId = dictionary["TargetDepartmentGroupId"] as? Int
		targetDepartmentId = dictionary["TargetDepartmentId"] as? Int
		targetUserId = dictionary["TargetUserId"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if documentDistributionTypeEnum != nil{
			dictionary["DocumentDistributionTypeEnum"] = documentDistributionTypeEnum
		}
		if groupDistributionTypes != nil{
			dictionary["GroupDistributionTypes"] = groupDistributionTypes
		}
		if groupIds != nil{
			dictionary["GroupIds"] = groupIds
		}
		if name != nil{
			dictionary["Name"] = name
		}
		if orderNumber != nil{
			dictionary["OrderNumber"] = orderNumber
		}
		if targetDepartmentGroupId != nil{
			dictionary["TargetDepartmentGroupId"] = targetDepartmentGroupId
		}
		if targetDepartmentId != nil{
			dictionary["TargetDepartmentId"] = targetDepartmentId
		}
		if targetUserId != nil{
			dictionary["TargetUserId"] = targetUserId
		}
		return dictionary
	}

}
