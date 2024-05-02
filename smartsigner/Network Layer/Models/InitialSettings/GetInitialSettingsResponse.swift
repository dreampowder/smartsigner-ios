//
//	GetInitialSettingsResponse.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct GetInitialSettingsResponse:JsonProtocol{
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return GetInitialSettingsResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: exceptionMessage, exceptionCode: errorCode)
    }
    

    
    
	var departmentSettings : [DepartmentSetting]!
	var errorCode : String!
	var exceptionMessage : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		departmentSettings = [DepartmentSetting]()
		if let departmentSettingsArray = dictionary["Settings"] as? [[String:Any]]{
			for dic in departmentSettingsArray{
				let value = DepartmentSetting(fromDictionary: dic)
				departmentSettings.append(value)
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
		if departmentSettings != nil{
			var dictionaryElements = [[String:Any]]()
			for departmentSettingsElement in departmentSettings {
				dictionaryElements.append(departmentSettingsElement.toDictionary())
			}
			dictionary["Settings"] = dictionaryElements
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
