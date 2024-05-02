//
//	GetTaskNoteAssignmentTypes.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct GetTaskNoteAssignmentTypesResponse:JsonProtocol{
    
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return GetTaskNoteAssignmentTypesResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: exceptionMessage, exceptionCode: errorCode)
    }
    
    
    var assignmentTypes : [TaskNoteAssignmentType]!
    var errorCode : String!
    var exceptionMessage : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        assignmentTypes = [TaskNoteAssignmentType]()
        if let assignmentTypesArray = dictionary["AssignmentTypes"] as? [[String:Any]]{
            for dic in assignmentTypesArray{
                let value = TaskNoteAssignmentType(fromDictionary: dic)
                assignmentTypes.append(value)
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
        if assignmentTypes != nil{
            var dictionaryElements = [[String:Any]]()
            for assignmentTypesElement in assignmentTypes {
                dictionaryElements.append(assignmentTypesElement.toDictionary())
            }
            dictionary["AssignmentTypes"] = dictionaryElements
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
