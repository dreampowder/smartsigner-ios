//
//    ESignLoginResponse.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ESignLoginResponse:JsonProtocol{
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return ESignLoginResponse(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return nil
    }
    

    var digestAsBase64: String!
    var digest : [UInt]!
    var transactionUuid : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        digestAsBase64 = dictionary["DigestAsBase64"] as? String
        digest = dictionary["Digest"] as? [UInt]
        transactionUuid = dictionary["TransactionUuid"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if digestAsBase64 != nil{
            dictionary["DigestAsBase64"] = digestAsBase64
        }
        if digest != nil{
            dictionary["Digest"] = digest
        }
        if transactionUuid != nil{
            dictionary["TransactionUuid"] = transactionUuid
        }
        return dictionary
    }

}
