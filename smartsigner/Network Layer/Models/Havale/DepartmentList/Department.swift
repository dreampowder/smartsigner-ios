//
//	Department.swift
//
//	Create by Serdar Coşkun on 23/11/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Department{

	var code : String!
	var colorIndicator : String!
	var departmentType : String!
	var id : Int!
	var isActive : Bool!
	var kKK : String!
	var managerUserId : Int!
	var name : String!
	var parent1DepartmentId : Int!
	var parent1DepartmentName : String!
	var parent2DepartmentId : Int!
	var parent2DepartmentName : String!
	var parent3DepartmentId : Int!
	var parent3DepartmentName : String!
	var parent4DepartmentId : Int!
	var parent4DepartmentName : String!
	var parentDepartmentId : Int!
	var titleOne : String!
    var administrativeDepartmentId: Int!
    var administrativeDepartmentName: String!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		code = dictionary["Code"] as? String
		colorIndicator = dictionary["ColorIndicator"] as? String
		departmentType = dictionary["DepartmentType"] as? String
		id = dictionary["Id"] as? Int
		isActive = dictionary["IsActive"] as? Bool
		kKK = dictionary["KKK"] as? String
		managerUserId = dictionary["ManagerUserId"] as? Int
		name = dictionary["Name"] as? String
		parent1DepartmentId = dictionary["Parent1DepartmentId"] as? Int
		parent1DepartmentName = dictionary["Parent1DepartmentName"] as? String
		parent2DepartmentId = dictionary["Parent2DepartmentId"] as? Int
		parent2DepartmentName = dictionary["Parent2DepartmentName"] as? String
		parent3DepartmentId = dictionary["Parent3DepartmentId"] as? Int
		parent3DepartmentName = dictionary["Parent3DepartmentName"] as? String
		parent4DepartmentId = dictionary["Parent4DepartmentId"] as? Int
		parent4DepartmentName = dictionary["Parent4DepartmentName"] as? String
		parentDepartmentId = dictionary["ParentDepartmentId"] as? Int
		titleOne = dictionary["TitleOne"] as? String
        administrativeDepartmentId = dictionary["AdministrativeDepartmentId"] as? Int
        administrativeDepartmentName = dictionary["AdministrativeDepartmentName"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if code != nil{
			dictionary["Code"] = code
		}
		if colorIndicator != nil{
			dictionary["ColorIndicator"] = colorIndicator
		}
		if departmentType != nil{
			dictionary["DepartmentType"] = departmentType
		}
		if id != nil{
			dictionary["Id"] = id
		}
		if isActive != nil{
			dictionary["IsActive"] = isActive
		}
		if kKK != nil{
			dictionary["KKK"] = kKK
		}
		if managerUserId != nil{
			dictionary["ManagerUserId"] = managerUserId
		}
		if name != nil{
			dictionary["Name"] = name
		}
		if parent1DepartmentId != nil{
			dictionary["Parent1DepartmentId"] = parent1DepartmentId
		}
		if parent1DepartmentName != nil{
			dictionary["Parent1DepartmentName"] = parent1DepartmentName
		}
		if parent2DepartmentId != nil{
			dictionary["Parent2DepartmentId"] = parent2DepartmentId
		}
		if parent2DepartmentName != nil{
			dictionary["Parent2DepartmentName"] = parent2DepartmentName
		}
		if parent3DepartmentId != nil{
			dictionary["Parent3DepartmentId"] = parent3DepartmentId
		}
		if parent3DepartmentName != nil{
			dictionary["Parent3DepartmentName"] = parent3DepartmentName
		}
		if parent4DepartmentId != nil{
			dictionary["Parent4DepartmentId"] = parent4DepartmentId
		}
		if parent4DepartmentName != nil{
			dictionary["Parent4DepartmentName"] = parent4DepartmentName
		}
		if parentDepartmentId != nil{
			dictionary["ParentDepartmentId"] = parentDepartmentId
		}
		if titleOne != nil{
			dictionary["TitleOne"] = titleOne
		}
        if administrativeDepartmentName != nil {
            dictionary["AdministrativeDepartmentName"] = administrativeDepartmentName
        }
        if administrativeDepartmentId != nil{
            dictionary["AdministrativeDepartmentId"] = administrativeDepartmentId
        }
		return dictionary
	}

}
