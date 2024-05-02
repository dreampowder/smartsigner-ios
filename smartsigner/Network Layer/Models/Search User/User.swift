//
//	User.swift
//
//	Create by Serdar Coşkun on 18/10/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct User{

	var citizenshipNo : AnyObject!
	var departmentId : Int!
	var departmentName : String!
	var domainUserName : AnyObject!
	var email : AnyObject!
	var id : Int!
	var name : String!
	var phone : AnyObject!
	var surname : String!
	var title : String!
	var userAuthenticationTypeEnum : Int!
	var userAuthenticationTypeEnumAsString : AnyObject!
	var userName : String!
	var userSignature : String!
	var userStatusEnum : Int!
	var userStatusEnumAsString : AnyObject!
	var userStatusEnumToString : String!
	var userTitle : AnyObject!
	var userTitleId : Int!
	var userTypeEnum : Int!
	var userTypeEnumAsString : AnyObject!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		citizenshipNo = dictionary["CitizenshipNo"] as? AnyObject
		departmentId = dictionary["DepartmentId"] as? Int
		departmentName = dictionary["DepartmentName"] as? String
		domainUserName = dictionary["DomainUserName"] as? AnyObject
		email = dictionary["Email"] as? AnyObject
		id = dictionary["Id"] as? Int
		name = dictionary["Name"] as? String
		phone = dictionary["Phone"] as? AnyObject
		surname = dictionary["Surname"] as? String
		title = dictionary["Title"] as? String
		userAuthenticationTypeEnum = dictionary["UserAuthenticationTypeEnum"] as? Int
		userAuthenticationTypeEnumAsString = dictionary["UserAuthenticationTypeEnumAsString"] as? AnyObject
		userName = dictionary["UserName"] as? String
		userSignature = dictionary["UserSignature"] as? String
		userStatusEnum = dictionary["UserStatusEnum"] as? Int
		userStatusEnumAsString = dictionary["UserStatusEnumAsString"] as? AnyObject
		userStatusEnumToString = dictionary["UserStatusEnumToString"] as? String
		userTitle = dictionary["UserTitle"] as? AnyObject
		userTitleId = dictionary["UserTitleId"] as? Int
		userTypeEnum = dictionary["UserTypeEnum"] as? Int
		userTypeEnumAsString = dictionary["UserTypeEnumAsString"] as? AnyObject
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if citizenshipNo != nil{
			dictionary["CitizenshipNo"] = citizenshipNo
		}
		if departmentId != nil{
			dictionary["DepartmentId"] = departmentId
		}
		if departmentName != nil{
			dictionary["DepartmentName"] = departmentName
		}
		if domainUserName != nil{
			dictionary["DomainUserName"] = domainUserName
		}
		if email != nil{
			dictionary["Email"] = email
		}
		if id != nil{
			dictionary["Id"] = id
		}
		if name != nil{
			dictionary["Name"] = name
		}
		if phone != nil{
			dictionary["Phone"] = phone
		}
		if surname != nil{
			dictionary["Surname"] = surname
		}
		if title != nil{
			dictionary["Title"] = title
		}
		if userAuthenticationTypeEnum != nil{
			dictionary["UserAuthenticationTypeEnum"] = userAuthenticationTypeEnum
		}
		if userAuthenticationTypeEnumAsString != nil{
			dictionary["UserAuthenticationTypeEnumAsString"] = userAuthenticationTypeEnumAsString
		}
		if userName != nil{
			dictionary["UserName"] = userName
		}
		if userSignature != nil{
			dictionary["UserSignature"] = userSignature
		}
		if userStatusEnum != nil{
			dictionary["UserStatusEnum"] = userStatusEnum
		}
		if userStatusEnumAsString != nil{
			dictionary["UserStatusEnumAsString"] = userStatusEnumAsString
		}
		if userStatusEnumToString != nil{
			dictionary["UserStatusEnumToString"] = userStatusEnumToString
		}
		if userTitle != nil{
			dictionary["UserTitle"] = userTitle
		}
		if userTitleId != nil{
			dictionary["UserTitleId"] = userTitleId
		}
		if userTypeEnum != nil{
			dictionary["UserTypeEnum"] = userTypeEnum
		}
		if userTypeEnumAsString != nil{
			dictionary["UserTypeEnumAsString"] = userTypeEnumAsString
		}
		return dictionary
	}

}