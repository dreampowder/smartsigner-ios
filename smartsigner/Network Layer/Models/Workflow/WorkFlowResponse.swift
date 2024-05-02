//
//	WorkFlowResponse.swift
//
//	Create by Serdar Coşkun on 21/1/2019
//	Copyright © 2019 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct WorkFlowResponse:JsonProtocol{
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return WorkFlowResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.exceptionMessage, exceptionCode: self.errorCode)
    }
    
    
    

	var descriptionText : String!
	var errorCode : String!
	var exceptionMessage : String!
	var folderId : Int!
	var isPullbackVisible : Bool!
	var poolId : Int!
	var possibleWfOperations : [WorkFlowPossibleWfOperation]!
	var workflowInstanceId : Int!
	var workflowStepInstanceId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		descriptionText = dictionary["DescriptionText"] as? String
		errorCode = dictionary["ErrorCode"] as? String
		exceptionMessage = dictionary["ExceptionMessage"] as? String
		folderId = dictionary["FolderId"] as? Int
		isPullbackVisible = dictionary["IsPullbackVisible"] as? Bool
		poolId = dictionary["PoolId"] as? Int
		possibleWfOperations = [WorkFlowPossibleWfOperation]()
		if let possibleWfOperationsArray = dictionary["PossibleWfOperations"] as? [[String:Any]]{
			for dic in possibleWfOperationsArray{
				let value = WorkFlowPossibleWfOperation(fromDictionary: dic)
				possibleWfOperations.append(value)
			}
		}
		workflowInstanceId = dictionary["WorkflowInstanceId"] as? Int
		workflowStepInstanceId = dictionary["WorkflowStepInstanceId"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if descriptionText != nil{
			dictionary["DescriptionText"] = descriptionText
		}
		if errorCode != nil{
			dictionary["ErrorCode"] = errorCode
		}
		if exceptionMessage != nil{
			dictionary["ExceptionMessage"] = exceptionMessage
		}
		if folderId != nil{
			dictionary["FolderId"] = folderId
		}
		if isPullbackVisible != nil{
			dictionary["IsPullbackVisible"] = isPullbackVisible
		}
		if poolId != nil{
			dictionary["PoolId"] = poolId
		}
		if possibleWfOperations != nil{
			var dictionaryElements = [[String:Any]]()
			for possibleWfOperationsElement in possibleWfOperations {
				dictionaryElements.append(possibleWfOperationsElement.toDictionary())
			}
			dictionary["PossibleWfOperations"] = dictionaryElements
		}
		if workflowInstanceId != nil{
			dictionary["WorkflowInstanceId"] = workflowInstanceId
		}
		if workflowStepInstanceId != nil{
			dictionary["WorkflowStepInstanceId"] = workflowStepInstanceId
		}
		return dictionary
	}

}
