//
//	AssignmentType.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct TaskNoteAssignmentType{

	var canClose : Bool!
	var colorHex : String!
	var name : String!
	var order : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		canClose = dictionary["CanClose"] as? Bool
		colorHex = dictionary["ColorHex"] as? String
		name = dictionary["Name"] as? String
		order = dictionary["Order"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if canClose != nil{
			dictionary["CanClose"] = canClose
		}
		if colorHex != nil{
			dictionary["ColorHex"] = colorHex
		}
		if name != nil{
			dictionary["Name"] = name
		}
		if order != nil{
			dictionary["Order"] = order
		}
		return dictionary
	}

}
