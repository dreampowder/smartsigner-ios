//
//	DocumentPool.swift
//
//	Create by Serdar Coşkun on 24/9/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DocumentPool{

	var canDelete : Bool!
	var documentDateAsString : String!
	var documentId : Int!
	var documentMotionUid : String!
	var documentMotionUidAsString : String!
	var documentNo : String!
	var errorCode : String!
	var exceptionMessage : String!
	var fromSentence : String!
	var fromSentenceToolTip : String!
	var hasAttachment : Bool!
	var hasNote : Bool!
	var id : Int!
	var isDocumentForward : Bool!
	var isDocumentReply : Bool!
	var isDocumentSendToArchive : Bool!
	var isDocumentSign : Bool!
	var isDraftFromFileOrNewDraft : Bool!
	var isRead : Bool!
	var isSigned : Bool!
	var isTopSecret : Bool!
	var lastEditDate : String!
	var ownerUserId : Int!
	var poolCategoryBrush : String!
	var poolCategoryId : Int!
	var poolCategoryToolTip : String!
	var poolTypeEnumNameAsString : String!
	var poolTypeEnumString : String!
	var sdpCode : String!
	var sentDateAsString : String!
	var subject : String!
	var toSentence : String!
	var toSentenceToolTip : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		canDelete = dictionary["CanDelete"] as? Bool
		documentDateAsString = dictionary["DocumentDateAsString"] as? String
		documentId = dictionary["DocumentId"] as? Int
		documentMotionUid = dictionary["DocumentMotionUid"] as? String
		documentMotionUidAsString = dictionary["DocumentMotionUidAsString"] as? String
		documentNo = dictionary["DocumentNo"] as? String
		errorCode = dictionary["ErrorCode"] as? String
		exceptionMessage = dictionary["ExceptionMessage"] as? String
		fromSentence = dictionary["FromSentence"] as? String
		fromSentenceToolTip = dictionary["FromSentenceToolTip"] as? String
		hasAttachment = dictionary["HasAttachment"] as? Bool
		hasNote = dictionary["HasNote"] as? Bool
		id = dictionary["Id"] as? Int
		isDocumentForward = dictionary["IsDocumentForward"] as? Bool
		isDocumentReply = dictionary["IsDocumentReply"] as? Bool
		isDocumentSendToArchive = dictionary["IsDocumentSendToArchive"] as? Bool
		isDocumentSign = dictionary["IsDocumentSign"] as? Bool
		isDraftFromFileOrNewDraft = dictionary["IsDraftFromFileOrNewDraft"] as? Bool
		isRead = dictionary["IsRead"] as? Bool
		isSigned = dictionary["IsSigned"] as? Bool
		isTopSecret = dictionary["IsTopSecret"] as? Bool
		lastEditDate = dictionary["LastEditDate"] as? String
		ownerUserId = dictionary["OwnerUserId"] as? Int
		poolCategoryBrush = dictionary["PoolCategoryBrush"] as? String
		poolCategoryId = dictionary["PoolCategoryId"] as? Int
		poolCategoryToolTip = dictionary["PoolCategoryToolTip"] as? String
		poolTypeEnumNameAsString = dictionary["PoolTypeEnumNameAsString"] as? String
		poolTypeEnumString = dictionary["PoolTypeEnumString"] as? String
		sdpCode = dictionary["SdpCode"] as? String
		sentDateAsString = dictionary["SentDateAsString"] as? String
		subject = dictionary["Subject"] as? String
		toSentence = dictionary["ToSentence"] as? String
		toSentenceToolTip = dictionary["ToSentenceToolTip"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if canDelete != nil{
			dictionary["CanDelete"] = canDelete
		}
		if documentDateAsString != nil{
			dictionary["DocumentDateAsString"] = documentDateAsString
		}
		if documentId != nil{
			dictionary["DocumentId"] = documentId
		}
		if documentMotionUid != nil{
			dictionary["DocumentMotionUid"] = documentMotionUid
		}
		if documentMotionUidAsString != nil{
			dictionary["DocumentMotionUidAsString"] = documentMotionUidAsString
		}
		if documentNo != nil{
			dictionary["DocumentNo"] = documentNo
		}
		if errorCode != nil{
			dictionary["ErrorCode"] = errorCode
		}
		if exceptionMessage != nil{
			dictionary["ExceptionMessage"] = exceptionMessage
		}
		if fromSentence != nil{
			dictionary["FromSentence"] = fromSentence
		}
		if fromSentenceToolTip != nil{
			dictionary["FromSentenceToolTip"] = fromSentenceToolTip
		}
		if hasAttachment != nil{
			dictionary["HasAttachment"] = hasAttachment
		}
		if hasNote != nil{
			dictionary["HasNote"] = hasNote
		}
		if id != nil{
			dictionary["Id"] = id
		}
		if isDocumentForward != nil{
			dictionary["IsDocumentForward"] = isDocumentForward
		}
		if isDocumentReply != nil{
			dictionary["IsDocumentReply"] = isDocumentReply
		}
		if isDocumentSendToArchive != nil{
			dictionary["IsDocumentSendToArchive"] = isDocumentSendToArchive
		}
		if isDocumentSign != nil{
			dictionary["IsDocumentSign"] = isDocumentSign
		}
		if isDraftFromFileOrNewDraft != nil{
			dictionary["IsDraftFromFileOrNewDraft"] = isDraftFromFileOrNewDraft
		}
		if isRead != nil{
			dictionary["IsRead"] = isRead
		}
		if isSigned != nil{
			dictionary["IsSigned"] = isSigned
		}
		if isTopSecret != nil{
			dictionary["IsTopSecret"] = isTopSecret
		}
		if lastEditDate != nil{
			dictionary["LastEditDate"] = lastEditDate
		}
		if ownerUserId != nil{
			dictionary["OwnerUserId"] = ownerUserId
		}
		if poolCategoryBrush != nil{
			dictionary["PoolCategoryBrush"] = poolCategoryBrush
		}
		if poolCategoryId != nil{
			dictionary["PoolCategoryId"] = poolCategoryId
		}
		if poolCategoryToolTip != nil{
			dictionary["PoolCategoryToolTip"] = poolCategoryToolTip
		}
		if poolTypeEnumNameAsString != nil{
			dictionary["PoolTypeEnumNameAsString"] = poolTypeEnumNameAsString
		}
		if poolTypeEnumString != nil{
			dictionary["PoolTypeEnumString"] = poolTypeEnumString
		}
		if sdpCode != nil{
			dictionary["SdpCode"] = sdpCode
		}
		if sentDateAsString != nil{
			dictionary["SentDateAsString"] = sentDateAsString
		}
		if subject != nil{
			dictionary["Subject"] = subject
		}
		if toSentence != nil{
			dictionary["ToSentence"] = toSentence
		}
		if toSentenceToolTip != nil{
			dictionary["ToSentenceToolTip"] = toSentenceToolTip
		}
		return dictionary
	}

}