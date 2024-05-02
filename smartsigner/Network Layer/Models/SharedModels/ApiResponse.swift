//
//  ApiResponse.swift
//  smartsigner
//
//  Created by Serdar Coskun on 20.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit

struct ApiResponse:JsonProtocol {
    
    var rawData:[String:Any]? = [:]
    
    init(dictionary:[String:Any]) {
        self.rawData = dictionary
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: self.rawData?["ExceptionMessage"] as? String, exceptionCode:self.rawData?["ErrorCode"] as? String)
    }
    
    static func parseJson(dictionary: [String : Any]) -> Any? {
        let response = ApiResponse(dictionary: dictionary)
        return response
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        var responseArray:[ApiResponse] = []
        for dict in jsonArray{
            responseArray.append(ApiResponse(dictionary: dict))
        }
        return responseArray
    }
}
