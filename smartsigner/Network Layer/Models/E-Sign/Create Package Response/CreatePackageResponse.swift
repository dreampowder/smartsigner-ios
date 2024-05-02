//
//	CreatePackageResponse.swift
//
//	Create by Serdar Coşkun on 15/12/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct CreatePackageResponse{

	var packagePathOnServer : String!
	var paketOzetiDataAsString : String!
	var poolNewLastEditDate : String!
    var pdfToBeSignedWithCadesAsString: String?
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		packagePathOnServer = dictionary["PackagePathOnServer"] as? String
		paketOzetiDataAsString = dictionary["PaketOzetiDataAsString"] as? String
		poolNewLastEditDate = dictionary["PoolNewLastEditDate"] as? String
        pdfToBeSignedWithCadesAsString = dictionary["PdfToBeSignedWithCadesAsString"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if packagePathOnServer != nil{
			dictionary["PackagePathOnServer"] = packagePathOnServer
		}
		if paketOzetiDataAsString != nil{
			dictionary["PaketOzetiDataAsString"] = paketOzetiDataAsString
		}
		if poolNewLastEditDate != nil{
			dictionary["PoolNewLastEditDate"] = poolNewLastEditDate
		}
        if pdfToBeSignedWithCadesAsString != nil{
            dictionary["PdfToBeSignedWithCadesAsString"] = pdfToBeSignedWithCadesAsString
        }
		return dictionary
	}

}
