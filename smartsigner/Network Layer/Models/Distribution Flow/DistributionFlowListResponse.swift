//
//	DistributionFlowListResponse.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DistributionFlowListResponse: JsonProtocol{
    
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return DistributionFlowListResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: exceptionMessage, exceptionCode: errorCode)
    }
    

	var daFlows : [DistributionFlowDaFlow]!
	var errorCode : String!
	var exceptionMessage : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		daFlows = [DistributionFlowDaFlow]()
		if let daFlowsArray = dictionary["DaFlows"] as? [[String:Any]]{
			for dic in daFlowsArray{
				let value = DistributionFlowDaFlow(fromDictionary: dic)
				daFlows.append(value)
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
		if daFlows != nil{
			var dictionaryElements = [[String:Any]]()
			for daFlowsElement in daFlows {
				dictionaryElements.append(daFlowsElement.toDictionary())
			}
			dictionary["DaFlows"] = dictionaryElements
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
