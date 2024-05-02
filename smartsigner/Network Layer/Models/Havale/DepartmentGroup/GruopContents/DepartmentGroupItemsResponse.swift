//
//	DepartmentGroupItemsResponse.swift
//
//	Create by Serdar Coşkun on 26/11/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DepartmentGroupItemsResponse:JsonProtocol{
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return DepartmentGroupItemsResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return self.exceptionMessage
    }
    

    
    
	var departmentGroupItems : [DepartmentGroupItem]!
	var errorCode : Int!
	var exceptionMessage : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		departmentGroupItems = [DepartmentGroupItem]()
		if let departmentGroupItemsArray = dictionary["Departments"] as? [[String:Any]]{
			for dic in departmentGroupItemsArray{
				let value = DepartmentGroupItem(fromDictionary: dic)
				departmentGroupItems.append(value)
			}
		}
		errorCode = dictionary["ErrorCode"] as? Int
		exceptionMessage = dictionary["ExceptionMessage"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if departmentGroupItems != nil{
			var dictionaryElements = [[String:Any]]()
			for departmentGroupItemsElement in departmentGroupItems {
				dictionaryElements.append(departmentGroupItemsElement.toDictionary())
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
