//
//	DocumentRelated.swift
//
//	Create by Serdar Coşkun on 24/9/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DocumentRelated{

	var fileExtension : String!
	var id : Int!
	var name : String!
	var relatedDocumentTypeEnum : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		fileExtension = dictionary["FileExtension"] as? String
		id = dictionary["Id"] as? Int
		name = dictionary["Name"] as? String
		relatedDocumentTypeEnum = dictionary["RelatedDocumentTypeEnum"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if fileExtension != nil{
			dictionary["FileExtension"] = fileExtension
		}
		if id != nil{
			dictionary["Id"] = id
		}
		if name != nil{
			dictionary["Name"] = name
		}
		if relatedDocumentTypeEnum != nil{
			dictionary["RelatedDocumentTypeEnum"] = relatedDocumentTypeEnum
		}
		return dictionary
	}

    func getAttachmentItem()->DocumentAttachment{
        var attachment = DocumentAttachment(fromDictionary: [:])
        attachment.id = self.id
        attachment.attachmentTypeEnum = self.relatedDocumentTypeEnum
        attachment.name = self.name
        attachment.fileExtension = self.fileExtension
        return attachment
    }
}
