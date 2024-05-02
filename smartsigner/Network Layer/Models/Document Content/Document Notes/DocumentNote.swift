//
//	DocumentNote.swift
//
//	Create by Serdar Coşkun on 25/9/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DocumentNote{

	var commentaryNoteVisibility : Bool!
	var documentId : Int!
	var documentNoteTypeEnum : Int!
	var flowNoteVisibility : Bool!
	var forwardNoteVisibility : Bool!
	var id : Int!
	var isActive : Bool!
	var note : String!
	var noteData : String!
	var noteDateAsString : String!
	var ownerUserId : Int!
	var ownerUserName : String!
	var parentDocumentNoteId : Int!
	var personalNoteVisibility : Bool!
	var sendBackNoteVisibility : Bool!
	var targetDepartmentGroupId : Int!
	var targetDepartmentGroupName : String!
	var targetDepartmentId : Int!
	var targetDepartmentName : String!
	var targetName : String!
	var targetUserGroupId : Int!
	var targetUserGroupName : String!
	var targetUserId : Int!
	var targetUserName : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		commentaryNoteVisibility = dictionary["CommentaryNoteVisibility"] as? Bool
		documentId = dictionary["DocumentId"] as? Int
		documentNoteTypeEnum = dictionary["DocumentNoteTypeEnum"] as? Int
		flowNoteVisibility = dictionary["FlowNoteVisibility"] as? Bool
		forwardNoteVisibility = dictionary["ForwardNoteVisibility"] as? Bool
		id = dictionary["Id"] as? Int
		isActive = dictionary["IsActive"] as? Bool
		note = dictionary["Note"] as? String
		noteData = dictionary["NoteData"] as? String
		noteDateAsString = dictionary["NoteDateAsString"] as? String
		ownerUserId = dictionary["OwnerUserId"] as? Int
		ownerUserName = dictionary["OwnerUserName"] as? String
		parentDocumentNoteId = dictionary["ParentDocumentNoteId"] as? Int
		personalNoteVisibility = dictionary["PersonalNoteVisibility"] as? Bool
		sendBackNoteVisibility = dictionary["SendBackNoteVisibility"] as? Bool
		targetDepartmentGroupId = dictionary["TargetDepartmentGroupId"] as? Int
		targetDepartmentGroupName = dictionary["TargetDepartmentGroupName"] as? String
		targetDepartmentId = dictionary["TargetDepartmentId"] as? Int
		targetDepartmentName = dictionary["TargetDepartmentName"] as? String
		targetName = dictionary["TargetName"] as? String
		targetUserGroupId = dictionary["TargetUserGroupId"] as? Int
		targetUserGroupName = dictionary["TargetUserGroupName"] as? String
		targetUserId = dictionary["TargetUserId"] as? Int
		targetUserName = dictionary["TargetUserName"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if commentaryNoteVisibility != nil{
			dictionary["CommentaryNoteVisibility"] = commentaryNoteVisibility
		}
		if documentId != nil{
			dictionary["DocumentId"] = documentId
		}
		if documentNoteTypeEnum != nil{
			dictionary["DocumentNoteTypeEnum"] = documentNoteTypeEnum
		}
		if flowNoteVisibility != nil{
			dictionary["FlowNoteVisibility"] = flowNoteVisibility
		}
		if forwardNoteVisibility != nil{
			dictionary["ForwardNoteVisibility"] = forwardNoteVisibility
		}
		if id != nil{
			dictionary["Id"] = id
		}
		if isActive != nil{
			dictionary["IsActive"] = isActive
		}
		if note != nil{
			dictionary["Note"] = note
		}
		if noteData != nil{
			dictionary["NoteData"] = noteData
		}
		if noteDateAsString != nil{
			dictionary["NoteDateAsString"] = noteDateAsString
		}
		if ownerUserId != nil{
			dictionary["OwnerUserId"] = ownerUserId
		}
		if ownerUserName != nil{
			dictionary["OwnerUserName"] = ownerUserName
		}
		if parentDocumentNoteId != nil{
			dictionary["ParentDocumentNoteId"] = parentDocumentNoteId
		}
		if personalNoteVisibility != nil{
			dictionary["PersonalNoteVisibility"] = personalNoteVisibility
		}
		if sendBackNoteVisibility != nil{
			dictionary["SendBackNoteVisibility"] = sendBackNoteVisibility
		}
		if targetDepartmentGroupId != nil{
			dictionary["TargetDepartmentGroupId"] = targetDepartmentGroupId
		}
		if targetDepartmentGroupName != nil{
			dictionary["TargetDepartmentGroupName"] = targetDepartmentGroupName
		}
		if targetDepartmentId != nil{
			dictionary["TargetDepartmentId"] = targetDepartmentId
		}
		if targetDepartmentName != nil{
			dictionary["TargetDepartmentName"] = targetDepartmentName
		}
		if targetName != nil{
			dictionary["TargetName"] = targetName
		}
		if targetUserGroupId != nil{
			dictionary["TargetUserGroupId"] = targetUserGroupId
		}
		if targetUserGroupName != nil{
			dictionary["TargetUserGroupName"] = targetUserGroupName
		}
		if targetUserId != nil{
			dictionary["TargetUserId"] = targetUserId
		}
		if targetUserName != nil{
			dictionary["TargetUserName"] = targetUserName
		}
		return dictionary
	}

}
