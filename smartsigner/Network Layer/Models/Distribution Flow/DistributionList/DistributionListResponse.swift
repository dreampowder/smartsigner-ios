//
//    DistributionListResponse.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DistributionListResponse:JsonProtocol{
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return DistributionListResponse.init(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: exceptionMessage, exceptionCode: errorCode)
    }
    
    

    var daDistributions : [DaDistribution]!
    var errorCode : String!
    var exceptionMessage : String!


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
        errorCode = dictionary["ErrorCode"] as? String
        exceptionMessage = dictionary["ExceptionMessage"] as? String
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
        if errorCode != nil{
            dictionary["ErrorCode"] = errorCode
        }
        if exceptionMessage != nil{
            dictionary["ExceptionMessage"] = exceptionMessage
        }
        return dictionary
    }

}
