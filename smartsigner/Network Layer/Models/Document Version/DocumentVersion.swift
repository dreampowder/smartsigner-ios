//
//	DocumentVersion.swift
//
//	Create by Serdar Coşkun on 14/10/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DocumentVersion{

	var documentId : Int!
	var subject : String!
	var versionDate : String!
	var versionNumber : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		documentId = dictionary["DocumentId"] as? Int
		subject = dictionary["Subject"] as? String
		versionDate = dictionary["VersionDate"] as? String
		versionNumber = dictionary["VersionNumber"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if documentId != nil{
			dictionary["DocumentId"] = documentId
		}
		if subject != nil{
			dictionary["Subject"] = subject
		}
		if versionDate != nil{
			dictionary["VersionDate"] = versionDate
		}
		if versionNumber != nil{
			dictionary["VersionNumber"] = versionNumber
		}
		return dictionary
	}

}