//
//	DocumentVersionBaseClass.swift
//
//	Create by Serdar Coşkun on 14/10/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DocumentVersionBaseClass:JsonProtocol{
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.exceptionMessage, exceptionCode: self.errorCode)
    }
    
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return DocumentVersionBaseClass(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    

    
    
	var documentVersions : [DocumentVersion]!
	var errorCode : String!
	var exceptionMessage : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		documentVersions = [DocumentVersion]()
		if let documentVersionsArray = dictionary["Versions"] as? [[String:Any]]{
			for dic in documentVersionsArray{
				let value = DocumentVersion(fromDictionary: dic)
				documentVersions.append(value)
			}
		}
		errorCode = dictionary["ErrorCode"] as? String
		exceptionMessage = dictionary["ExceptionMessage"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if documentVersions != nil{
			var dictionaryElements = [[String:Any]]()
			for documentVersionsElement in documentVersions {
				dictionaryElements.append(documentVersionsElement.toDictionary())
			}
			dictionary["Versions"] = dictionaryElements
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
