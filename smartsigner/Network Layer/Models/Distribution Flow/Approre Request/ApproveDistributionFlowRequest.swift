//
//  ApproveDistributionFlowRequest.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 12.02.2020.
//  Copyright © 2020 Seneka. All rights reserved.
//

import UIKit

struct ApproveDistributionFlowRequest {
    var chkDontShowMessageOnSuccess : Bool!
    var chkDontShowNote : Bool!
    var daFlows : [DistributionFlowDaFlow]!
    var distributionNote : String!
    var flowNote : String!
    var lastEditDate : String!
    var poolId : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        chkDontShowMessageOnSuccess = dictionary["ChkDontShowMessageOnSuccess"] as? Bool
        chkDontShowNote = dictionary["ChkDontShowNote"] as? Bool
        daFlows = [DistributionFlowDaFlow]()
        if let daFlowsArray = dictionary["DaFlows"] as? [[String:Any]]{
            for dic in daFlowsArray{
                let value = DistributionFlowDaFlow(fromDictionary: dic)
                daFlows.append(value)
            }
        }
        distributionNote = dictionary["DistributionNote"] as? String
        flowNote = dictionary["FlowNote"] as? String
        lastEditDate = dictionary["LastEditDate"] as? String
        poolId = dictionary["PoolId"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if chkDontShowMessageOnSuccess != nil{
            dictionary["ChkDontShowMessageOnSuccess"] = chkDontShowMessageOnSuccess
        }
        if chkDontShowNote != nil{
            dictionary["ChkDontShowNote"] = chkDontShowNote
        }
        if daFlows != nil{
            var dictionaryElements = [[String:Any]]()
            for daFlowsElement in daFlows {
                dictionaryElements.append(daFlowsElement.toDictionary())
            }
            dictionary["DaFlows"] = dictionaryElements
        }
        if distributionNote != nil{
            dictionary["DistributionNote"] = distributionNote
        }
        if flowNote != nil{
            dictionary["FlowNote"] = flowNote
        }
        if lastEditDate != nil{
            dictionary["LastEditDate"] = lastEditDate
        }
        if poolId != nil{
            dictionary["PoolId"] = poolId
        }
        return dictionary
    }

}
