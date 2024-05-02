//
//	DepartmentSetting.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DepartmentSetting{

	var departmentSettingNameEnum : Int!
	var value : Any!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		departmentSettingNameEnum = dictionary["DepartmentSettingNameEnum"] as? Int
		value = dictionary["Value"]
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if departmentSettingNameEnum != nil{
			dictionary["DepartmentSettingNameEnum"] = departmentSettingNameEnum
		}
		if value != nil{
			dictionary["Value"] = value
		}
		return dictionary
	}

}
