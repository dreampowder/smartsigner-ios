//
//	DeactivateDelegateResponse.swift
//
//	Create by Serdar Coşkun on 4/1/2019
//	Copyright © 2019 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DeactivateDelegateResponse:JsonProtocol{
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return DeactivateDelegateResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return self.isSuccess ? nil : promptText
    }

	var isSuccess : Bool!
	var promptText : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		isSuccess = dictionary["IsSuccess"] as? Bool
		promptText = dictionary["PromptText"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if isSuccess != nil{
			dictionary["IsSuccess"] = isSuccess
		}
		if promptText != nil{
			dictionary["PromptText"] = promptText
		}
		return dictionary
	}

}
