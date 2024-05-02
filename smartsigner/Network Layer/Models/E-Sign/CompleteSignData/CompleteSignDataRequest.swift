//
//    CompeteSignDataRequest.swift
//
//    Create by Serdar Coşkun on 15/12/2018
//    Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct CompleteSignDataRequest{
    
    var date : String!
    var documentId : Int!
    var documentSignHasChanges : Bool!
    var documentSignOperationToDo : String!
    var documentWithNumberOnItPathOnServer : String!
    var isEApproval : Bool!
    var isMobileSign : Bool!
    var isSignature : Bool!
    var itIsSecondOrNextSignature : Bool!
    var mobileNumber : Int!
    var newDocumentPathOnServer : String!
    var operationGuid : String!
    var operatorId : Int!
    var packagePathOnServer : String!
    var poolItemId : Int!
    var signedData : [Int]!
    var signedDataAsString : String!
    var signerUserId : Int!
    var pdfSignedWithCadesAsString: String?
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        date = dictionary["Date"] as? String
        documentId = dictionary["DocumentId"] as? Int
        documentSignHasChanges = dictionary["DocumentSignHasChanges"] as? Bool
        documentSignOperationToDo = dictionary["DocumentSignOperationToDo"] as? String
        documentWithNumberOnItPathOnServer = dictionary["DocumentWithNumberOnItPathOnServer"] as? String
        isEApproval = dictionary["IsEApproval"] as? Bool
        isMobileSign = dictionary["IsMobileSign"] as? Bool
        isSignature = dictionary["IsSignature"] as? Bool
        itIsSecondOrNextSignature = dictionary["ItIsSecondOrNextSignature"] as? Bool
        mobileNumber = dictionary["MobileNumber"] as? Int
        newDocumentPathOnServer = dictionary["NewDocumentPathOnServer"] as? String
        operationGuid = dictionary["OperationGuid"] as? String
        operatorId = dictionary["Operator"] as? Int
        packagePathOnServer = dictionary["PackagePathOnServer"] as? String
        poolItemId = dictionary["PoolItemId"] as? Int
        signedData = dictionary["SignedData"] as? [Int]
        signedDataAsString = dictionary["SignedDataAsString"] as? String
        signerUserId = dictionary["SignerUserId"] as? Int
        pdfSignedWithCadesAsString = dictionary["PdfSignedWithCadesAsString"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if date != nil{
            dictionary["Date"] = date
        }
        if documentId != nil{
            dictionary["DocumentId"] = documentId
        }
        if documentSignHasChanges != nil{
            dictionary["DocumentSignHasChanges"] = documentSignHasChanges
        }
        if documentSignOperationToDo != nil{
            dictionary["DocumentSignOperationToDo"] = documentSignOperationToDo
        }
        if documentWithNumberOnItPathOnServer != nil{
            dictionary["DocumentWithNumberOnItPathOnServer"] = documentWithNumberOnItPathOnServer
        }
        if isEApproval != nil{
            dictionary["IsEApproval"] = isEApproval
        }
        if isMobileSign != nil{
            dictionary["IsMobileSign"] = isMobileSign
        }
        if isSignature != nil{
            dictionary["IsSignature"] = isSignature
        }
        if itIsSecondOrNextSignature != nil{
            dictionary["ItIsSecondOrNextSignature"] = itIsSecondOrNextSignature
        }
        if mobileNumber != nil{
            dictionary["MobileNumber"] = mobileNumber
        }
        if newDocumentPathOnServer != nil{
            dictionary["NewDocumentPathOnServer"] = newDocumentPathOnServer
        }
        if operationGuid != nil{
            dictionary["OperationGuid"] = operationGuid
        }
        if operatorId != nil{
            dictionary["Operator"] = operatorId
        }
        if packagePathOnServer != nil{
            dictionary["PackagePathOnServer"] = packagePathOnServer
        }
        if poolItemId != nil{
            dictionary["PoolItemId"] = poolItemId
        }
        if signedData != nil{
            dictionary["SignedData"] = signedData
        }
        if signedDataAsString != nil{
            dictionary["SignedDataAsString"] = signedDataAsString
        }
        if signerUserId != nil{
            dictionary["SignerUserId"] = signerUserId
        }
        if pdfSignedWithCadesAsString != nil{
            dictionary["PdfSignedWithCadesAsString"] = pdfSignedWithCadesAsString
        }
        return dictionary
    }
    
}
