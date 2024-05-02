//
//	WorkFlowActionResponse.swift
//
//	Create by Serdar Coşkun on 22/1/2019
//	Copyright © 2019 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct WorkFlowActionResponse:JsonProtocol{
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return WorkFlowActionResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.exceptionMessage, exceptionCode: self.errorCode)
    }

	var doClientAction : Bool!
	var errorCode : String!
	var exceptionMessage : String!
	var folderId : Int!
	var folders : [Folder]!
	var message : String!
	var poolId : Int!
	var refreshFolders : Bool!
	var selectAction : Bool!
	var workflowActionId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		doClientAction = dictionary["DoClientAction"] as? Bool
		errorCode = dictionary["ErrorCode"] as? String
		exceptionMessage = dictionary["ExceptionMessage"] as? String
		folderId = dictionary["FolderId"] as? Int
        folders = [Folder]()
        if let foldersArray = dictionary["Folders"] as? [[String:Any]]{
            for dic in foldersArray{
                let value = Folder(fromDictionary: dic)
                folders.append(value)
            }
        }
		message = dictionary["Message"] as? String
		poolId = dictionary["PoolId"] as? Int
		refreshFolders = dictionary["RefreshFolders"] as? Bool
		selectAction = dictionary["SelectAction"] as? Bool
		workflowActionId = dictionary["WorkflowActionId"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if doClientAction != nil{
			dictionary["DoClientAction"] = doClientAction
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
		if folders != nil{
			dictionary["Folders"] = folders
		}
		if message != nil{
			dictionary["Message"] = message
		}
		if poolId != nil{
			dictionary["PoolId"] = poolId
		}
		if refreshFolders != nil{
			dictionary["RefreshFolders"] = refreshFolders
		}
		if selectAction != nil{
			dictionary["SelectAction"] = selectAction
		}
		if workflowActionId != nil{
			dictionary["WorkflowActionId"] = workflowActionId
		}
		return dictionary
	}

}
