//
//	ListDelegateResponse.swift
//
//	Create by Serdar Coşkun on 30/10/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ListDelegateResponse:JsonProtocol{
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.exceptionMessage, exceptionCode: self.errorCode)
    }

    static func parseJson(dictionary: [String : Any]) -> Any? {
        return ListDelegateResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    

    
    
	var errorCode : String!
	var exceptionMessage : String!
	var isSuccess : Bool!
	var delegationItems : [DelegationItem]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		errorCode = dictionary["ErrorCode"] as? String
		exceptionMessage = dictionary["ExceptionMessage"] as? String
		isSuccess = dictionary["IsSuccess"] as? Bool
		delegationItems = [DelegationItem]()
		if let delegationItemsArray = dictionary["delegationItemList"] as? [[String:Any]]{
			for dic in delegationItemsArray{
				let value = DelegationItem(fromDictionary: dic)
				delegationItems.append(value)
			}
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if errorCode != nil{
			dictionary["ErrorCode"] = errorCode
		}
		if exceptionMessage != nil{
			dictionary["ExceptionMessage"] = exceptionMessage
		}
		if isSuccess != nil{
			dictionary["IsSuccess"] = isSuccess
		}
		if delegationItems != nil{
			var dictionaryElements = [[String:Any]]()
			for delegationItemsElement in delegationItems {
				dictionaryElements.append(delegationItemsElement.toDictionary())
			}
			dictionary["delegationItemList"] = dictionaryElements
		}
		return dictionary
	}

}
