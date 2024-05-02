//
//	DocumentContent.swift
//
//	Create by Serdar Coşkun on 24/9/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct DocumentContent:JsonProtocol{
    
    func errorContent() -> String? {
        return self.exceptionMessage
    }
    
    static func parseJson(dictionary: [String : Any]) -> Any? {
        return DocumentContent(fromDictionary: dictionary)
    }
    
    static func parseJsonArray(jsonArray: [[String : Any]]) -> Any? {
        return nil
    }
    
    
    

	var attachments : [DocumentAttachment]!
	var btnDocumentBatchForwardVisibility : Bool!
	var btnDocumentConnectionsVisibility : Bool!
	var btnDocumentCopyVisibility : Bool!
	var btnDocumentDeclineVisibility : Bool!
	var btnDocumentDeleteVisibility : Bool!
	var btnDocumentEApprovalVisibility : Bool!
	var btnDocumentExportVisibility : Bool!
	var btnDocumentForwardToDepartmentVisibility : Bool!
	var btnDocumentForwardToUserVisibility : Bool!
	var btnDocumentForwardVisibility : Bool!
	var btnDocumentForwardVisibility2 : Bool!
	var btnDocumentGoToBoxVisibility : Bool!
	var btnDocumentMobileSignVisibility : Bool!
	var btnDocumentParaphVisibility : Bool!
	var btnDocumentPreviousSignaturesVisibility : Bool!
	var btnDocumentPrintBarcodeVisibility : Bool!
	var btnDocumentPrintMetadataVisibility : Bool!
	var btnDocumentPrintVisibility : Bool!
	var btnDocumentPullBackVisibility : Bool!
	var btnDocumentRemoveVisibility : Bool!
	var btnDocumentReplyVisibility : Bool!
	var btnDocumentSendBackVisibility : Bool!
	var btnDocumentSendDocumentsVisibility : Bool!
	var btnDocumentSendEmailVisibility : Bool!
	var btnDocumentSendToArchiveVisibility : Bool!
	var btnDocumentSendVisibility : Bool!
	var btnDocumentSignVisibility : Bool!
	var btnDocumentUpdateInformationVisibility : Bool!
	var btnDocumentViewMotionHistoryVisibility : Bool!
	var btnDocumentViewSdpsVisibility : Bool!
	var btnDocumentWorkflowVisibility : Bool!
	var canDelete : Bool!
	var documentData : String!
	var documentDataType : String!
	var documentDateAsString : String!
	var documentId : Int!
	var documentMotionUid : String!
	var documentMotionUidAsString : String!
	var documentNo : String!
	var documentPath : String!
	var errorCode : Int!
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
	var isSecret : Bool!
	var isSigned : Bool!
	var isTopSecret : Bool!
	var lastEditDate : String!
	var ownerFolder : String!
	var ownerUserId : Int!
	var pool : DocumentPool!
	var poolCategoryBrush : String!
	var poolCategoryId : Int!
	var poolCategoryToolTip : String!
	var poolTypeEnumNameAsString : String!
	var poolTypeEnumString : String!
	var related : [DocumentRelated]!
	var sdpCode : String!
	var securitySecretSentence : String!
	var sentDateAsString : String!
	var subject : String!
	var toSentence : String!
	var toSentenceToolTip : String!
	var useDigitalSignatureForSigns : Bool!
	var userCanViewDocument : Bool!
    var documentDataId:Int!
    var documentDataLength:Int!
    var clientHasSameDataWithServer:Bool!
    var btnDocumentDistributionApprovalVisibility:Bool!
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		attachments = [DocumentAttachment]()
		if let attachmentsArray = dictionary["Attachments"] as? [[String:Any]]{
			for dic in attachmentsArray{
				let value = DocumentAttachment(fromDictionary: dic)
				attachments.append(value)
			}
		}
		btnDocumentBatchForwardVisibility = dictionary["BtnDocumentBatchForwardVisibility"] as? Bool
		btnDocumentConnectionsVisibility = dictionary["BtnDocumentConnectionsVisibility"] as? Bool
		btnDocumentCopyVisibility = dictionary["BtnDocumentCopyVisibility"] as? Bool
		btnDocumentDeclineVisibility = dictionary["BtnDocumentDeclineVisibility"] as? Bool
		btnDocumentDeleteVisibility = dictionary["BtnDocumentDeleteVisibility"] as? Bool
		btnDocumentEApprovalVisibility = dictionary["BtnDocumentEApprovalVisibility"] as? Bool
		btnDocumentExportVisibility = dictionary["BtnDocumentExportVisibility"] as? Bool
		btnDocumentForwardToDepartmentVisibility = dictionary["BtnDocumentForwardToDepartmentVisibility"] as? Bool
		btnDocumentForwardToUserVisibility = dictionary["BtnDocumentForwardToUserVisibility"] as? Bool
		btnDocumentForwardVisibility = dictionary["BtnDocumentForwardVisibility"] as? Bool
		btnDocumentForwardVisibility2 = dictionary["BtnDocumentForwardVisibility2"] as? Bool
		btnDocumentGoToBoxVisibility = dictionary["BtnDocumentGoToBoxVisibility"] as? Bool
		btnDocumentMobileSignVisibility = dictionary["BtnDocumentMobileSignVisibility"] as? Bool
		btnDocumentParaphVisibility = dictionary["BtnDocumentParaphVisibility"] as? Bool
		btnDocumentPreviousSignaturesVisibility = dictionary["BtnDocumentPreviousSignaturesVisibility"] as? Bool
		btnDocumentPrintBarcodeVisibility = dictionary["BtnDocumentPrintBarcodeVisibility"] as? Bool
		btnDocumentPrintMetadataVisibility = dictionary["BtnDocumentPrintMetadataVisibility"] as? Bool
		btnDocumentPrintVisibility = dictionary["BtnDocumentPrintVisibility"] as? Bool
		btnDocumentPullBackVisibility = dictionary["BtnDocumentPullBackVisibility"] as? Bool
		btnDocumentRemoveVisibility = dictionary["BtnDocumentRemoveVisibility"] as? Bool
		btnDocumentReplyVisibility = dictionary["BtnDocumentReplyVisibility"] as? Bool
		btnDocumentSendBackVisibility = dictionary["BtnDocumentSendBackVisibility"] as? Bool
		btnDocumentSendDocumentsVisibility = dictionary["BtnDocumentSendDocumentsVisibility"] as? Bool
		btnDocumentSendEmailVisibility = dictionary["BtnDocumentSendEmailVisibility"] as? Bool
		btnDocumentSendToArchiveVisibility = dictionary["BtnDocumentSendToArchiveVisibility"] as? Bool
		btnDocumentSendVisibility = dictionary["BtnDocumentSendVisibility"] as? Bool
		btnDocumentSignVisibility = dictionary["BtnDocumentSignVisibility"] as? Bool
		btnDocumentUpdateInformationVisibility = dictionary["BtnDocumentUpdateInformationVisibility"] as? Bool
		btnDocumentViewMotionHistoryVisibility = dictionary["BtnDocumentViewMotionHistoryVisibility"] as? Bool
		btnDocumentViewSdpsVisibility = dictionary["BtnDocumentViewSdpsVisibility"] as? Bool
		btnDocumentWorkflowVisibility = dictionary["BtnDocumentWorkflowVisibility"] as? Bool
		canDelete = dictionary["CanDelete"] as? Bool
		documentData = dictionary["DocumentData"] as? String
		documentDataType = dictionary["DocumentDataType"] as? String
		documentDateAsString = dictionary["DocumentDateAsString"] as? String
		documentId = dictionary["DocumentId"] as? Int
		documentMotionUid = dictionary["DocumentMotionUid"] as? String
		documentMotionUidAsString = dictionary["DocumentMotionUidAsString"] as? String
		documentNo = dictionary["DocumentNo"] as? String
		documentPath = dictionary["DocumentPath"] as? String
		errorCode = dictionary["ErrorCode"] as? Int
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
		isSecret = dictionary["IsSecret"] as? Bool
		isSigned = dictionary["IsSigned"] as? Bool
		isTopSecret = dictionary["IsTopSecret"] as? Bool
		lastEditDate = dictionary["LastEditDate"] as? String
		ownerFolder = dictionary["OwnerFolder"] as? String
		ownerUserId = dictionary["OwnerUserId"] as? Int
		if let poolData = dictionary["Pool"] as? [String:Any]{
				pool = DocumentPool(fromDictionary: poolData)
			}
		poolCategoryBrush = dictionary["PoolCategoryBrush"] as? String
		poolCategoryId = dictionary["PoolCategoryId"] as? Int
		poolCategoryToolTip = dictionary["PoolCategoryToolTip"] as? String
		poolTypeEnumNameAsString = dictionary["PoolTypeEnumNameAsString"] as? String
		poolTypeEnumString = dictionary["PoolTypeEnumString"] as? String
		related = [DocumentRelated]()
		if let relatedArray = dictionary["RelatedDocuments"] as? [[String:Any]]{
			for dic in relatedArray{
				let value = DocumentRelated(fromDictionary: dic)
				related.append(value)
			}
		}
		sdpCode = dictionary["SdpCode"] as? String
		securitySecretSentence = dictionary["SecuritySecretSentence"] as? String
		sentDateAsString = dictionary["SentDateAsString"] as? String
		subject = dictionary["Subject"] as? String
		toSentence = dictionary["ToSentence"] as? String
		toSentenceToolTip = dictionary["ToSentenceToolTip"] as? String
		useDigitalSignatureForSigns = dictionary["UseDigitalSignatureForSigns"] as? Bool
		userCanViewDocument = dictionary["UserCanViewDocument"] as? Bool
        documentDataId = dictionary["DocumentDataId"] as? Int
        documentDataLength = dictionary["DocumentDataLength"] as? Int
        clientHasSameDataWithServer = dictionary["ClientHasSameDataWithServer"] as? Bool
        
        btnDocumentDistributionApprovalVisibility = dictionary["BtnDocumentDistributionApprovalVisibility"] as? Bool
        
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if attachments != nil{
			var dictionaryElements = [[String:Any]]()
			for attachmentsElement in attachments {
				dictionaryElements.append(attachmentsElement.toDictionary())
			}
			dictionary["Attachments"] = dictionaryElements
		}
		if btnDocumentBatchForwardVisibility != nil{
			dictionary["BtnDocumentBatchForwardVisibility"] = btnDocumentBatchForwardVisibility
		}
		if btnDocumentConnectionsVisibility != nil{
			dictionary["BtnDocumentConnectionsVisibility"] = btnDocumentConnectionsVisibility
		}
		if btnDocumentCopyVisibility != nil{
			dictionary["BtnDocumentCopyVisibility"] = btnDocumentCopyVisibility
		}
		if btnDocumentDeclineVisibility != nil{
			dictionary["BtnDocumentDeclineVisibility"] = btnDocumentDeclineVisibility
		}
		if btnDocumentDeleteVisibility != nil{
			dictionary["BtnDocumentDeleteVisibility"] = btnDocumentDeleteVisibility
		}
		if btnDocumentEApprovalVisibility != nil{
			dictionary["BtnDocumentEApprovalVisibility"] = btnDocumentEApprovalVisibility
		}
		if btnDocumentExportVisibility != nil{
			dictionary["BtnDocumentExportVisibility"] = btnDocumentExportVisibility
		}
		if btnDocumentForwardToDepartmentVisibility != nil{
			dictionary["BtnDocumentForwardToDepartmentVisibility"] = btnDocumentForwardToDepartmentVisibility
		}
		if btnDocumentForwardToUserVisibility != nil{
			dictionary["BtnDocumentForwardToUserVisibility"] = btnDocumentForwardToUserVisibility
		}
		if btnDocumentForwardVisibility != nil{
			dictionary["BtnDocumentForwardVisibility"] = btnDocumentForwardVisibility
		}
		if btnDocumentForwardVisibility2 != nil{
			dictionary["BtnDocumentForwardVisibility2"] = btnDocumentForwardVisibility2
		}
		if btnDocumentGoToBoxVisibility != nil{
			dictionary["BtnDocumentGoToBoxVisibility"] = btnDocumentGoToBoxVisibility
		}
		if btnDocumentMobileSignVisibility != nil{
			dictionary["BtnDocumentMobileSignVisibility"] = btnDocumentMobileSignVisibility
		}
		if btnDocumentParaphVisibility != nil{
			dictionary["BtnDocumentParaphVisibility"] = btnDocumentParaphVisibility
		}
		if btnDocumentPreviousSignaturesVisibility != nil{
			dictionary["BtnDocumentPreviousSignaturesVisibility"] = btnDocumentPreviousSignaturesVisibility
		}
		if btnDocumentPrintBarcodeVisibility != nil{
			dictionary["BtnDocumentPrintBarcodeVisibility"] = btnDocumentPrintBarcodeVisibility
		}
		if btnDocumentPrintMetadataVisibility != nil{
			dictionary["BtnDocumentPrintMetadataVisibility"] = btnDocumentPrintMetadataVisibility
		}
		if btnDocumentPrintVisibility != nil{
			dictionary["BtnDocumentPrintVisibility"] = btnDocumentPrintVisibility
		}
		if btnDocumentPullBackVisibility != nil{
			dictionary["BtnDocumentPullBackVisibility"] = btnDocumentPullBackVisibility
		}
		if btnDocumentRemoveVisibility != nil{
			dictionary["BtnDocumentRemoveVisibility"] = btnDocumentRemoveVisibility
		}
		if btnDocumentReplyVisibility != nil{
			dictionary["BtnDocumentReplyVisibility"] = btnDocumentReplyVisibility
		}
		if btnDocumentSendBackVisibility != nil{
			dictionary["BtnDocumentSendBackVisibility"] = btnDocumentSendBackVisibility
		}
		if btnDocumentSendDocumentsVisibility != nil{
			dictionary["BtnDocumentSendDocumentsVisibility"] = btnDocumentSendDocumentsVisibility
		}
		if btnDocumentSendEmailVisibility != nil{
			dictionary["BtnDocumentSendEmailVisibility"] = btnDocumentSendEmailVisibility
		}
		if btnDocumentSendToArchiveVisibility != nil{
			dictionary["BtnDocumentSendToArchiveVisibility"] = btnDocumentSendToArchiveVisibility
		}
		if btnDocumentSendVisibility != nil{
			dictionary["BtnDocumentSendVisibility"] = btnDocumentSendVisibility
		}
		if btnDocumentSignVisibility != nil{
			dictionary["BtnDocumentSignVisibility"] = btnDocumentSignVisibility
		}
		if btnDocumentUpdateInformationVisibility != nil{
			dictionary["BtnDocumentUpdateInformationVisibility"] = btnDocumentUpdateInformationVisibility
		}
		if btnDocumentViewMotionHistoryVisibility != nil{
			dictionary["BtnDocumentViewMotionHistoryVisibility"] = btnDocumentViewMotionHistoryVisibility
		}
		if btnDocumentViewSdpsVisibility != nil{
			dictionary["BtnDocumentViewSdpsVisibility"] = btnDocumentViewSdpsVisibility
		}
		if btnDocumentWorkflowVisibility != nil{
			dictionary["BtnDocumentWorkflowVisibility"] = btnDocumentWorkflowVisibility
		}
		if canDelete != nil{
			dictionary["CanDelete"] = canDelete
		}
		if documentData != nil{
			dictionary["DocumentData"] = documentData
		}
		if documentDataType != nil{
			dictionary["DocumentDataType"] = documentDataType
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
		if documentPath != nil{
			dictionary["DocumentPath"] = documentPath
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
		if isSecret != nil{
			dictionary["IsSecret"] = isSecret
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
		if ownerFolder != nil{
			dictionary["OwnerFolder"] = ownerFolder
		}
		if ownerUserId != nil{
			dictionary["OwnerUserId"] = ownerUserId
		}
		if pool != nil{
			dictionary["Pool"] = pool.toDictionary()
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
		if related != nil{
			var dictionaryElements = [[String:Any]]()
			for relatedElement in related {
				dictionaryElements.append(relatedElement.toDictionary())
			}
			dictionary["RelatedDocuments"] = dictionaryElements
		}
		if sdpCode != nil{
			dictionary["SdpCode"] = sdpCode
		}
		if securitySecretSentence != nil{
			dictionary["SecuritySecretSentence"] = securitySecretSentence
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
		if useDigitalSignatureForSigns != nil{
			dictionary["UseDigitalSignatureForSigns"] = useDigitalSignatureForSigns
		}
		if userCanViewDocument != nil{
			dictionary["UserCanViewDocument"] = userCanViewDocument
		}
        
        if documentDataId != nil{
            dictionary["DocumentDataId"] = documentDataId
        }
        
        if documentDataLength != nil {
            dictionary["DocumentDataLength"] = documentDataLength
        }
        
        if clientHasSameDataWithServer != nil{
            dictionary["ClientHasSameDataWithServer"] = clientHasSameDataWithServer
        }
        
        if btnDocumentDistributionApprovalVisibility != nil{
            dictionary["BtnDocumentDistributionApprovalVisibility"] = btnDocumentDistributionApprovalVisibility
        }
		return dictionary
	}
}
