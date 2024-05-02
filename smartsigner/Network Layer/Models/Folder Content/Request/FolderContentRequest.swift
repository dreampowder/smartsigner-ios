//
//	FolderContentRequest.swift
//
//	Create by Serdar Coşkun on 23/9/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct FolderContentRequest{

	var clientIPAddress : String!
	var clientTypeName : String!
	var delegations : [AnyObject]!
	var folderId : Int!
	var page : Int!
	var pageSize : Int!
	var poolTypeEnumFilterString : String!
	var rightTransfers : [AnyObject]!
	var sessionId : Int!
	var userId : Int!
	var userName : String!
	var userSurname : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		clientIPAddress = dictionary["ClientIPAddress"] as? String
		clientTypeName = dictionary["ClientTypeName"] as? String
		delegations = dictionary["Delegations"] as? [AnyObject]
		folderId = dictionary["FolderId"] as? Int
		page = dictionary["Page"] as? Int
		pageSize = dictionary["PageSize"] as? Int
		poolTypeEnumFilterString = dictionary["PoolTypeEnumFilterString"] as? String
		rightTransfers = dictionary["RightTransfers"] as? [AnyObject]
		sessionId = dictionary["SessionId"] as? Int
		userId = dictionary["UserId"] as? Int
		userName = dictionary["UserName"] as? String
		userSurname = dictionary["UserSurname"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if clientIPAddress != nil{
			dictionary["ClientIPAddress"] = clientIPAddress
		}
		if clientTypeName != nil{
			dictionary["ClientTypeName"] = clientTypeName
		}
		if delegations != nil{
			dictionary["Delegations"] = delegations
		}
		if folderId != nil{
			dictionary["FolderId"] = folderId
		}
		if page != nil{
			dictionary["Page"] = page
		}
		if pageSize != nil{
			dictionary["PageSize"] = pageSize
		}
		if poolTypeEnumFilterString != nil{
			dictionary["PoolTypeEnumFilterString"] = poolTypeEnumFilterString
		}
		if rightTransfers != nil{
			dictionary["RightTransfers"] = rightTransfers
		}
		if sessionId != nil{
			dictionary["SessionId"] = sessionId
		}
		if userId != nil{
			dictionary["UserId"] = userId
		}
		if userName != nil{
			dictionary["UserName"] = userName
		}
		if userSurname != nil{
			dictionary["UserSurname"] = userSurname
		}
		return dictionary
	}

}
