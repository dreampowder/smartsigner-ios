//
//	AppVersion.swift
//
//	Create by Serdar Coşkun on 5/12/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct AppVersion{

	var android : String!
	var iOS : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		android = dictionary["Android"] as? String
		iOS = dictionary["IOS"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if android != nil{
			dictionary["Android"] = android
		}
		if iOS != nil{
			dictionary["IOS"] = iOS
		}
		return dictionary
	}

}