//
//	WorkFlowSignPackageStartResponse.swift
//
//	Create by Serdar Coşkun on 22/1/2019
//	Copyright © 2019 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct WorkFlowSignPackageStartResponse:JsonProtocol{
    
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return WorkFlowSignPackageStartResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.exceptionMessage, exceptionCode: self.errorCode)
    }
    

    
    
	var dataAsBase64 : String!
	var errorCode : String!
	var exceptionMessage : String!
	var itIsSecondOrNextSignature : Bool!
	var poolId : Int!
	var workflowActionId : Int!
	var workflowInstanceId : Int!
    var operationGuid: String!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		dataAsBase64 = dictionary["DataAsBase64"] as? String
		errorCode = dictionary["ErrorCode"] as? String
		exceptionMessage = dictionary["ExceptionMessage"] as? String
		itIsSecondOrNextSignature = dictionary["ItIsSecondOrNextSignature"] as? Bool
		poolId = dictionary["PoolId"] as? Int
		workflowActionId = dictionary["WorkflowActionId"] as? Int
		workflowInstanceId = dictionary["WorkflowInstanceId"] as? Int
        operationGuid = dictionary["OperationGuid"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if dataAsBase64 != nil{
			dictionary["DataAsBase64"] = dataAsBase64
		}
		if errorCode != nil{
			dictionary["ErrorCode"] = errorCode
		}
		if exceptionMessage != nil{
			dictionary["ExceptionMessage"] = exceptionMessage
		}
		if itIsSecondOrNextSignature != nil{
			dictionary["ItIsSecondOrNextSignature"] = itIsSecondOrNextSignature
		}
		if poolId != nil{
			dictionary["PoolId"] = poolId
		}
		if workflowActionId != nil{
			dictionary["WorkflowActionId"] = workflowActionId
		}
		if workflowInstanceId != nil{
			dictionary["WorkflowInstanceId"] = workflowInstanceId
		}
        if operationGuid != nil{
            dictionary["OperationGuid"] = operationGuid
        }
		return dictionary
	}

}
