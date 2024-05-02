//
//	DocumentSignRequest.swift
//
//	Create by Serdar Coşkun on 15/12/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DocumentSignRequest{

	var documentWithNumberOnItPathOnServer : String!
	var hasChanges : Bool!
	var newDocumentPathOnServer : String!
	var operationTodo : String!
	var poolNewLastEditDate : String!
	var signedPaketOzetiAsString : String!
    var pdfToBeSignedWithCadesAsString: String?

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		documentWithNumberOnItPathOnServer = dictionary["DocumentWithNumberOnItPathOnServer"] as? String
		hasChanges = dictionary["HasChanges"] as? Bool
		newDocumentPathOnServer = dictionary["NewDocumentPathOnServer"] as? String
		operationTodo = dictionary["OperationTodo"] as? String
		poolNewLastEditDate = dictionary["PoolNewLastEditDate"] as? String
		signedPaketOzetiAsString = dictionary["SignedPaketOzetiAsString"] as? String
        pdfToBeSignedWithCadesAsString = dictionary["PdfToBeSignedWithCadesAsString"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if documentWithNumberOnItPathOnServer != nil{
			dictionary["DocumentWithNumberOnItPathOnServer"] = documentWithNumberOnItPathOnServer
		}
		if hasChanges != nil{
			dictionary["HasChanges"] = hasChanges
		}
		if newDocumentPathOnServer != nil{
			dictionary["NewDocumentPathOnServer"] = newDocumentPathOnServer
		}
		if operationTodo != nil{
			dictionary["OperationTodo"] = operationTodo
		}
		if poolNewLastEditDate != nil{
			dictionary["PoolNewLastEditDate"] = poolNewLastEditDate
		}
		if signedPaketOzetiAsString != nil{
			dictionary["SignedPaketOzetiAsString"] = signedPaketOzetiAsString
		}
        if pdfToBeSignedWithCadesAsString != nil{
            dictionary["PdfToBeSignedWithCadesAsString"] = pdfToBeSignedWithCadesAsString
        }
		return dictionary
	}

}
