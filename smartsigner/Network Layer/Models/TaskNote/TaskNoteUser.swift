//
//	TaskNoteUser.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct TaskNoteUser{

	var assignmentType : String!
	var id : Int!
	var userFullName : String!
	var userId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		assignmentType = dictionary["AssignmentType"] as? String
		id = dictionary["Id"] as? Int
		userFullName = dictionary["UserFullName"] as? String
		userId = dictionary["UserId"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if assignmentType != nil{
			dictionary["AssignmentType"] = assignmentType
		}
		if id != nil{
			dictionary["Id"] = id
		}
		if userFullName != nil{
			dictionary["UserFullName"] = userFullName
		}
		if userId != nil{
			dictionary["UserId"] = userId
		}
		return dictionary
	}

}