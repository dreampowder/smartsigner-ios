//
//	MobileSignFingerPrintResponse.swift
//
//	Create by Serdar Coşkun on 22/1/2019
//	Copyright © 2019 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct MobileSignFingerPrintResponse:JsonProtocol{
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return MobileSignFingerPrintResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.exceptionMessage, exceptionCode: self.errorCode)
    }
    

    
    
	var errorCode : String!
	var exceptionMessage : String!
	var fingerPrint : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		errorCode = dictionary["ErrorCode"] as? String
		exceptionMessage = dictionary["ExceptionMessage"] as? String
		fingerPrint = dictionary["FingerPrint"] as? String
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
		if fingerPrint != nil{
			dictionary["FingerPrint"] = fingerPrint
		}
		return dictionary
	}

}
