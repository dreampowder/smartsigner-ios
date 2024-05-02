//
//	WorkFlowClientActionResponse.swift
//
//	Create by Serdar Coşkun on 22/1/2019
//	Copyright © 2019 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct WorkFlowClientActionResponse:JsonProtocol{
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return WorkFlowClientActionResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.exceptionMessage, exceptionCode: self.errorCode)
    }
    

	var actionName : String!
	var errorCode : String!
	var exceptionMessage : String!
	var parameters : [WorkFlowClientActionParameter]!
	var poolId : Int!
	var workflowActionId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		actionName = dictionary["ActionName"] as? String
		errorCode = dictionary["ErrorCode"] as? String
		exceptionMessage = dictionary["ExceptionMessage"] as? String
		parameters = [WorkFlowClientActionParameter]()
		if let parametersArray = dictionary["Parameters"] as? [[String:Any]]{
			for dic in parametersArray{
				let value = WorkFlowClientActionParameter(fromDictionary: dic)
				parameters.append(value)
			}
		}
		poolId = dictionary["PoolId"] as? Int
		workflowActionId = dictionary["WorkflowActionId"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if actionName != nil{
			dictionary["ActionName"] = actionName
		}
		if errorCode != nil{
			dictionary["ErrorCode"] = errorCode
		}
		if exceptionMessage != nil{
			dictionary["ExceptionMessage"] = exceptionMessage
		}
		if parameters != nil{
			var dictionaryElements = [[String:Any]]()
			for parametersElement in parameters {
				dictionaryElements.append(parametersElement.toDictionary())
			}
			dictionary["Parameters"] = dictionaryElements
		}
		if poolId != nil{
			dictionary["PoolId"] = poolId
		}
		if workflowActionId != nil{
			dictionary["WorkflowActionId"] = workflowActionId
		}
		return dictionary
	}

}
