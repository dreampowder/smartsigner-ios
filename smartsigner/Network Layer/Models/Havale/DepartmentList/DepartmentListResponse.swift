//
//	DepartmentListResponse.swift
//
//	Create by Serdar Coşkun on 23/11/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DepartmentListResponse:JsonProtocol{
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return DepartmentListResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.exceptionMessage, exceptionCode: self.errorCode)
    }
    
	var departments : [Department]!
	var errorCode : String!
	var exceptionMessage : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		departments = [Department]()
		if let departmentsArray = dictionary["Departments"] as? [[String:Any]]{
			for dic in departmentsArray{
				let value = Department(fromDictionary: dic)
				departments.append(value)
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
		if departments != nil{
			var dictionaryElements = [[String:Any]]()
			for departmentsElement in departments {
				dictionaryElements.append(departmentsElement.toDictionary())
			}
			dictionary["Departments"] = dictionaryElements
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
