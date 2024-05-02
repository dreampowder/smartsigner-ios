//
//    GetSingleTaskNoteResponse.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct GetSingleTaskNoteResponse:JsonProtocol{
    
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return GetSingleTaskNoteResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: exceptionMessage, exceptionCode: errorCode)
    }
    
    
    

    var errorCode : String!
    var exceptionMessage : String!
    var taskNote : TaskNote!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        errorCode = dictionary["ErrorCode"] as? String
        exceptionMessage = dictionary["ExceptionMessage"] as? String
        if let taskNoteData = dictionary["TaskNote"] as? [String:Any]{
            taskNote = TaskNote(fromDictionary: taskNoteData)
        } else if let taskNoteData = dictionary["TaskNoteOperation"] as? [String:Any]{
            taskNote = TaskNote(fromDictionary: taskNoteData)
        }
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
        if taskNote != nil{
            dictionary["TaskNote"] = taskNote.toDictionary()
        }
        return dictionary
    }

}
