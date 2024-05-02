//
//	GetDistributionDetailResponse.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct GetDistributionDetailResponse:JsonProtocol{
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return GetDistributionDetailResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: exceptionMessage, exceptionCode: errorCode)
    }
    
    
    

	var distributions : [Distribution]!
	var errorCode : String!
	var exceptionMessage : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		distributions = [Distribution]()
		if let distributionsArray = dictionary["Distributions"] as? [[String:Any]]{
			for dic in distributionsArray{
				let value = Distribution(fromDictionary: dic)
				distributions.append(value)
			}
		}
		errorCode = dictionary["ErrorCode"] as? String
		exceptionMessage = dictionary["ExceptionMessage"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if distributions != nil{
			var dictionaryElements = [[String:Any]]()
			for distributionsElement in distributions {
				dictionaryElements.append(distributionsElement.toDictionary())
			}
			dictionary["Distributions"] = dictionaryElements
		}
		if errorCode != nil{
			dictionary["ErrorCode"] = errorCode
		}
		if exceptionMessage != nil{
			dictionary["ExceptionMessage"] = exceptionMessage
		}
		return dictionary
	}

}
