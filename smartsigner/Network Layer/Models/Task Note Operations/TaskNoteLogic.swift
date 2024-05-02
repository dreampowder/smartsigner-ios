//
//	TaskNoteLogic.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct TaskNoteLogic{

	var actionUserId : Int!
	var bookmarkId : String!
	var userChoices : [TaskNoteLogicUserChoice]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		actionUserId = dictionary["ActionUserId"] as? Int
		bookmarkId = dictionary["BookmarkId"] as? String
		userChoices = [TaskNoteLogicUserChoice]()
		if let userChoicesArray = dictionary["UserChoices"] as? [[String:Any]]{
			for dic in userChoicesArray{
				let value = TaskNoteLogicUserChoice(fromDictionary: dic)
				userChoices.append(value)
			}
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if actionUserId != nil{
			dictionary["ActionUserId"] = actionUserId
		}
		if bookmarkId != nil{
			dictionary["BookmarkId"] = bookmarkId
		}
		if userChoices != nil{
			var dictionaryElements = [[String:Any]]()
			for userChoicesElement in userChoices {
				dictionaryElements.append(userChoicesElement.toDictionary())
			}
			dictionary["UserChoices"] = dictionaryElements
		}
		return dictionary
	}

}