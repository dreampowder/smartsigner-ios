//
//    PrepareForForwardResponse.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct PrepareForForwardResponse:JsonProtocol{

    static func parseJson(dictionary: [String : Any]) -> Any? {
        return PrepareForForwardResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: exceptionMessage, exceptionCode: errorCode)
    }
    
    
    var errorCode : String!
    var exceptionMessage : String!
    var giveRightAutomatically : Bool!
    var promptMessage : String!
    var showPrompt : Bool!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        errorCode = dictionary["ErrorCode"] as? String
        exceptionMessage = dictionary["ExceptionMessage"] as? String
        giveRightAutomatically = dictionary["GiveRightAutomatically"] as? Bool
        promptMessage = dictionary["PromptMessage"] as? String
        showPrompt = dictionary["ShowPrompt"] as? Bool
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if errorCode != nil{
            dictionary["ErrorCode"] = errorCode
        }
        if exceptionMessage != nil{
            dictionary["ExceptionMessage"] = exceptionMessage
        }
        if giveRightAutomatically != nil{
            dictionary["GiveRightAutomatically"] = giveRightAutomatically
        }
        if promptMessage != nil{
            dictionary["PromptMessage"] = promptMessage
        }
        if showPrompt != nil{
            dictionary["ShowPrompt"] = showPrompt
        }
        return dictionary
    }

}
