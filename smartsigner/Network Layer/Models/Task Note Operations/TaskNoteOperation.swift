//
//	TaskNoteOperation.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct TaskNoteOperation{

	var addedAssignedToUserIds : [Int]!
	var details : String!
	var operationDate : String!
	var operationType : String!
	var operatorUserFullname : String!
	var operatorUserId : Int!
	var taskNoteId : Int!
	var taskNoteLogic : TaskNoteLogic?
	var uIString : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		addedAssignedToUserIds = [Int]()
        if let array = dictionary["AddedAssignedToUserIds"] as? [Int]{
            addedAssignedToUserIds = array
        }
		details = dictionary["Details"] as? String
		operationDate = dictionary["OperationDate"] as? String
		operationType = dictionary["OperationType"] as? String
		operatorUserFullname = dictionary["OperatorUserFullname"] as? String
		operatorUserId = dictionary["OperatorUserId"] as? Int
		taskNoteId = dictionary["TaskNoteId"] as? Int
        
        if let taskDict = dictionary["TaskNoteLogic"] as? [String:Any]{
            taskNoteLogic = TaskNoteLogic(fromDictionary: taskDict)
        }
        
		uIString = dictionary["UIString"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if addedAssignedToUserIds != nil{
			dictionary["AddedAssignedToUserIds"] = addedAssignedToUserIds
		}
		if details != nil{
			dictionary["Details"] = details
		}
		if operationDate != nil{
			dictionary["OperationDate"] = operationDate
		}
		if operationType != nil{
			dictionary["OperationType"] = operationType
		}
		if operatorUserFullname != nil{
			dictionary["OperatorUserFullname"] = operatorUserFullname
		}
		if operatorUserId != nil{
			dictionary["OperatorUserId"] = operatorUserId
		}
		if taskNoteId != nil{
			dictionary["TaskNoteId"] = taskNoteId
		}
		if taskNoteLogic != nil{
            dictionary["TaskNoteLogic"] = taskNoteLogic?.toDictionary()
		}
		if uIString != nil{
			dictionary["UIString"] = uIString
		}
		return dictionary
	}

}
