//
//	ESignSmartCardList.swift
//
//	Create by Serdar Coşkun on 11/12/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ESignSmartCardList:NSObject{

	var smartCardDevices : [SmartCardDevice]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		smartCardDevices = [SmartCardDevice]()
		if let smartCardDevicesArray = dictionary["smartCardDevices"] as? [[String:Any]]{
			for dic in smartCardDevicesArray{
				let value = SmartCardDevice(fromDictionary: dic)
				smartCardDevices.append(value)
			}
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func dictionaryRepresantation() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if smartCardDevices != nil{
			var dictionaryElements = [[String:Any]]()
			for smartCardDevicesElement in smartCardDevices {
				dictionaryElements.append(smartCardDevicesElement.dictionaryRepresantation())
			}
			dictionary["smartCardDevices"] = dictionaryElements
		}
		return dictionary
	}

}
