//
//	GetTaskNoteOperationsResponse.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct GetTaskNoteOperationsResponse:JsonProtocol{
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: exceptionMessage, exceptionCode: errorCode)
    }
    
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return GetTaskNoteOperationsResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }

	var errorCode : String!
	var exceptionMessage : String!
	var taskNoteOperations : [TaskNoteOperation]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		errorCode = dictionary["ErrorCode"] as? String
		exceptionMessage = dictionary["ExceptionMessage"] as? String
		taskNoteOperations = [TaskNoteOperation]()
		if let taskNoteOperationsArray = dictionary["TaskNoteOperations"] as? [[String:Any]]{
			for dic in taskNoteOperationsArray{
				let value = TaskNoteOperation(fromDictionary: dic)
				taskNoteOperations.append(value)
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
		if taskNoteOperations != nil{
			var dictionaryElements = [[String:Any]]()
			for taskNoteOperationsElement in taskNoteOperations {
				dictionaryElements.append(taskNoteOperationsElement.toDictionary())
			}
			dictionary["TaskNoteOperations"] = dictionaryElements
		}
		return dictionary
	}

}
