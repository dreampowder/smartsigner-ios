// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let multiMobileSignResponse = try? JSONDecoder().decode(MultiMobileSignResponse.self, from: jsonData)

import Foundation

// MARK: - MultiMobileSignResponse
struct MultiMobileSignResponse: Codable, JsonProtocol {
    
    static func mock() -> MultiMobileSignResponse{
        let mockMultiMobileSignResponseItems: [MultiMobileSignResponseItem] = [
            MultiMobileSignResponseItem(documentID: 101, documentSubject: "Contract Agreement", isSigned: true, message: "Successfully signed by both parties.", poolID: 1),
            MultiMobileSignResponseItem(documentID: 102, documentSubject: "NDA Agreement", isSigned: false, message: "Awaiting signatures.", poolID: 2),
            MultiMobileSignResponseItem(documentID: 103, documentSubject: "Lease Agreement", isSigned: true, message: "Fully executed.", poolID: 3),
            MultiMobileSignResponseItem(documentID: 104, documentSubject: "Employment Contract", isSigned: false, message: "Pending HR review.", poolID: 1),
            MultiMobileSignResponseItem(documentID: 105, documentSubject: "Partnership Agreement", isSigned: true, message: "Signed and stored.", poolID: 2)
        ]
        return MultiMobileSignResponse(errorCode: nil,exceptionMessage: "", items: mockMultiMobileSignResponseItems)
    }
    
    static func parseJson(dictionary: [String : Any]) -> Any? {
        from(dictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    func errorContent() -> String? {
        return Utilities.getErrorContent(exceptionMessage: exceptionMessage, exceptionCode: errorCode)
    }
    
    let errorCode, exceptionMessage: String?
    let items: [MultiMobileSignResponseItem]

    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case exceptionMessage = "ExceptionMessage"
        case items = "Items"
    }
    
    func toDictionary() -> [String: Any]? {
           guard let data = try? JSONEncoder().encode(self) else { return nil }
           return try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
       }
       
   static func from(dictionary: [String: Any]) -> MultiMobileSignResponse? {
       guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else { return nil }
       return try? JSONDecoder().decode(MultiMobileSignResponse.self, from: jsonData)
   }
}

// MARK: - Item
struct MultiMobileSignResponseItem: Codable {
    
    let documentID: Int
    let documentSubject: String
    let isSigned: Bool
    let message: String
    let poolID: Int

    enum CodingKeys: String, CodingKey {
        case documentID = "DocumentId"
        case documentSubject = "DocumentSubject"
        case isSigned = "IsSigned"
        case message = "Message"
        case poolID = "PoolId"
    }
}
