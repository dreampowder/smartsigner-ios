//
//	SaveTaskNoteOperationRequest.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct SaveTaskNoteOperationRequest{

	var addedAssignedToUserId : AddedAssignedToUserId!
	var delegatedUserIds : [Int]!
	var dueDate : String!
	var messageText : String!
	var noteText : String!
	var operationType : String!
	var removedAssignedToUserId : AddedAssignedToUserId!
	var taskNoteId : Int!
	var updatedAssignmentInfo : AddedAssignedToUserId!

    var uiPayload:String?

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let addedAssignedToUserIdData = dictionary["AddedAssignedToUserId"] as? [String:Any]{
				addedAssignedToUserId = AddedAssignedToUserId(fromDictionary: addedAssignedToUserIdData)
			}
		delegatedUserIds = dictionary["DelegatedUserIds"] as? [Int]
		dueDate = dictionary["DueDate"] as? String
		messageText = dictionary["MessageText"] as? String
		noteText = dictionary["NoteText"] as? String
		operationType = dictionary["OperationType"] as? String
		if let removedAssignedToUserIdData = dictionary["RemovedAssignedToUserId"] as? [String:Any]{
				removedAssignedToUserId = AddedAssignedToUserId(fromDictionary: removedAssignedToUserIdData)
			}
		taskNoteId = dictionary["TaskNoteId"] as? Int
		if let updatedAssignmentInfoData = dictionary["UpdatedAssignmentInfo"] as? [String:Any]{
				updatedAssignmentInfo = AddedAssignedToUserId(fromDictionary: updatedAssignmentInfoData)
			}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if addedAssignedToUserId != nil{
			dictionary["AddedAssignedToUserId"] = addedAssignedToUserId.toDictionary()
		}
		if delegatedUserIds != nil{
			dictionary["DelegatedUserIds"] = delegatedUserIds
		}
		if dueDate != nil{
			dictionary["DueDate"] = dueDate
		}
		if messageText != nil{
			dictionary["MessageText"] = messageText
		}
		if noteText != nil{
			dictionary["NoteText"] = noteText
		}
		if operationType != nil{
			dictionary["OperationType"] = operationType
		}
		if removedAssignedToUserId != nil{
			dictionary["RemovedAssignedToUserId"] = removedAssignedToUserId.toDictionary()
		}
		if taskNoteId != nil{
			dictionary["TaskNoteId"] = taskNoteId
		}
		if updatedAssignmentInfo != nil{
			dictionary["UpdatedAssignmentInfo"] = updatedAssignmentInfo.toDictionary()
		}
		return dictionary
	}

}
