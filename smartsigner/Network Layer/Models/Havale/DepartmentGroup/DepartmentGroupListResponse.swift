//
//	DepartmentGroupListResponse.swift
//
//	Create by Serdar Coşkun on 26/11/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DepartmentGroupListResponse:JsonProtocol{
    
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return DepartmentGroupListResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.exceptionMessage, exceptionCode: self.errorCode)
    }
    

	var departmentGroups : [DepartmentGroup]!
	var errorCode : String!
	var exceptionMessage : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		departmentGroups = [DepartmentGroup]()
		if let departmentGroupsArray = dictionary["DepartmentGroups"] as? [[String:Any]]{
			for dic in departmentGroupsArray{
				let value = DepartmentGroup(fromDictionary: dic)
				departmentGroups.append(value)
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
		if departmentGroups != nil{
			var dictionaryElements = [[String:Any]]()
			for departmentGroupsElement in departmentGroups {
				dictionaryElements.append(departmentGroupsElement.toDictionary())
			}
			dictionary["DepartmentGroups"] = dictionaryElements
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
