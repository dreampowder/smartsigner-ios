//
//	ESignPackageResponse.swift
//
//	Create by Serdar Coşkun on 15/12/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ESignPackageResponse:JsonProtocol{
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return ESignPackageResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.exceptionMessage, exceptionCode: "")
    }

	var createPackageResponse : CreatePackageResponse!
	var documentSignRequest : DocumentSignRequest!
	var documentSignResponse : DocumentSignResponse!
	var isSignature : Bool!
	var operationGuid : String!
    var exceptionMessage: String!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let createPackageResponseData = dictionary["CreatePackageResponse"] as? [String:Any]{
				createPackageResponse = CreatePackageResponse(fromDictionary: createPackageResponseData)
			}
		if let documentSignRequestData = dictionary["DocumentSignRequest"] as? [String:Any]{
				documentSignRequest = DocumentSignRequest(fromDictionary: documentSignRequestData)
			}
		if let documentSignResponseData = dictionary["DocumentSignResponse"] as? [String:Any]{
				documentSignResponse = DocumentSignResponse(fromDictionary: documentSignResponseData)
			}
		isSignature = dictionary["IsSignature"] as? Bool
		operationGuid = dictionary["OperationGuid"] as? String
        exceptionMessage = dictionary["ExceptionMessage"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if createPackageResponse != nil{
			dictionary["CreatePackageResponse"] = createPackageResponse.toDictionary()
		}
		if documentSignRequest != nil{
			dictionary["DocumentSignRequest"] = documentSignRequest.toDictionary()
		}
		if documentSignResponse != nil{
			dictionary["DocumentSignResponse"] = documentSignResponse.toDictionary()
		}
		if isSignature != nil{
			dictionary["IsSignature"] = isSignature
		}
		if operationGuid != nil{
			dictionary["OperationGuid"] = operationGuid
		}
		return dictionary
	}

}
