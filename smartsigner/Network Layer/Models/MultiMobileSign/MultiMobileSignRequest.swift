// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let multiMobileSignRequest = try? JSONDecoder().decode(MultiMobileSignRequest.self, from: jsonData)

import Foundation

// MARK: - Request
struct MultiMobileSignRequest: Codable {
    /*
    let userName: String
    let userID, sessionID: Int
    let clientTypeName, clientIPAddress, userSurname, userResponse: String
     */
    let mobileOperator: Int
    let mobilePhoneNumber: String
    let items: [MultiMobileSignRequestItem]

    enum CodingKeys: String, CodingKey {
        /*
        case userName = "UserName"
        case userID = "UserId"
        case sessionID = "SessionId"
        case clientTypeName = "ClientTypeName"
        case clientIPAddress = "ClientIPAddress"
        case userSurname = "UserSurname"
        case userResponse = "UserResponse"
         */
        case mobileOperator = "MobileOperator"
        case mobilePhoneNumber = "MobilePhoneNumber"
        case items = "Items"
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "MobileOperator":mobileOperator,
            "MobilePhoneNumber":mobilePhoneNumber,
            "Items": items.map({ item in
                item.toDictionary()
            })
        ]
       }
       
       static func from(dictionary: [String: Any]) -> MultiMobileSignRequest? {
           guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else { return nil }
           return try? JSONDecoder().decode(MultiMobileSignRequest.self, from: jsonData)
       }
}

// MARK: - Item
struct MultiMobileSignRequestItem: Codable {
    let poolItemID: String
    let lastEditDateAsString: String

    enum CodingKeys: String, CodingKey {
        case poolItemID = "PoolItemId"
        case lastEditDateAsString = "LastEditDateAsString"
    }
    
    func toDictionary() -> [String: Any]{
        return [
            "PoolItemId" : poolItemID,
            "LastEditDateAsString" : lastEditDateAsString
        ]
    }
}
