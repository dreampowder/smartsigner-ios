//
//	TaskNote.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct TaskNote{

	var createdBy : Int!
	var creationDate : String!
	var creatorUserFullname : String!
	var documentId : AnyObject!
	var documentSubject : String!
	var dueDate : String!
	var id : Int!
	var lastEditBy : Int!
	var lastEditDate : String!
	var noteText : String!
	var relatedDocumentSetId : AnyObject!
	var status : String!
	var taskNoteTypeName : AnyObject!
	var taskNoteUsers : [TaskNoteUser]!
    var assignedToUsers: String!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		createdBy = dictionary["CreatedBy"] as? Int
		creationDate = dictionary["CreationDate"] as? String
		creatorUserFullname = dictionary["CreatorUserFullname"] as? String
		documentId = dictionary["DocumentId"] as? AnyObject
		documentSubject = dictionary["DocumentSubject"] as? String
		dueDate = dictionary["DueDate"] as? String
		id = dictionary["Id"] as? Int
		lastEditBy = dictionary["LastEditBy"] as? Int
		lastEditDate = dictionary["LastEditDate"] as? String
		noteText = dictionary["NoteText"] as? String
		relatedDocumentSetId = dictionary["RelatedDocumentSetId"] as? AnyObject
		status = dictionary["Status"] as? String
		taskNoteTypeName = dictionary["TaskNoteTypeName"] as? AnyObject
		taskNoteUsers = [TaskNoteUser]()
		if let taskNoteUsersArray = dictionary["TaskNoteUsers"] as? [[String:Any]]{
			for dic in taskNoteUsersArray{
				let value = TaskNoteUser(fromDictionary: dic)
				taskNoteUsers.append(value)
			}
		}
        assignedToUsers = dictionary["AssignedToUsers"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if createdBy != nil{
			dictionary["CreatedBy"] = createdBy
		}
		if creationDate != nil{
			dictionary["CreationDate"] = creationDate
		}
		if creatorUserFullname != nil{
			dictionary["CreatorUserFullname"] = creatorUserFullname
		}
		if documentId != nil{
			dictionary["DocumentId"] = documentId
		}
		if documentSubject != nil{
			dictionary["DocumentSubject"] = documentSubject
		}
		if dueDate != nil{
			dictionary["DueDate"] = dueDate
		}
		if id != nil{
			dictionary["Id"] = id
		}
		if lastEditBy != nil{
			dictionary["LastEditBy"] = lastEditBy
		}
		if lastEditDate != nil{
			dictionary["LastEditDate"] = lastEditDate
		}
		if noteText != nil{
			dictionary["NoteText"] = noteText
		}
		if relatedDocumentSetId != nil{
			dictionary["RelatedDocumentSetId"] = relatedDocumentSetId
		}
		if status != nil{
			dictionary["Status"] = status
		}
		if taskNoteTypeName != nil{
			dictionary["TaskNoteTypeName"] = taskNoteTypeName
		}
		if taskNoteUsers != nil{
			var dictionaryElements = [[String:Any]]()
			for taskNoteUsersElement in taskNoteUsers {
				dictionaryElements.append(taskNoteUsersElement.toDictionary())
			}
			dictionary["TaskNoteUsers"] = dictionaryElements
		}
		return dictionary
	}

}
