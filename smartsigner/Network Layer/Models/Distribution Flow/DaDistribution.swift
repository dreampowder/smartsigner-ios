//
//    DaDistribution.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DaDistribution{

    var daFlowId : Int!
    var documentDistributionDirectionEnum : Int!
    var documentDistributionTypeEnum : Int!
    var documentDistributionUrgencyTypeEnum : Int!
    var documentId : Int!
    var groupDetails : AnyObject!
    var id : Int!
    var orderNumber : Int!
    var otherData : AnyObject!
    var targetDepartmentGroupId : Int!
    var targetDepartmentId : Int!
    var targetDepartmentName : String!
    var targetUserGroupId : Int!
    var targetUserId : Int!
    var targetUserName : String!
    var targetUserSurname : String!
    var isAddedByUser:Bool = false

    func getActualTitle() -> String{
        if targetDepartmentId != nil{
           return  targetDepartmentName
        }else if targetUserId != nil{
            return  "\(targetUserName ?? "") \(targetUserSurname ?? "")"
        }else{
            return ""
        }
    }

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        daFlowId = dictionary["DaFlowId"] as? Int
        documentDistributionDirectionEnum = dictionary["DocumentDistributionDirectionEnum"] as? Int
        documentDistributionTypeEnum = dictionary["DocumentDistributionTypeEnum"] as? Int
        documentDistributionUrgencyTypeEnum = dictionary["DocumentDistributionUrgencyTypeEnum"] as? Int
        documentId = dictionary["DocumentId"] as? Int
        groupDetails = dictionary["GroupDetails"] as? AnyObject
        id = dictionary["Id"] as? Int
        orderNumber = dictionary["OrderNumber"] as? Int
        otherData = dictionary["OtherData"] as? AnyObject
        targetDepartmentGroupId = dictionary["TargetDepartmentGroupId"] as? Int
        targetDepartmentId = dictionary["TargetDepartmentId"] as? Int
        targetDepartmentName = dictionary["TargetDepartmentName"] as? String
        targetUserGroupId = dictionary["TargetUserGroupId"] as? Int
        targetUserId = dictionary["TargetUserId"] as? Int
        targetUserName = dictionary["TargetUserName"] as? String
        targetUserSurname = dictionary["TargetUserSurname"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if daFlowId != nil{
            dictionary["DaFlowId"] = daFlowId
        }
        if documentDistributionDirectionEnum != nil{
            dictionary["DocumentDistributionDirectionEnum"] = documentDistributionDirectionEnum
        }
        if documentDistributionTypeEnum != nil{
            dictionary["DocumentDistributionTypeEnum"] = documentDistributionTypeEnum
        }
        if documentDistributionUrgencyTypeEnum != nil{
            dictionary["DocumentDistributionUrgencyTypeEnum"] = documentDistributionUrgencyTypeEnum
        }
        if documentId != nil{
            dictionary["DocumentId"] = documentId
        }
        if groupDetails != nil{
            dictionary["GroupDetails"] = groupDetails
        }
        if id != nil{
            dictionary["Id"] = id
        }
        if orderNumber != nil{
            dictionary["OrderNumber"] = orderNumber
        }
        if otherData != nil{
            dictionary["OtherData"] = otherData
        }
        if targetDepartmentGroupId != nil{
            dictionary["TargetDepartmentGroupId"] = targetDepartmentGroupId
        }
        if targetDepartmentId != nil{
            dictionary["TargetDepartmentId"] = targetDepartmentId
        }
        if targetDepartmentName != nil{
            dictionary["TargetDepartmentName"] = targetDepartmentName
        }
        if targetUserGroupId != nil{
            dictionary["TargetUserGroupId"] = targetUserGroupId
        }
        if targetUserId != nil{
            dictionary["TargetUserId"] = targetUserId
        }
        if targetUserName != nil{
            dictionary["TargetUserName"] = targetUserName
        }
        if targetUserSurname != nil{
            dictionary["TargetUserSurname"] = targetUserSurname
        }
        return dictionary
    }

}
