//
//	DocumentNotesResponse.swift
//
//	Create by Serdar Coşkun on 25/9/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DocumentNotesResponse:JsonProtocol{
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.exceptionMessage, exceptionCode: self.errorCode)
    }
    
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return DocumentNotesResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    

	var errorCode : String!
	var exceptionMessage : String!
	var notes : [DocumentNote]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		errorCode = dictionary["ErrorCode"] as? String
		exceptionMessage = dictionary["ExceptionMessage"] as? String
		notes = [DocumentNote]()
		if let notesArray = dictionary["Notes"] as? [[String:Any]]{
			for dic in notesArray{
				let value = DocumentNote(fromDictionary: dic)
				notes.append(value)
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
		if notes != nil{
			var dictionaryElements = [[String:Any]]()
			for notesElement in notes {
				dictionaryElements.append(notesElement.toDictionary())
			}
			dictionary["Notes"] = dictionaryElements
		}
		return dictionary
	}

}
