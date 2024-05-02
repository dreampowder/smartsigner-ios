//
//	FolderContentResponse.swift
//
//	Create by Serdar Coşkun on 23/9/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct FolderContentResponse:JsonProtocol{
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.exceptionMessage, exceptionCode: self.errorCode)
    }
    
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return FolderContentResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }

	var poolItems : [PoolItem]!
	var errorCode : String!
	var exceptionMessage : String!
	var total : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		poolItems = [PoolItem]()
		if let documentItemArray = dictionary["Result"] as? [[String:Any]]{
            for dic in documentItemArray{
                let value = PoolItem(fromDictionary: dic)
                poolItems.append(value)
            }
        }else if let documentItemArray = dictionary["Pools"] as? [[String:Any]]{
            for dic in documentItemArray{
                let value = PoolItem(fromDictionary: dic)
                poolItems.append(value)
            }
        }
        errorCode = dictionary["ErrorCode"] as? String
        exceptionMessage = dictionary["ExceptionMessage"] as? String
		total = dictionary["Total"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if poolItems != nil{
			var dictionaryElements = [[String:Any]]()
			for documentItemElement in poolItems {
				dictionaryElements.append(documentItemElement.toDictionary())
			}
			dictionary["Result"] = dictionaryElements
		}
		if errorCode != nil{
			dictionary["ErrorCode"] = errorCode
		}
		if exceptionMessage != nil{
			dictionary["ExceptionMessage"] = exceptionMessage
		}
		if total != nil{
			dictionary["Total"] = total
		}
		return dictionary
	}

}
