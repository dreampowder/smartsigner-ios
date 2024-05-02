//
//	TaskNoteLogicUserChoice.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct TaskNoteLogicUserChoice{

	var bag : TaskNoteLogicBag!
	var descriptionField : String!
	var id : Int!
	var title : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let bagData = dictionary["Bag"] as? [String:Any]{
				bag = TaskNoteLogicBag(fromDictionary: bagData)
			}
		descriptionField = dictionary["Description"] as? String
		id = dictionary["Id"] as? Int
		title = dictionary["Title"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if bag != nil{
			dictionary["Bag"] = bag.toDictionary()
		}
		if descriptionField != nil{
			dictionary["Description"] = descriptionField
		}
		if id != nil{
			dictionary["Id"] = id
		}
		if title != nil{
			dictionary["Title"] = title
		}
		return dictionary
	}

}