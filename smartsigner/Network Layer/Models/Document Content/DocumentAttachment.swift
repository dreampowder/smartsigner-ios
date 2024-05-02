//
//	DocumentAttachment.swift
//
//	Create by Serdar Coşkun on 24/9/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DocumentAttachment{

	var attachmentTypeEnum : Int!
	var descriptionField : String!
	var fileExtension : String!
	var id : Int!
	var isDownloadable : Bool!
	var name : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		attachmentTypeEnum = dictionary["AttachmentTypeEnum"] as? Int
		descriptionField = dictionary["Description"] as? String
		fileExtension = dictionary["FileExtension"] as? String
		id = dictionary["Id"] as? Int
		isDownloadable = dictionary["IsDownloadable"] as? Bool
		name = dictionary["Name"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if attachmentTypeEnum != nil{
			dictionary["AttachmentTypeEnum"] = attachmentTypeEnum
		}
		if descriptionField != nil{
			dictionary["Description"] = descriptionField
		}
		if fileExtension != nil{
			dictionary["FileExtension"] = fileExtension
		}
		if id != nil{
			dictionary["Id"] = id
		}
		if isDownloadable != nil{
			dictionary["IsDownloadable"] = isDownloadable
		}
		if name != nil{
			dictionary["Name"] = name
		}
		return dictionary
	}

}