//
//	AttachmentContent.swift
//
//	Create by Serdar Coşkun on 5/11/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct AttachmentContent:JsonProtocol{

    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.exceptionMessage, exceptionCode: self.errorCode)
    }

    static func parseJson(dictionary: [String : Any]) -> Any? {
        return AttachmentContent(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }

	var data : String!
	var errorCode : String!
	var exceptionMessage : String!
	var fileExtension : String!
	var fileName : String!
	var filePath : String!
	var hrfDescription : String!
	var hrfName : String!
	var id : Int!
	var isDownloadable : Bool!
	var isPhysicalAttachment : Bool?
    var isPhysicalRelatedDocument: Bool?
    var documentDate:String?
    var documentDescription:String?
    var documentNumberBYK:String?
    var documentNumberNumber:String?
    var documentNumberSdp:String?
    var documentSubject:String?
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		data = dictionary["Data"] as? String
		errorCode = dictionary["ErrorCode"] as? String
		exceptionMessage = dictionary["ExceptionMessage"] as? String
		fileExtension = dictionary["FileExtension"] as? String
		fileName = dictionary["FileName"] as? String
		filePath = dictionary["FilePath"] as? String
		hrfDescription = dictionary["HrfDescription"] as? String
		hrfName = dictionary["HrfName"] as? String
		id = dictionary["Id"] as? Int
		isDownloadable = dictionary["IsDownloadable"] as? Bool
		isPhysicalAttachment = dictionary["IsPhysicalAttachment"] as? Bool
        if isPhysicalAttachment == nil {
            isPhysicalAttachment = dictionary["IsPhysicalAttacment"] as? Bool //Yazım hatası vardı buna göre inceliyoruz
        }
        isPhysicalRelatedDocument = dictionary["IsPhysicalRelatedDocument"] as? Bool
        
        documentDate = dictionary["DocumentDate"] as? String
        documentDescription = dictionary["DocumentDescription"] as? String
        documentNumberBYK = dictionary["documentNumberBYK"] as? String
        documentNumberNumber = dictionary["DocumentNumberNumber"] as? String
        documentNumberSdp = dictionary["DocumentNumberSdp"] as? String
        documentSubject = dictionary["DocumentSubject"] as? String
	}

//    "ErrorCode": null,
//    "ExceptionMessage": null,
//    "Data": null,
//    "DocumentDate": "16.11.2019",
//    "DocumentDescription": "asd",
//    "DocumentNumberBYK": "11",
//    "DocumentNumberNumber": "123",
//    "DocumentNumberSdp": "1",
//    "DocumentSubject": "Test",
//    "FileExtension": null,
//    "FileName": null,
//    "Id": 20872,
//    "IsDownloadable": false,
//    "IsPhysicalAttachment": false,
//    "IsPhysicalRelatedDocument": true
    
	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if data != nil{
			dictionary["Data"] = data
		}
		if errorCode != nil{
			dictionary["ErrorCode"] = errorCode
		}
		if exceptionMessage != nil{
			dictionary["ExceptionMessage"] = exceptionMessage
		}
		if fileExtension != nil{
			dictionary["FileExtension"] = fileExtension
		}
		if fileName != nil{
			dictionary["FileName"] = fileName
		}
		if filePath != nil{
			dictionary["FilePath"] = filePath
		}
		if hrfDescription != nil{
			dictionary["HrfDescription"] = hrfDescription
		}
		if hrfName != nil{
			dictionary["HrfName"] = hrfName
		}
		if id != nil{
			dictionary["Id"] = id
		}
		if isDownloadable != nil{
			dictionary["IsDownloadable"] = isDownloadable
		}
		if isPhysicalAttachment != nil{
			dictionary["IsPhysicalAttachment"] = isPhysicalAttachment
		}
		return dictionary
	}

}
