//
//  ApiClient.swift
//  smartsigner
//
//  Created by Serdar Coskun on 20.09.2018.
//  Copyright Â© 2018 Seneka. All rights reserved.
//

import UIKit
import Alamofire

let API_PAGE_SIZE:Int = 20

enum ApiClient {
    
    case service_list
    case login(username:String, password:String,isReadOnly:Bool)
    case login_mobile(username:String, password:String,loginText:String,isReadOnly:Bool)
    case init_login_e_sign(username:String, certificateDate:String,isReadOnly:Bool, setId:String?)
    case login_e_sign(username:String,eSignedData:String,transactionUUID:String,isReadOnly: Bool, setId:String?)
    case initial_settings
    case get_pool_items(folderId:Int,page:Int)
    case get_pool_items_with_id_list(poolIds:[Int])
    
    case search(searchObject:SearchObject,page:Int)
    case deactivate_delegation(loginResponse:LoginResponse)
    
    case document_related(relatedId:Int, poolId:Int)
    case document_attachment(attachmentId:Int, poolId:Int)
    case document_details(document:PoolItem)
    case document_notes(document:PoolItem)
    case document_verions(documentId:Int)
    case document_history(documenId:Int)
    case document_paraph(poolId:Int,lastEditDate:String)
    case document_pull_back(poolId:Int, lastEditDate:String)
    case document_reject(poolId:Int, lastEditDate:String, message:String)
    case document_confirm(poolId:Int, documentId:Int,lastEditDate:String)
    case document_give_back(poolId:Int, lastEditDate:String, message:String)
    case document_archive(poolId:Int,departmentId:Int,passiveUserId:Int)
    case document_workflow_select_new_action(poolId:Int,folderId:Int)
    case delegate_confirue
    case delegate_search_user(searchQuery:String?)
    case delegate_list(request:ListDelegateRequest)
    
    case transfer_get_depoartments(isFavorites:Bool, searchQuery:String?, departmentType:DepoartmentTypeEnum?)
    case transfer_get_recent_users
    case transfer_get_department_groups(searchQuery:String?)
    case transfer_department_group_departments(departmentGroupId:Int)
    
    case transfer_post(poolId:Int,forwardNote:String?,dueDate:Date?,transfers:[TransferDocumentModel],promptResult:Int)
    
    case prepare_for_forward(poolIds:[Int],transfers:[TransferDocumentModel])
    
    case give_delegation(activeUserId:Int, passiveUserId:Int, beginDate:Date, endDate:Date, typeDict:[GiveDelegationType:Bool], note:String)
    
    
    case e_sign_create_package(document:DocumentContent,certificateData:String,isMobileSign:Bool)
    case e_sign_complete_signing(completeRequest:CompleteSignDataRequest)
    
    case document_workflow_select_action(folderId:Int, poolId:Int,workFlowActionId:Int)
    case document_workflow_client_action(poolId:Int,workFlowActionId:Int)
    case document_workflow_sign_action_start(workflowInstanceId:Int,workflowActionId:Int,poolId:Int,documentId:Int,certificateData:String, isMobileSign:Bool)
    case document_workflow_sign_action_start_sign_queue(workflowInstanceId:Int,workflowActionId:Int,poolId:Int,documentId:Int, setId:String)
    case mobile_sign_generate_fingerprint(base64Data:String)
    case mobile_sign_complete(documentId:Int, base64Data:String,secondOrNextSignature:Bool)
    
    case document_workflow_mobile_sign_server_package_end(signedDataBase64:String,workflowInstanceId:Int,workFlowActionId:Int,operationGuid:String, isMobileSign:Bool)
    case document_workflow_resume(workflowInstanceId: Int, workflowActionId: Int, poolId: Int)
    
    case get_folders
    
    case task_list(filter:FilterModel?)
    case get_task_note(id:Int)
    case get_task_note_operations(id:Int)
    case save_task_note_operation(request:SaveTaskNoteOperationRequest)
    case get_task_operations(id:Int)
    
    case get_task_note_assignment_types
    case task_logic_bookmak(taskNoteId:Int, bookMarkGUID:String,userChoiceId:Int)
    case get_saved_distribution_detail(name:String)
    
    case save_document_operation(id:Int,operationType:DocumentOperationType,description:String)
    
    case get_distribution_flow(documentId:Int, lastEditDate:String)
    case approve_distribution_flow(request:ApproveDistributionFlowRequest)
    case decline_distribution_flow(poolId:Int, userResponse:String)
    case distribution_flow_get_user_child_departments(documentId:Int,lastEditDate:String,dontShowDepartmentsUnderMe:Bool)
    case register_push(pushToken:String)
    case delete_push_token(pushToken:String)
    
    case create_package_for_sign_queue(poolExtended:DocumentContent,signingGuid:String)
    case check_sign_queue_status(signingGuid:String)
    
    case multi_mobile_sign(request:MultiMobileSignRequest)
    
    private var method: HTTPMethod {
        switch self {
        case .service_list:
            return .get
        default:
            return .post
        }
    }
    
    private var path:String{
        switch self {
        case .service_list:
            return ""
        case .login,.login_mobile,.login_e_sign:
            return "login"
        case .init_login_e_sign:
            return "InitESign"
        case .get_pool_items:
            return "GetPoolItems"
        case .search:
            return "Search2"
        case .document_details:
            return "GetPoolExtended"
        case .document_notes:
            return "GetDocumentNotes"
        case .document_verions:
            return "GetDocumentVersions"
        case .document_history:
            return "GetDocumentHistory"
        case .document_attachment:
            return "GetDocumentAttachmentById"
        case .delegate_search_user:
            return "GetUsers"
        case .delegate_list:
            return "GetDelegations"
        case .delegate_confirue:
            return "ConfigureGiveDelegationScreen"
        case .document_paraph:
            return "ParaphDocument"
        case .document_pull_back:
            return "PullBackDocument"
        case .document_reject:
            return "DeclineDocument"
        case .document_give_back:
            return "SendBackDocument"
        case .document_archive:
            return "SendDocumentToArchive"
        case .document_workflow_select_new_action:
            return "SelectNewAction"
        case .transfer_get_depoartments(let isFavorites,_, _):
            if isFavorites{
                return "GetRecentlyUsedDepartments"
            }else{
                return "GetDepartments"
            }
        case .transfer_get_recent_users:
            return "GetRecentlyUsedUsers"
        case .transfer_get_department_groups:
            return "GetDepartmentGroups"
        case .transfer_department_group_departments:
            return "GetDepartmentsOfDepartmentGroup"
        case .transfer_post:
            return "ForwardDocument"
        case .give_delegation:
            return "SaveDelegation"
        case .e_sign_create_package:
            return "CreatePackageForSigning"
        case .e_sign_complete_signing:
            return "CompleteSignOnEbys"
        case .deactivate_delegation:
            return "DeactivateDelegation"
        case .document_confirm:
            return "CompleteSignOnEbys"
        case .document_workflow_select_action:
            return "SelectWorkFlowAction"
        case .document_workflow_client_action:
            return "SelectClientAction"
        case .document_workflow_sign_action_start:
            return "ServerPaketImzalaStart"
        case .mobile_sign_generate_fingerprint:
            return "GenerateFingerPrint"
        case .mobile_sign_complete:
            return "MobileSign"
        case .document_workflow_mobile_sign_server_package_end:
            return "ServerPackageSignEnd"
        case .document_workflow_resume:
            return "ResumeWorkflow"
        case .get_folders:
            return "GetFolders"
        case .document_related:
            return "GetDocumentRelatedDocumentById"
        case .task_list:
            return "GetTaskNotes"
        case .get_task_note:
            return "GetTaskNote"
        case .get_task_note_operations:
            return "GetTaskNoteOperations"
        case .save_task_note_operation:
            return "SaveTaskNoteOperation"
        case .get_task_operations:
            return "GetTaskNoteOperations"
        case .get_task_note_assignment_types:
            return "GetTaskNoteAssignmentTypes"
        case .task_logic_bookmak:
            return "RunBookmark"
        case .initial_settings:
            return "GetInitialSettings"
        case .get_saved_distribution_detail:
            return "GetSavedDistributionDetail"
        case .save_document_operation:
            return "SaveDocumentOperation"
        case .prepare_for_forward:
            return "PrepareForForward"
        case .get_distribution_flow:
            return "GetDistributionFlowWithDocumentId"
        case .approve_distribution_flow:
            return "ApproveDistributionFlow"
        case .decline_distribution_flow:
            return "DeclineDistributionFlow"
        case .distribution_flow_get_user_child_departments:
            return "GetUserChildDeparmentsWithDepartmentId"
        case .register_push:
            return "SavePushNotificationToken"
        case .delete_push_token:
            return "DeletePushNotificationToken"
        case .get_pool_items_with_id_list:
            return "GetPoolsWithIdList2"
        case .create_package_for_sign_queue:
            return "CreatePackageForSignQueue"
        case .check_sign_queue_status:
            return "CheckSignQueueStatus"
        case .document_workflow_sign_action_start_sign_queue:
            return "ServerSignPackageStartSignQueue"
        case .multi_mobile_sign:
            return "CreateMultiMobileSign"
        }
    }
    
    private var parameters:Parameters?{
        var requestContent:[String:Any]
        switch self {
        case .service_list:
            return nil
            
        case .login_e_sign(let username, let signedData, let transactionUUID,let isReadOnly, let setId):
            let splittedName = username.components(separatedBy: "@")
            let loginName = splittedName[0].lowercased(with: Locale(identifier: "tr-TR")).replacingOccurrences(of: " ", with: "")
            
            var request:LoginRequest = LoginRequest(fromDictionary: [:])
            request.userLoginName = loginName.AESEncrypt()
            request.password = "".AESEncrypt()
            request.clientIPAddress = IPAddressHelper.getIPAddress()
            request.verifyWithSms = false
            request.loginWithMobileSign = false
            request.clientTypeName = "EbysIOSClient"
            
            if transactionUUID.count > 0 {
                request.transactionUUID = transactionUUID
            }
            
            if signedData.count > 0{
                request.signedData = signedData
            }

            requestContent = request.toDictionary()
            requestContent["LoginWithESign"] = true
            requestContent["WantToSignReadOnly"] = isReadOnly
            if setId != nil{
                requestContent["SetId"] = setId
            }
        case .login_mobile(let username, let password, let loginText,let isReadOnly):
            

            let splittedName = username.components(separatedBy: "@")
            let loginName = splittedName[0].lowercased(with: Locale(identifier: "tr-TR")).replacingOccurrences(of: " ", with: "")
            
            var request:LoginRequest = LoginRequest(fromDictionary: [:])
            request.userLoginName = loginName.AESEncrypt()
            request.password = password.AESEncrypt()
            request.clientIPAddress = IPAddressHelper.getIPAddress()
            request.verifyWithSms = false
            request.loginWithMobileSign = true
            request.clientTypeName = "EbysIOSClient"
            requestContent = request.toDictionary()
            requestContent["WantToSignReadOnly"] = isReadOnly
            requestContent["MobileSignAlert"] = loginText.AESEncrypt()
        case .login(let username,let password,let isReadOnly):

            let splittedName = username.components(separatedBy: "@")
            let loginName = splittedName[0].lowercased(with: Locale(identifier: "tr-TR")).replacingOccurrences(of: " ", with: "")
            
            var request:LoginRequest = LoginRequest(fromDictionary: [:])
            request.userLoginName = loginName
            request.password = password.AESEncrypt()
            request.clientIPAddress = IPAddressHelper.getIPAddress()
            request.verifyWithSms = false
            request.loginWithMobileSign = false
            request.clientTypeName = "EbysIOSClient"
            requestContent = request.toDictionary()
            requestContent["WantToSignReadOnly"] = isReadOnly
        case .init_login_e_sign( _,let certificateData,let isReadOnly, let setId):
            var request = SessionManager.current.getBaseRequest().toDictionary();
            request["Certificate"] = certificateData
            //request["WantToSignReadOnly"] = isReadOnly
            if setId != nil{
                request["SetId"] = setId
            }
            requestContent = request
            
        case .get_pool_items(let folderId,let page):
            var request = SessionManager.current.getBaseRequest().toDictionary();
            request["FolderId"] = folderId
            request["Page"] = page
            request["PageSize"] = API_PAGE_SIZE
            requestContent = request
        case    .document_details(let document),
                .document_notes(let document):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["DocumentId"] = document.documentId
            request["PoolId"] = document.id
            let fileName = LocalFileManager.getFileName(document: document)
            if let cacheContent = LocalFileManager.getFileCacheValues(filename: fileName){
                request["DocumentDataId"] = cacheContent.fileId
                request["DocumentDataLength"] = cacheContent.fileLength
//                print("added cache keys")
            }
            requestContent = request
        case .search(let searchObject,let page):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            var request = SearchRequest(fromDictionary: SessionManager.current.getBaseRequest().toDictionary())
            request.barcodeNo = searchObject.barcodeNumber ?? ""
            request.documentNo = searchObject.documentNumber ?? ""
            request.subject = searchObject.query ?? ""
            request.endDate = (searchObject.endDate != nil) ? dateFormatter.string(from: searchObject.endDate!) : ""
            request.startDate = (searchObject.beginDate != nil) ? dateFormatter.string(from: searchObject.beginDate!) : ""
            request.page = page
            request.dontListDraftDocuments = true
            request.isSearchFromArchive = false
            request.pageSize = 20
            request.searchAllDocumentsIsChecked = false
            requestContent = request.toDictionary()
        case .document_verions(let documentId),
             .document_history(let documentId):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["DocumentId"] = documentId
            requestContent = request
        case .delegate_search_user(let searchQuery):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["Value"] = searchQuery ?? ""
            requestContent = request
        case .delegate_list(let listRequest):
            requestContent = listRequest.toDictionary()
        case .delegate_confirue:
            requestContent = SessionManager.current.getBaseRequest().toDictionary()
        case .document_attachment(let attachmentId, let poolId):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["DocumentAttachmentId"] = attachmentId
            request["PoolId"] = poolId
            requestContent = request
        case .document_related(let relatedId, let poolId):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["RelatedDocumentId"] = relatedId
            request["PoolId"] = poolId
            requestContent = request
        case .document_paraph(let poolId,let lastEditDate):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["PoolId"] = poolId
            request["LastEditDateAsString"] = lastEditDate
            request["DelegatedUserIds"] = (SessionManager.current.loginData?.delegations ?? []).map({$0.id ?? 0})
//            SessionManager.current.loginData?.delegations.forEach({delegationIds.append($0.id)})
//            saveRequest.delegatedUserIds = delegationIds
            requestContent = request
        case .document_pull_back(let poolId,let lastEditDate):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["PoolId"] = poolId
            request["LastEditDateAsString"] = lastEditDate
            requestContent = request
        case .document_reject(let poolId,let lastEditDate,let message):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["PoolId"] = poolId
            request["LastEditDateAsString"] = lastEditDate
            request["UserResponse"] = message
            requestContent = request
        case .document_give_back(let poolId,let lastEditDate,let message):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["PoolId"] = poolId
            request["LastEditDateAsString"] = lastEditDate
            request["UserResponse"] = message
            requestContent = request
        case .document_archive(let poolId,let departmentId,let passiveUserId):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["PoolId"] = poolId
            request["DepartmentId"] = departmentId
            request["PassiveUserId"] = passiveUserId
            requestContent = request
        case .document_workflow_select_new_action(let poolId,let folderId):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["PoolId"] = poolId
            request["FolderId"] = folderId
            requestContent = request
        case .transfer_get_depoartments(let isFavorites,let searchQuery,let departmentType):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            if !isFavorites{
                request["DepartmentTypeEnum"] = departmentType?.rawValue ?? 0
                request["Value"] = searchQuery ?? ""
            }
            requestContent = request
        case .transfer_get_recent_users:
            let request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            requestContent = request
        case .transfer_get_department_groups(let searchQuery):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["Value"] = searchQuery ?? ""
            requestContent = request
        case .transfer_department_group_departments(let departmentGroupId):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["DepartmentGroupId"] = departmentGroupId
            requestContent = request
        case .transfer_post(let poolId,let forwardNote,let dueDate,let transfers,let promptResult):
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd\\/MM\\/yyyy"
            
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["PoolId"] = poolId
            request["ForwardNote"] = forwardNote ?? ""
            request["DueDate"] = (dueDate != nil) ? dateFormatter.string(from: dueDate!) : ""
            var distributions:[[String:Any]] = []
            for index in 0..<transfers.count{
                let item = transfers[index]
                distributions.append(item.getRequestDictionary(order: index))
            }
            request["Distributions"] = distributions
            request["PromptResult"] = promptResult
            requestContent = request
            
        case .prepare_for_forward(let poolId,let transfers):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["PoolIds"] = poolId
            var distributions:[[String:Any]] = []
            for index in 0..<transfers.count{
                let item = transfers[index]
                distributions.append(item.getRequestDictionary(order: index))
            }
            request["Distributions"] = distributions
            requestContent = request
            
        case .give_delegation(let activeUserId,let passiveUserId,let beginDate,let endDate, let typeDict, let note):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd\\/MM\\/yyyy HH:mm:ss"
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["ActiveUserId"] = activeUserId
            request["PassiveUserId"] = passiveUserId
            request["StartDate"] = dateFormatter.string(from: beginDate)
            request["EndDate"] = dateFormatter.string(from: endDate)
            request["Description"] = note
            for type in typeDict.keys{
                request[type.rawValue] = typeDict[type]
            }
            requestContent = request
        case .e_sign_create_package(let document, let certificateData,let isMobileSign):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            
            var attachMentIds:[Int] = []
            for attachment in document.attachments{
                attachMentIds.append(attachment.id)
            }
            request["AttachmentIds"] = attachMentIds
            request["PoolItemId"] = document.pool.id
            request["SignerUserId"] = SessionManager.current.loginData?.loggedUserId
            request["IsPdf"] = document.documentDataType == nil ? true :  document.documentDataType.contains("pdf")
            request["DocumentDataType"] = document.documentDataType
            request["IsMobileSign"] = isMobileSign
            if certificateData.count > 0{
                request["CertificateData"] = certificateData
            }
            requestContent = request
        case .e_sign_complete_signing(let completeRequest):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            let completeDict = completeRequest.toDictionary()
            for key in completeDict.keys{
                request[key] = completeDict[key]
            }
            requestContent = request
        case .deactivate_delegation(let loginResponse):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["PassiveUserId"] = loginResponse.passiveUserId
            request["ActiveUserId"] = loginResponse.userActiveDelegationUserId
            request["ActiveDelegationId"] = loginResponse.userActiveDelegationId
            request["UserName"] = loginResponse.loggedUserName
            request["UserSurname"] = loginResponse.loggedUserSurname
            
            requestContent = request;
        case .document_confirm(let poolId,let documentId,let lastEditDate):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["PoolItemId"] = poolId
            request["DocumentId"] = documentId
            request["SignedDataAsString"] = " "
            request["IsEApproval"] = true
            request["SignerUserId"] = SessionManager.current.loginData?.loggedUserId
            request["Date"] = lastEditDate
            requestContent = request
        case .document_workflow_select_action(let folderId,let poolId,let workFlowActionId):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["PoolId"] = poolId
            request["FolderId"] = folderId
            request["WorkflowActionId"] = workFlowActionId
            requestContent = request
        case .document_workflow_client_action(let poolId,let workFlowActionId):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["PoolId"] = poolId
            request["WorkflowActionId"] = workFlowActionId
            requestContent = request
        case .document_workflow_sign_action_start(let workflowInstanceId,let workflowActionId,let poolId,let  documentId, let certificateData, let isMobileSign):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["PoolId"] = poolId
            request["WorkflowActionId"] = workflowActionId
            request["WorkflowInstanceId"] = workflowInstanceId
            request["DocumentIdForReadFromDocumentDataTable"] = documentId
            request["IsMobileSign"] = isMobileSign
            request["CertificateData"] = certificateData
            requestContent = request
        case .document_workflow_sign_action_start_sign_queue(let workflowInstanceId,let workflowActionId, let poolId,let documentId, let setId):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["PoolId"] = poolId
            request["WorkflowActionId"] = workflowActionId
            request["WorkflowInstanceId"] = workflowInstanceId
            request["DocumentIdForReadFromDocumentDataTable"] = documentId
            request["SetId"] = setId
            requestContent = request
        case .mobile_sign_generate_fingerprint(let base64Data):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["DataAsString"] = base64Data
            request["IsSignature"] = true
//            request["MobileNumber"] = SessionManager.current.loginData?.mobileNumber
//            request["Operator"] = SessionManager.current.loginData?.operatorId
//            print("!!!!! TELEFON NUMARASINI DEÄžÄ°ÅžTÄ°RMETÄ° UNUTMAYIN")
//            request["MobileNumber"] = "05323405551"
//            request["Operator"] = 0
            requestContent = request
        case .mobile_sign_complete(let documentId,let base64Data,let secondOrNextSignature):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["DocumentId"] = documentId
            request["DataToSignAsBase64"] = base64Data
            request["ItIsSecondOrNextSignature"] = secondOrNextSignature
            request["IsSignature"] = true
            //            request["MobileNumber"] = SessionManager.current.loginData?.mobileNumber
            //            request["Operator"] = SessionManager.current.loginData?.operatorId
//            print("!!!!! TELEFON NUMARASINI DEÄžÄ°ÅžTÄ°RMETÄ° UNUTMAYIN")
//            request["MobileNumber"] = "05323405551"
//            request["Operator"] = 0
            requestContent = request
        case .document_workflow_mobile_sign_server_package_end(let signedDataBase64,let workflowInstanceId,let workFlowActionId,let operationGuid, let isMobileSign):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["SignedDataAsBase64"] = signedDataBase64
            request["WorkflowActionId"] = workFlowActionId
            request["WorkflowInstanceId"] = workflowInstanceId
            request["OperationGuid"] = operationGuid
            request["IsMobileSign"] = isMobileSign
            requestContent = request
        case .document_workflow_resume(let workflowInstanceId,let workflowActionId,let poolId):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["PoolId"] = poolId
            request["WorkflowActionId"] = workflowActionId
            request["WorkflowInstanceId"] = workflowInstanceId
            requestContent = request
        case .get_folders:
            requestContent = SessionManager.current.getBaseRequest().toDictionary()
        case .task_list(let filter):
            var reqest = SessionManager.current.getBaseRequest().toDictionary()
            if let filter = filter{
                let filterDict = filter.getRequestDict()
                filterDict.keys.forEach({reqest[$0] = filterDict[$0]})
            }
            requestContent = reqest
        case .get_task_note(let id):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["TaskNoteId"] = id
            requestContent = request
        case .get_task_note_operations(let id):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["TaskNoteId"] = id
            requestContent = request
        case .save_task_note_operation(var saveRequest):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            var delegationIds:[Int] = []
            SessionManager.current.loginData?.delegations.forEach({delegationIds.append($0.id)})
            saveRequest.delegatedUserIds = delegationIds
            let reqDictionary = saveRequest.toDictionary()
            
            reqDictionary.keys.forEach { (key) in
                request[key] = reqDictionary[key]
            }
            requestContent = request
        case .get_task_operations(let id):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["TaskNoteId"] = id
            requestContent = request
        case .get_task_note_assignment_types:
            requestContent = SessionManager.current.getBaseRequest().toDictionary()
        case .task_logic_bookmak(let taskNoteId,let bookMarkGUID,let userChoiceId):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["TaskNoteId"] = taskNoteId
            request["Bookmark"] = bookMarkGUID
            request["UserChoiceId"] = userChoiceId
            requestContent = request
        case .initial_settings:
            requestContent = SessionManager.current.getBaseRequest().toDictionary()
        case .get_saved_distribution_detail(let name):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["Name"] = name
            requestContent = request
        case .save_document_operation(let id,let operationType,let description):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["DocumentId"] = id
            request["DocumentOperationTypeEnum"] = operationType.rawValue
            request["Description"] = description
            requestContent = request
        case .get_distribution_flow(let documentId,let lastEditDate):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["DocumentId"] = documentId
            request["LastEditDate"] = lastEditDate
            requestContent = request
        case .approve_distribution_flow(let approveReq):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            let dict = approveReq.toDictionary()
            dict.keys.forEach { (key) in
                request[key] = dict[key]
            }
            requestContent = request
        case .decline_distribution_flow(let poolId,let userResponse):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["PoolId"] = poolId
            request["UserResponse"] = userResponse
            requestContent = request
        case .distribution_flow_get_user_child_departments(let documentId,let lastEditDate,let dontShowDepartmentsUnderMe):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["DocumentId"] = documentId
            request["LastEditDate"] = lastEditDate
            request["ChkShowDepartmentsUnderMe"] = dontShowDepartmentsUnderMe
            requestContent = request
        case .register_push(let pushToken),.delete_push_token(let pushToken):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["Token"] = pushToken
            requestContent = request
        case .get_pool_items_with_id_list(let poolIds):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["PoolIds"] = poolIds
            requestContent = request
        case .create_package_for_sign_queue(let poolExtended,let signingGuid):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            
            var attachMentIds:[Int] = []
            for attachment in poolExtended.attachments{
                attachMentIds.append(attachment.id)
            }
            request["AttachmentIds"] = attachMentIds
            request["PoolItemId"] = poolExtended.pool.id
            request["SignerUserId"] = SessionManager.current.loginData?.loggedUserId
            request["IsPdf"] = poolExtended.documentDataType == nil ? true :  poolExtended.documentDataType.contains("pdf")
            request["DocumentDataType"] = poolExtended.documentDataType
            request["SetId"] = signingGuid
            requestContent = request
        case .check_sign_queue_status(let signingGuid):
            var request:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            request["SetId"] = signingGuid
            requestContent = request
        case .multi_mobile_sign(let request):
            var baseRequest:[String:Any] = SessionManager.current.getBaseRequest().toDictionary()
            baseRequest.merge(request.toDictionary()) { oldKey, newKey in
                newKey
            }
            requestContent = baseRequest
        }
        
        return ["request":requestContent]
    }

    private var base_url:String{
        switch self {
        case .service_list:
//            return "http://www.seneka.com.tr/mobileservice/mobileservices.json"
            return "https://s3.eu-west-3.amazonaws.com/seneka-ebdys/MobileData.txt"
        default:
            return SessionManager.current.serviceData?.serviceUrl ?? ""
//            return "http://ebystr.senekaapps.com/ebysturexternalservices2/mobileapi.svc/json/"
        }
        
    }
    
    private var requestEncoding:ParameterEncoding{
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
    private var full_path:String{
        return "\(self.base_url)\(self.path)"
    }
    
    private var headers:HTTPHeaders?{
        var headers:[String:String] =
            [:]
        switch self {
        case .login,.service_list,.login_e_sign,.login_mobile:
            return nil
        default:
            headers["Cookie"] = SessionManager.current.cookie
            if let loginData = SessionManager.current.loginData, let accessToken = loginData.accessToken {
                headers["AccessToken"] = accessToken
            }
        }
        return headers
    }
    
    private var credential:URLCredential?{
        switch self {
        case .login_mobile(let username,let password,_,_):
            let credentialUserName = "\(username):1".AESEncrypt()
            let credentialPassword = "\(password)123".AESEncrypt()
            let credential = URLCredential(user: credentialUserName, password: credentialPassword, persistence: URLCredential.Persistence.none)
            return credential
        case .login_e_sign(let username,_,_,_,_):
            let credentialUserName = "\(username):1".AESEncrypt()
            let credentialPassword = "123".AESEncrypt()
            let credential = URLCredential(user: credentialUserName, password: credentialPassword, persistence: URLCredential.Persistence.none)
            return credential
        case .deactivate_delegation(let loginResponse):
            let credentialUserName = loginResponse.deactivateDelegationUsername.lowercased(with: Locale(identifier: "tr-TR"))
            let credentialPassword = "\(loginResponse.unencryptedPass ?? "")".AESEncrypt()
            let credential = URLCredential(user: credentialUserName, password: credentialPassword, persistence: URLCredential.Persistence.none)
            return credential
        case .login(let username, let password,_):
            let credentialUserName = username
            let credentialPassword = password.AESEncrypt()
            let credential = URLCredential(user: credentialUserName, password: credentialPassword, persistence: URLCredential.Persistence.none)
            return credential
        case .service_list:
            return nil
        default:
            var credentialUserName = "";
            switch SessionManager.current.loginType {
            case .mobile_sign?:
                credentialUserName =  "\(SessionManager.current.loginTCKN ?? ""):1".AESEncrypt()
            case .username?:
                credentialUserName = SessionManager.current.loginData?.loggedUserUserName ?? "".AESEncrypt()
            case.e_sign_app?:
                credentialUserName = "\(SessionManager.current.loginData?.loggedUserCitizenShipNo ?? ""):1".AESEncrypt()
            default:
                credentialUserName = ""
            }
            let credentialPassword =  SessionManager.current.loginPassword ?? ""
            let credential = URLCredential(user: credentialUserName, password: credentialPassword, persistence: URLCredential.Persistence.forSession)
            return credential;
        }
    }
    
    private var willShowExceptionDialogs:Bool{
//        switch self {
//        case .login,
//             .login_esign,
//             .login_mobile,
//             .get_folders,
//             .e_sign_complete_signing,
//             .e_sign_create_package,
//             .document_workflow_mobile_sign_server_package_end,
//             .deactivate_delegation,
//             .task_logic_bookmak,
//             .document_related,
//             .document_attachment,
//             .prepare_for_forward:
//            return false
//        default:
//            return true
//        }
        return false
    }
    
    
    func execute<T:JsonProtocol>(responseBlock:@escaping(_ response:T?, _ error:Error?, _ statusCode:Int)->Void){
        self.execute(responseBlock: responseBlock, progressBlock: nil)
    }
    
    func execute<T:JsonProtocol>(responseBlock:@escaping(_ response:T?, _ error:Error?, _ statusCode:Int)->Void, progressBlock:DataRequest.ProgressHandler?){
        
        print("fullPath2: \(full_path)")
        print("params: \(self.parameters ?? [:])")
        let request:DataRequest
        ///Multi Mobile sign için fazladan timeout gerekiyor.
        if case .multi_mobile_sign(_) = self {
            guard let url = URL(string: self.full_path) else { return }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue // method needs to be of type HTTPMethod
            urlRequest.timeoutInterval = 600
            headers?.forEach { header in
                urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
            }
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters!, options: [])
            urlRequest.httpBody = jsonData
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request = Alamofire.request(urlRequest)
        }else{
            request =  Alamofire.request(self.full_path, method: method, parameters: parameters, encoding: self.requestEncoding, headers: headers)
        }
        
        
        if let credential = self.credential {
            request.authenticate(usingCredential: credential)
        }
        
        if let downloadProgress = progressBlock {
            request.downloadProgress(closure: downloadProgress)
        }
        request.responseString { (dataResponse) in
            var jsonString = dataResponse.result.value;
            switch self {
            case .login(_,let password,_):
                
                SessionManager.current.loginPassword = password.AESEncrypt()
                if let header = dataResponse.response?.allHeaderFields["Set-Cookie"] as? String
                {
                    SessionManager.current.cookie = header
                }
                
            case .login_mobile(let username,_,_,_), .login_e_sign(let username, _, _, _, _):
                SessionManager.current.loginPassword = "123".AESEncrypt()
                SessionManager.current.loginTCKN = username
                if let header = dataResponse.response?.allHeaderFields["Set-Cookie"] as? String
                {
                    SessionManager.current.cookie = header
                }
            case .service_list:
                if let str = jsonString{
                    jsonString = str.AESDecrypt()
                }
            default:
                print("success")
            }
            
            
            guard
                let jsonCheck:String = jsonString,
                let data = jsonCheck.data(using: .utf8) else
            {
                if let mainVC = UIApplication.shared.keyWindow?.rootViewController{
                    var vc = mainVC
                    if let presentedVC = mainVC.presentedViewController{
                        if !presentedVC.isKind(of: WFProgressDialogViewController.self){
                            vc = presentedVC
                        }
                        
                    }
                    let error = dataResponse.error
                    if (error?.localizedDescription == "cancelled") == false{
                        print("â˜¢ï¸â˜¢ï¸â˜¢ï¸â˜¢ï¸ Got Unexpected error from serverside: \(error?.localizedDescription ?? "")")
//                        Utilities.delay(0.5, closure: {
//                            AlertDialogFactory.showBasicAlertFromViewController(vc: vc, title: LocalizedStrings.error.localizedString(), message: error?.localizedDescription ?? "<TanÄ±msÄ±z Hata>", doneButtonTitle: nil, doneButtonAction: nil)
//                        })
                    }else{
                        print("Request Cncelled: \(self.path)")
                    }
                    
                }
                responseBlock(nil,dataResponse.error,dataResponse.response?.statusCode ?? 0)
                return;
            }
            print("statusCode:\(dataResponse.response?.statusCode ?? -1)")
            if dataResponse.response?.statusCode == 417{ //BaÅŸka bir yerden giriÅŸ yapÄ±ldÄ±..
                Observers.session_ended_alert.postNotification(userInfo: nil)
            }
            do{

                let jsonDict = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers,.allowFragments])
                print("JSON DICT: \(jsonDict)");
                if let dictionary = jsonDict as? [String:Any]{
                    let response:T = T.parseJson(dictionary: dictionary) as! T
//                    if  let errorMsg = Utilities.getErrorContent(exceptionMessage: dictionary["ExceptionMessage"] as? String , exceptionCode: dictionary["ErrorCode"] as? String),
//                        let mainVC = UIApplication.shared.keyWindow?.rootViewController,
//                        self.willShowExceptionDialogs{
//
//                        var vc = mainVC
//                        if mainVC.presentedViewController != nil{
//                            vc = mainVC.presentedViewController!
//                        }
//
//                        Utilities.delay(1.0, closure: {
//                            AlertDialogFactory.showBasicAlertFromViewController(vc: vc, title: LocalizedStrings.error.localizedString(), message: errorMsg, doneButtonTitle: nil, doneButtonAction: nil)
//                        })
//                    }
                    responseBlock(response,dataResponse.error,dataResponse.response?.statusCode ?? 0)
                }else if jsonDict is [[String:Any]]{
                    let response:T = T.parseJsonArray(jsonArray: jsonDict as! [[String:Any]]) as! T
                    responseBlock(response,dataResponse.error,dataResponse.response?.statusCode ?? 0)
                }
            }catch{
                print("\(self.full_path): unknown json data type: \(String(describing: dataResponse.value))")
                responseBlock(nil,dataResponse.error,dataResponse.response?.statusCode ?? 0)
            }
        }
    }
    
    static func cancelAllRequests(completitionBlock:@escaping()->Void?){
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            print("Cancelling\nDataTasks: \(dataTasks.count)\nUploadTasks:\(uploadTasks.count)\nDownloadTasks:\(downloadTasks.count)")
            dataTasks.forEach { $0.cancel()}
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
            completitionBlock()
        }
    }
}

protocol JsonProtocol {
    static func parseJson(dictionary:[String:Any])->Any?
    static func parseJsonArray(jsonArray:[[String:Any]])->Any?
    func errorContent() -> String?
}
