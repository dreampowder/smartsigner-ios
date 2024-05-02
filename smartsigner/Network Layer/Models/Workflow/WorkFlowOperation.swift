//
//	WorkFlowOperation.swift
//
//	Create by Serdar Coşkun on 21/1/2019
//	Copyright © 2019 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct WorkFlowOperation{

	var flowActionOperationTypeEnum : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		flowActionOperationTypeEnum = dictionary["FlowActionOperationTypeEnum"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if flowActionOperationTypeEnum != nil{
			dictionary["FlowActionOperationTypeEnum"] = flowActionOperationTypeEnum
		}
		return dictionary
	}

}