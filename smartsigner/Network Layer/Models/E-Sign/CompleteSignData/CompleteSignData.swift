//
//  CompleteSignData.swift
//  smartsigner
//
//  Created by Serdar Coskun on 15.12.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit

@objc class CompleteSignData: NSObject {

    var date : String!
    var documentId : Int!
    var documentSignHasChanges : Bool!
    var documentSignOperationToDo : String!
    var documentWithNumberOnItPathOnServer : String!
    var isMobileSign : Bool!
    var isSignature : Bool!
    var itIsSecondOrNextSignature : Bool!
    var newDocumentPathOnServer : String!
    var operationGuid : String!
    var packagePathOnServer : String!
    var paketOzetiBytes : String!
    var poolItemId : Int!
    var poolNewLastEditDate : String!
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
        isMobileSign = dictionary["IsMobileSign"] as? Bool
        isSignature = dictionary["IsSignature"] as? Bool
        itIsSecondOrNextSignature = dictionary["ItIsSecondOrNextSignature"] as? Bool
        newDocumentPathOnServer = dictionary["NewDocumentPathOnServer"] as? String
        operationGuid = dictionary["OperationGuid"] as? String
        packagePathOnServer = dictionary["PackagePathOnServer"] as? String
        paketOzetiBytes = dictionary["PaketOzetiBytes"] as? String
        poolItemId = dictionary["PoolItemId"] as? Int
        poolNewLastEditDate = dictionary["PoolNewLastEditDate"] as? String
        signerUserId = dictionary["SignerUserId"] as? Int
        pdfSignedWithCadesAsString = dictionary["PdfSignedWithCadesAsString"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func dictionaryValue() -> [String:Any]
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
        if isMobileSign != nil{
            dictionary["IsMobileSign"] = isMobileSign
        }
        if isSignature != nil{
            dictionary["IsSignature"] = isSignature
        }
        if itIsSecondOrNextSignature != nil{
            dictionary["ItIsSecondOrNextSignature"] = itIsSecondOrNextSignature
        }
        if newDocumentPathOnServer != nil{
            dictionary["NewDocumentPathOnServer"] = newDocumentPathOnServer
        }
        if operationGuid != nil{
            dictionary["OperationGuid"] = operationGuid
        }
        if packagePathOnServer != nil{
            dictionary["PackagePathOnServer"] = packagePathOnServer
        }
        if paketOzetiBytes != nil{
            dictionary["PaketOzetiBytes"] = paketOzetiBytes
        }
        if poolItemId != nil{
            dictionary["PoolItemId"] = poolItemId
        }
        if poolNewLastEditDate != nil{
            dictionary["PoolNewLastEditDate"] = poolNewLastEditDate
        }
        if signerUserId != nil{
            dictionary["SignerUserId"] = signerUserId
        }
        if pdfSignedWithCadesAsString != nil{
            dictionary["PdfSignedWithCadesAsString"] = pdfSignedWithCadesAsString
        }
        return dictionary
    }
    

    
    convenience init(document:DocumentContent, createPackageResponse:ESignPackageResponse) {
        self.init(fromDictionary: [:])
        self.isSignature = createPackageResponse.isSignature
        self.operationGuid = createPackageResponse.operationGuid
        self.documentId = document.pool.documentId
        self.poolItemId = document.pool.id
//        if document.poolTypeEnumNameAsString != nil && document.poolTypeEnumNameAsString.elementsEqual("IncomingForSignWithDigitalSignatureEYazisma")
            if createPackageResponse.documentSignRequest.signedPaketOzetiAsString != nil && createPackageResponse.documentSignRequest.signedPaketOzetiAsString.count > 0
        {
            self.poolNewLastEditDate = createPackageResponse.documentSignRequest.poolNewLastEditDate
            self.newDocumentPathOnServer = createPackageResponse.documentSignRequest.newDocumentPathOnServer
            self.documentWithNumberOnItPathOnServer = createPackageResponse.documentSignRequest.documentWithNumberOnItPathOnServer
            self.paketOzetiBytes = createPackageResponse.documentSignRequest.signedPaketOzetiAsString
                
            self.documentSignHasChanges = createPackageResponse.documentSignRequest.hasChanges
            self.documentSignOperationToDo = createPackageResponse.documentSignRequest.operationTodo
            self.packagePathOnServer = ""
//            self.pdfSignedWithCadesAsString = createPackageResponse.documentSignRequest.pdfToBeSignedWithCadesAsString
        }else{
            self.packagePathOnServer = createPackageResponse.createPackageResponse.packagePathOnServer?.replacingOccurrences(of: "\\", with: "#")
            self.poolNewLastEditDate = createPackageResponse.createPackageResponse.poolNewLastEditDate
            if let path = createPackageResponse.documentSignResponse.documentWithNumberOnItPathOnServer {
                self.documentWithNumberOnItPathOnServer = path.replacingOccurrences(of: "\\", with: "#")
            }

            if let path = createPackageResponse.documentSignResponse.newDocumentPathOnServer {
                self.newDocumentPathOnServer = path.replacingOccurrences(of: "\\", with: "#")
            }
            self.paketOzetiBytes = createPackageResponse.createPackageResponse.paketOzetiDataAsString
            self.documentSignHasChanges = createPackageResponse.documentSignRequest.hasChanges
            self.documentSignOperationToDo = createPackageResponse.documentSignRequest.operationTodo
            self.signerUserId = SessionManager.current.loginData?.loggedUserId

        }
        
        self.pdfSignedWithCadesAsString = createPackageResponse.documentSignRequest.pdfToBeSignedWithCadesAsString ?? createPackageResponse.createPackageResponse.pdfToBeSignedWithCadesAsString
        
        if document.poolTypeEnumNameAsString != nil{
            self.itIsSecondOrNextSignature = document.poolTypeEnumNameAsString.contains("EYazisma")
        }
    }
}
