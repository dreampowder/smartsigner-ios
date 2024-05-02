//
//	DocumentHistoryBaseClass.swift
//
//	Create by Serdar Coşkun on 14/10/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DocumentHistoryBaseClass:JsonProtocol{
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.exceptionMessage, exceptionCode: self.errorCode)
    }
    
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return DocumentHistoryBaseClass(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
	var documentHistories : [DocumentHistory]!
	var documentId : Int!
	var errorCode : String!
	var exceptionMessage : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		documentHistories = [DocumentHistory]()
		if let documentHistoriesArray = dictionary["DocumentMotionJsons"] as? [[String:Any]]{
			for dic in documentHistoriesArray{
				let value = DocumentHistory(fromDictionary: dic)
				documentHistories.append(value)
			}
		}
		documentId = dictionary["DocumentId"] as? Int
		errorCode = dictionary["ErrorCode"] as? String
		exceptionMessage = dictionary["ExceptionMessage"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if documentHistories != nil{
			var dictionaryElements = [[String:Any]]()
			for documentHistoriesElement in documentHistories {
				dictionaryElements.append(documentHistoriesElement.toDictionary())
			}
			dictionary["DocumentMotionJsons"] = dictionaryElements
		}
		if documentId != nil{
			dictionary["DocumentId"] = documentId
		}
		if errorCode != nil{
			dictionary["ErrorCode"] = errorCode
		}
		if exceptionMessage != nil{
			dictionary["ExceptionMessage"] = exceptionMessage
		}
		return dictionary
	}

}
