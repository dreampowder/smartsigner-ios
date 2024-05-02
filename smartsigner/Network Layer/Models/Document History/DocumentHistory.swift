//
//	DocumentHistory.swift
//
//	Create by Serdar Coşkun on 14/10/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DocumentHistory{

	var descriptionField : String!
	var documentFlowId : Int!
	var documentId : Int!
	var documentMotionTypeEnumToString : String!
	var motionDate : String!
	var sourceDepartmentId : Int!
	var sourceDepartmentToString : String!
	var sourcePassiveUserId : Int!
	var sourceUserId : Int!
	var sourceUserToString : String!
	var targetDepartmentId : Int!
	var targetDepartmentToString : String!
	var targetUserId : Int!
	var targetUserToString : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		descriptionField = dictionary["Description"] as? String
		documentFlowId = dictionary["DocumentFlowId"] as? Int
		documentId = dictionary["DocumentId"] as? Int
		documentMotionTypeEnumToString = dictionary["DocumentMotionTypeEnumToString"] as? String
		motionDate = dictionary["MotionDate"] as? String
		sourceDepartmentId = dictionary["SourceDepartmentId"] as? Int
		sourceDepartmentToString = dictionary["SourceDepartmentToString"] as? String
		sourcePassiveUserId = dictionary["SourcePassiveUserId"] as? Int
		sourceUserId = dictionary["SourceUserId"] as? Int
		sourceUserToString = dictionary["SourceUserToString"] as? String
		targetDepartmentId = dictionary["TargetDepartmentId"] as? Int
		targetDepartmentToString = dictionary["TargetDepartmentToString"] as? String
		targetUserId = dictionary["TargetUserId"] as? Int
		targetUserToString = dictionary["TargetUserToString"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if descriptionField != nil{
			dictionary["Description"] = descriptionField
		}
		if documentFlowId != nil{
			dictionary["DocumentFlowId"] = documentFlowId
		}
		if documentId != nil{
			dictionary["DocumentId"] = documentId
		}
		if documentMotionTypeEnumToString != nil{
			dictionary["DocumentMotionTypeEnumToString"] = documentMotionTypeEnumToString
		}
		if motionDate != nil{
			dictionary["MotionDate"] = motionDate
		}
		if sourceDepartmentId != nil{
			dictionary["SourceDepartmentId"] = sourceDepartmentId
		}
		if sourceDepartmentToString != nil{
			dictionary["SourceDepartmentToString"] = sourceDepartmentToString
		}
		if sourcePassiveUserId != nil{
			dictionary["SourcePassiveUserId"] = sourcePassiveUserId
		}
		if sourceUserId != nil{
			dictionary["SourceUserId"] = sourceUserId
		}
		if sourceUserToString != nil{
			dictionary["SourceUserToString"] = sourceUserToString
		}
		if targetDepartmentId != nil{
			dictionary["TargetDepartmentId"] = targetDepartmentId
		}
		if targetDepartmentToString != nil{
			dictionary["TargetDepartmentToString"] = targetDepartmentToString
		}
		if targetUserId != nil{
			dictionary["TargetUserId"] = targetUserId
		}
		if targetUserToString != nil{
			dictionary["TargetUserToString"] = targetUserToString
		}
		return dictionary
	}

}