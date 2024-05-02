//
//	DelegationTypeEnumsForCheckBox.swift
//
//	Create by Serdar Coşkun on 30/10/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DelegationTypeEnumsForCheckBox{

	var chkAsilUserCanOperateInReadOnlyMode : Bool!
	var chkDontSeeOlderReceivedItems : Bool!
	var chkDontSeeOlderReceivedItemsForDepartment : Bool!
	var chkDontSeeOlderSentItems : Bool!
	var chkDontSeeOlderSentItemsForDepartment : Bool!
	var chkShowDocumentNotes : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		chkAsilUserCanOperateInReadOnlyMode = dictionary["ChkAsilUserCanOperateInReadOnlyMode"] as? Bool
		chkDontSeeOlderReceivedItems = dictionary["ChkDontSeeOlderReceivedItems"] as? Bool
		chkDontSeeOlderReceivedItemsForDepartment = dictionary["ChkDontSeeOlderReceivedItemsForDepartment"] as? Bool
		chkDontSeeOlderSentItems = dictionary["ChkDontSeeOlderSentItems"] as? Bool
		chkDontSeeOlderSentItemsForDepartment = dictionary["ChkDontSeeOlderSentItemsForDepartment"] as? Bool
		chkShowDocumentNotes = dictionary["ChkShowDocumentNotes"] as? Bool
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if chkAsilUserCanOperateInReadOnlyMode != nil{
			dictionary["ChkAsilUserCanOperateInReadOnlyMode"] = chkAsilUserCanOperateInReadOnlyMode
		}
		if chkDontSeeOlderReceivedItems != nil{
			dictionary["ChkDontSeeOlderReceivedItems"] = chkDontSeeOlderReceivedItems
		}
		if chkDontSeeOlderReceivedItemsForDepartment != nil{
			dictionary["ChkDontSeeOlderReceivedItemsForDepartment"] = chkDontSeeOlderReceivedItemsForDepartment
		}
		if chkDontSeeOlderSentItems != nil{
			dictionary["ChkDontSeeOlderSentItems"] = chkDontSeeOlderSentItems
		}
		if chkDontSeeOlderSentItemsForDepartment != nil{
			dictionary["ChkDontSeeOlderSentItemsForDepartment"] = chkDontSeeOlderSentItemsForDepartment
		}
		if chkShowDocumentNotes != nil{
			dictionary["ChkShowDocumentNotes"] = chkShowDocumentNotes
		}
		return dictionary
	}

}