//
//	ServiceData.swift
//
//	Create by Serdar Coşkun on 5/12/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ServiceData{

	var canUseMobileSign : Bool!
	var code : String!
	var id : Int!
	var imageUrl : String!
	var isArkEnabled : Bool!
	var isEnabled : Bool!
	var isTestService : Bool!
	var projectName : String!
	var serviceUrl : String!
    var isIOSEnabled: Bool!
    var orderNumber: Int!
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
    init(fromDictionary dictionary: [String:Any]){
        self.init(fromDictionary: dictionary, willDecrypt: true)
    }
    
    init(fromDictionary dictionary: [String:Any],willDecrypt: Bool){
		canUseMobileSign = dictionary["CanUseMobileSign"] as? Bool
		code = dictionary["Code"] as? String
		id = dictionary["Id"] as? Int
		imageUrl = dictionary["ImageUrl"] as? String
		isArkEnabled = dictionary["IsArkEnabled"] as? Bool
		isEnabled = dictionary["IsEnabled"] as? Bool
		isTestService = dictionary["IsTestService"] as? Bool
		projectName = dictionary["ProjectName"] as? String
		serviceUrl = dictionary["ServiceUrl"] as? String
        isIOSEnabled = dictionary["IsIOSEnabled"] as? Bool
        orderNumber = dictionary["OrderNumber"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if canUseMobileSign != nil{
			dictionary["CanUseMobileSign"] = canUseMobileSign
		}
		if code != nil{
			dictionary["Code"] = code
		}
		if id != nil{
			dictionary["Id"] = id
		}
		if imageUrl != nil{
			dictionary["ImageUrl"] = imageUrl
		}
		if isArkEnabled != nil{
			dictionary["IsArkEnabled"] = isArkEnabled
		}
		if isEnabled != nil{
			dictionary["IsEnabled"] = isEnabled
		}
		if isTestService != nil{
			dictionary["IsTestService"] = isTestService
		}
		if projectName != nil{
			dictionary["ProjectName"] = projectName
		}
		if serviceUrl != nil{
			dictionary["ServiceUrl"] = serviceUrl
		}
        if isEnabled != nil{
            dictionary["IsIOSEnabled"] = isIOSEnabled
        }
        
        if orderNumber != nil{
            dictionary["OrderNumber"] = orderNumber
        }
		return dictionary
	}

}
