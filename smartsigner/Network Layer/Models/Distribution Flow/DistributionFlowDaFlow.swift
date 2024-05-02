//
//	DistributionFlowDaFlow.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DistributionFlowDaFlow{
    var daDistributions : [DaDistribution]!
    var daFlowStateEnum : Int!
    var departmentId : Int!
    var departmentName : String!
    var documentId : Int!
    var flowSetId : String!
    var id : Int!
    var notes : String!
    var operationDate : String!
    var operatorPassiveUserId : Int!
    var operatorUserId : Int!
    var orderNo : Int!
    var userId : Int!
    var userName : String!
    var userSurname : String!
    var operatorUserName: String!
    var operatorUserSurname: String!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        daDistributions = [DaDistribution]()
        if let daDistributionsArray = dictionary["DaDistributions"] as? [[String:Any]]{
            for dic in daDistributionsArray{
                let value = DaDistribution(fromDictionary: dic)
                daDistributions.append(value)
            }
        }
        daFlowStateEnum = dictionary["DaFlowStateEnum"] as? Int
        departmentId = dictionary["DepartmentId"] as? Int
        departmentName = dictionary["DepartmentName"] as? String
        documentId = dictionary["DocumentId"] as? Int
        flowSetId = dictionary["FlowSetId"] as? String
        id = dictionary["Id"] as? Int
        notes = dictionary["Notes"] as? String
        operationDate = dictionary["OperationDate"] as? String
        operatorPassiveUserId = dictionary["OperatorPassiveUserId"] as? Int
        operatorUserId = dictionary["OperatorUserId"] as? Int
        orderNo = dictionary["OrderNo"] as? Int
        userId = dictionary["UserId"] as? Int
        userName = dictionary["UserName"] as? String
        userSurname = dictionary["UserSurname"] as? String
        operatorUserName = dictionary["OperatorUserName"] as? String
        operatorUserSurname = dictionary["OperatorUserSurname"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if daDistributions != nil{
            var dictionaryElements = [[String:Any]]()
            for daDistributionsElement in daDistributions {
                dictionaryElements.append(daDistributionsElement.toDictionary())
            }
            dictionary["DaDistributions"] = dictionaryElements
        }
        if daFlowStateEnum != nil{
            dictionary["DaFlowStateEnum"] = daFlowStateEnum
        }
        if departmentId != nil{
            dictionary["DepartmentId"] = departmentId
        }
        if departmentName != nil{
            dictionary["DepartmentName"] = departmentName
        }
        if documentId != nil{
            dictionary["DocumentId"] = documentId
        }
        if flowSetId != nil{
            dictionary["FlowSetId"] = flowSetId
        }
        if id != nil{
            dictionary["Id"] = id
        }
        if notes != nil{
            dictionary["Notes"] = notes
        }
        if operationDate != nil{
            dictionary["OperationDate"] = operationDate
        }
        if operatorPassiveUserId != nil{
            dictionary["OperatorPassiveUserId"] = operatorPassiveUserId
        }
        if operatorUserId != nil{
            dictionary["OperatorUserId"] = operatorUserId
        }
        if orderNo != nil{
            dictionary["OrderNo"] = orderNo
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
        if operatorUserName != nil{
            dictionary["operatorUserSurname"] = operatorUserName
        }
        if operatorUserSurname != nil {
            dictionary["OperatorUserSurname"] = operatorUserSurname;
        }
        return dictionary
    }

}
