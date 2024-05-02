//
//	SearchDelegateResponse.swift
//
//	Create by Serdar Coşkun on 18/10/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct SearchUserResponse:JsonProtocol{
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.exceptionMessage, exceptionCode: self.errorCode)
    }
    
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return SearchUserResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
	var errorCode : String!
	var exceptionMessage : String!
	var users : [User]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		errorCode = dictionary["ErrorCode"] as? String
		exceptionMessage = dictionary["ExceptionMessage"] as? String
		users = [User]()
		if let usersArray = dictionary["Users"] as? [[String:Any]]{
			for dic in usersArray{
				let value = User(fromDictionary: dic)
				users.append(value)
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
		if users != nil{
			var dictionaryElements = [[String:Any]]()
			for usersElement in users {
				dictionaryElements.append(usersElement.toDictionary())
			}
			dictionary["Users"] = dictionaryElements
		}
		return dictionary
	}

}
