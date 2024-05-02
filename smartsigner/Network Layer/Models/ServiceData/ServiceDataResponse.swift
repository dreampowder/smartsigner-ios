//
//	ServiceDataResponse.swift
//
//	Create by Serdar Coşkun on 5/12/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ServiceDataResponse:JsonProtocol{
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return ServiceDataResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return nil
    }
    
	var appVersions : AppVersion!
	var serviceDatas : [ServiceData]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let appVersionsData = dictionary["AppVersions"] as? [String:Any]{
				appVersions = AppVersion(fromDictionary: appVersionsData)
			}
		serviceDatas = [ServiceData]()
		if let serviceDatasArray = dictionary["Services"] as? [[String:Any]]{
			for dic in serviceDatasArray{
				let value = ServiceData(fromDictionary: dic)
				serviceDatas.append(value)
			}
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if appVersions != nil{
			dictionary["AppVersions"] = appVersions.toDictionary()
		}
		if serviceDatas != nil{
			var dictionaryElements = [[String:Any]]()
			for serviceDatasElement in serviceDatas {
				dictionaryElements.append(serviceDatasElement.toDictionary())
			}
			dictionary["ServiceDatas"] = dictionaryElements
		}
		return dictionary
	}

}
