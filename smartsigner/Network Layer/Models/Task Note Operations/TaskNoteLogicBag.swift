//
//	TaskNoteLogicBag.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct TaskNoteLogicBag{

	var operation : String!
	var parameters : [TaskNoteLogicParameter]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		operation = dictionary["Operation"] as? String
		parameters = [TaskNoteLogicParameter]()
		if let parametersArray = dictionary["Parameters"] as? [[String:Any]]{
			for dic in parametersArray{
				let value = TaskNoteLogicParameter(fromDictionary: dic)
				parameters.append(value)
			}
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if operation != nil{
			dictionary["Operation"] = operation
		}
		if parameters != nil{
			var dictionaryElements = [[String:Any]]()
			for parametersElement in parameters {
				dictionaryElements.append(parametersElement.toDictionary())
			}
			dictionary["Parameters"] = dictionaryElements
		}
		return dictionary
	}

}