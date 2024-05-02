//
//	SearchRequest.swift
//
//	Create by Serdar Coşkun on 1/10/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct SearchRequest{

	var barcodeNo : String!
	var clientIPAddress : String!
	var clientTypeName : String!
	var documentNo : String!
	var dontListDraftDocuments : Bool!
	var endDate : String!
	var isSearchFromArchive : Bool!
	var page : Int!
	var pageSize : Int!
	var searchAllDocumentsIsChecked : Bool!
	var sessionId : Int!
	var startDate : String!
	var subject : String!
	var userId : Int!
	var userName : String!
	var userSurname : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		barcodeNo = dictionary["BarcodeNo"] as? String
		clientIPAddress = dictionary["ClientIPAddress"] as? String
		clientTypeName = dictionary["ClientTypeName"] as? String
		documentNo = dictionary["DocumentNo"] as? String
		dontListDraftDocuments = dictionary["DontListDraftDocuments"] as? Bool
		endDate = dictionary["EndDate"] as? String
		isSearchFromArchive = dictionary["IsSearchFromArchive"] as? Bool
		page = dictionary["Page"] as? Int
		pageSize = dictionary["PageSize"] as? Int
		searchAllDocumentsIsChecked = dictionary["SearchAllDocumentsIsChecked"] as? Bool
		sessionId = dictionary["SessionId"] as? Int
		startDate = dictionary["StartDate"] as? String
		subject = dictionary["Subject"] as? String
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
		if barcodeNo != nil{
			dictionary["BarcodeNo"] = barcodeNo
		}
		if clientIPAddress != nil{
			dictionary["ClientIPAddress"] = clientIPAddress
		}
		if clientTypeName != nil{
			dictionary["ClientTypeName"] = clientTypeName
		}
		if documentNo != nil{
			dictionary["DocumentNo"] = documentNo
		}
		if dontListDraftDocuments != nil{
			dictionary["DontListDraftDocuments"] = dontListDraftDocuments
		}
		if endDate != nil{
			dictionary["EndDate"] = endDate
		}
		if isSearchFromArchive != nil{
			dictionary["IsSearchFromArchive"] = isSearchFromArchive
		}
		if page != nil{
			dictionary["Page"] = page
		}
		if pageSize != nil{
			dictionary["PageSize"] = pageSize
		}
		if searchAllDocumentsIsChecked != nil{
			dictionary["SearchAllDocumentsIsChecked"] = searchAllDocumentsIsChecked
		}
		if sessionId != nil{
			dictionary["SessionId"] = sessionId
		}
		if startDate != nil{
			dictionary["StartDate"] = startDate
		}
		if subject != nil{
			dictionary["Subject"] = subject
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