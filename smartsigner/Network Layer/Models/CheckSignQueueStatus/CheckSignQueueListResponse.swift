//
//	CheckSignQueueListResponse.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct CheckSignQueueListResponse:JsonProtocol{
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return CheckSignQueueListResponse.init(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: errorMessage, exceptionCode: statusCode)
    }
    

	var errorMessage : String!
	var items : [CheckSignQueueItem]!
	var statusCode : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		errorMessage = dictionary["ErrorMessage"] as? String
		items = [CheckSignQueueItem]()
		if let itemsArray = dictionary["Items"] as? [[String:Any]]{
			for dic in itemsArray{
				let value = CheckSignQueueItem(fromDictionary: dic)
				items.append(value)
			}
		}
		statusCode = dictionary["StatusCode"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if errorMessage != nil{
			dictionary["ErrorMessage"] = errorMessage
		}
		if items != nil{
			var dictionaryElements = [[String:Any]]()
			for itemsElement in items {
				dictionaryElements.append(itemsElement.toDictionary())
			}
			dictionary["Items"] = dictionaryElements
		}
		if statusCode != nil{
			dictionary["StatusCode"] = statusCode
		}
		return dictionary
	}

}
