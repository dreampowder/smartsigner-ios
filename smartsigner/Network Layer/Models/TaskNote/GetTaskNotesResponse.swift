//
//	GetTaskNotesResponse.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct GetTaskNotesResponse:JsonProtocol{
    
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return GetTaskNotesResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.exceptionMessage, exceptionCode: self.errorCode)
    }
    

	var errorCode : String!
	var exceptionMessage : String!
	var taskNotes : [TaskNote]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		errorCode = dictionary["ErrorCode"] as? String
		exceptionMessage = dictionary["ExceptionMessage"] as? String
		taskNotes = [TaskNote]()
		if let taskNotesArray = dictionary["TaskNotes"] as? [[String:Any]]{
			for dic in taskNotesArray{
				let value = TaskNote(fromDictionary: dic)
				taskNotes.append(value)
			}
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if errorCode != nil{
			dictionary["ErrorCode"] = errorCode
		}
		if exceptionMessage != nil{
			dictionary["ExceptionMessage"] = exceptionMessage
		}
		if taskNotes != nil{
			var dictionaryElements = [[String:Any]]()
			for taskNotesElement in taskNotes {
				dictionaryElements.append(taskNotesElement.toDictionary())
			}
			dictionary["TaskNotes"] = dictionaryElements
		}
		return dictionary
	}

}
