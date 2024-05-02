//
//  DocumentActionBusinessLogic.swift
//  smartsigner
//
//  Created by Serdar Coskun on 11.10.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class DocumentActionBusinessLogic: NSObject {

    var parentViewController:DocumentViewController?
    var documentContent:DocumentContent?
    var document:PoolItem?
    var documentNotes:[DocumentNote]?
    var dialogTranstitionController = MDCDialogTransitionController()
    var shapeScheme:MDCShapeScheme = MDCShapeScheme()

    var poolId:Int?
    
    var eSignViewController:ESignViewController?

    
    init(parentViewController:DocumentViewController,document:PoolItem?,documentContent:DocumentContent?) {
        super.init()
        self.documentContent = documentContent
        self.parentViewController = parentViewController
        self.document = document
    }
    
    func performAction(action:ActionMenuViewController.MenuItem.ActionType){
        print("perform action: \(action)")
        switch action {
        case .sign:
            signAction(isParaph:false,mobileSignBase64: nil,itIsSecondOrNextSignature: false)
        case .reject:
            rejectAction()
        case .initials:
            signAction(isParaph:true, mobileSignBase64: nil,itIsSecondOrNextSignature: false)
        case .transfer:
            transferAction()
        case .notes:
            notesAction()
        case .workflow:
            workFlowAction()
        case .remove_document:
            removeDocumentAction()
        case .take_back:
            takeBackAction()
        case .give_back:
            giveBackAction()
        case .versions:
            versionsAction()
        case .history:
            historyAction()
        case .archive:
            archiveAction()
        case .confirm:
            confirmAction()
        case .sign_mobile:
            mobileSignAction()
        case .share:
            shareAction()
        case .distribution_flow:
            distributionFlowAction()
        }
    }
    
    func shareAction(){
        self.parentViewController?.showShareDocument()
        
    }
    
    func distributionFlowAction(){
        self.document?.poolLastEditDate = self.documentContent?.lastEditDate
        parentViewController?.navigationController?.pushViewController( DistributionApprovalViewController(document: self.document!), animated: true)
    }
    
    func mobileSignAction(){
        self.parentViewController?.showAlert(title: LocalizedStrings.sign_mobile, message: .action_sign_message_sign_confirm, actions:
            [(title: LocalizedStrings.sign, handler: {(_) in
                let dialog = self.parentViewController?.showProgressDialog(title:
                    LocalizedStrings.sign_mobile, message: LocalizedStrings.e_sign_creating_package)
                self.parentViewController?.createESignPackage(withCertificateData: "<mobile_sign>", completion: { (packageSummaryBytes) in
                    guard let summaryBytes = packageSummaryBytes else{
                        dialog?.dismiss(animated: true, completion: {
                            self.parentViewController?.showBasicAlert(title: LocalizedStrings.sign_mobile, message: LocalizedStrings.sign_smart_card_error_no_sign_data, okTitle: LocalizedStrings.ok, actionHandler: nil)
                        })
                        return
                    }
                    
                    dialog?.setMessage(message: LocalizedStrings.e_sign_signing_document.localizedString())
                    ApiClient.mobile_sign_generate_fingerprint(base64Data: summaryBytes)
                        .execute(responseBlock: { (_ response:MobileSignFingerPrintResponse?, error, statusCode) in
                            if let errorContent = response?.errorContent(){
                                dialog?.dismiss(animated: true, completion: {
                                    self.parentViewController?.showBasicAlert(title: LocalizedStrings.sign_mobile.localizedString(), message: errorContent, okTitle: LocalizedStrings.ok, actionHandler: { (_) in
                                    })
                                })
                            }else{
                                dialog?.setMessage(message: response?.fingerPrint ?? "")
                                self.parentViewController?.completeSigning(withBase64String: summaryBytes,isMobileSign: true, completition: { (success, response) in
                                    dialog?.dismiss(animated: true, completion: {
                                        if success{
                                            self.parentViewController?.showBasicAlert(title: LocalizedStrings.sign_mobile, message: LocalizedStrings.sign_mobile_success, okTitle: LocalizedStrings.ok, actionHandler: { (_) in
                                                
                                            })
                                        }else{
                                            self.parentViewController?.showBasicAlert(title: LocalizedStrings.sign_mobile.localizedString(), message: response ?? LocalizedStrings.sign_smart_card_error_generic.localizedString(), okTitle: LocalizedStrings.ok, actionHandler: nil)
                                        }
                                    })
                                })
                            }
                        })
                })
                
            }),
            (title: LocalizedStrings.cancel, handler: nil)])
    }
    
    
    func confirmAction(){
        self.parentViewController?.showAlert(title: LocalizedStrings.confirm, message: LocalizedStrings.document_action_confirm_alert_message, actions: [(title: LocalizedStrings.confirm, handler: {_ in
            let dialog = self.parentViewController?.showProgressDialog(title: LocalizedStrings.empty_string, message: LocalizedStrings.confirm)
            
                ApiClient.document_confirm(poolId: self.document?.id ?? 0, documentId: self.document?.documentId ?? 0, lastEditDate: self.document?.lastEditDate ?? "")
                    .execute(responseBlock: { (_ response:FolderListResponse?, error, statusCode) in
                        dialog?.dismiss(animated: true, completion: nil)
                        Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                                self.parentViewController?.showBasicAlert(title: .confirm, message: .success, okTitle: nil, actionHandler: { (_) in
                                SessionManager.current.setFolders(folders: response?.folders ?? nil)
                                Observers.document_remove.post(userInfo: [Observers.keys.removed_document : self.document])
                                self.parentViewController?.navigationController?.popViewController(animated: true)
                            })
                        }
                    })
            })
            ,(title:LocalizedStrings.cancel, handler:nil)])
        
    }
    
    //Workflow sign selector
    func showSignSelector(isParaph:Bool){
        let _ = parentViewController?.showAlert(title: .sign, message: isParaph ? .action_sign_message_paraph_confirm : .action_sign_message_sign_confirm, actions:
            [
                (title: isParaph ? LocalizedStrings.document_paraph : LocalizedStrings.sign, handler:( { (_) in
                    if isParaph{
                        let dialog = self.parentViewController?.showProgressDialog(title: LocalizedStrings.empty_string, message: isParaph ?  LocalizedStrings.document_paraph : LocalizedStrings.sign)
                        ApiClient.document_paraph(poolId: self.document?.id ?? 0, lastEditDate: self.document?.lastEditDate ?? "")
                            .execute(responseBlock: { (response:FolderListResponse?, error, statusCode) in
                                dialog?.dismiss(animated: true, completion: {
                                    Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                                        SessionManager.current.setFolders(folders: response?.folders ?? nil)
                                        self.parentViewController?.showProgressDialog(title: LocalizedStrings.document_paraph, message: LocalizedStrings.success)
                                    }
                                })
                            })
                    }else{
                        var actions:[(title:LocalizedStrings,handler:MDCActionHandler?)] = [(title: LocalizedStrings.alert_message_sign_method_e_sign, handler: {(_) in
                            Utilities.checkESignStatus(parentViewControler: self.parentViewController!, isLogin: false, eSignMethod: .ark_signer_card) {
                                    if var signData = self.parentViewController?.workFlowsignData{
                                        signData.isMobileSign = false
                                        self.parentViewController?.workFlowsignData = signData
                                    }
                                    #if targetEnvironment(simulator)
                                        print("E-Sign is not supported on simulator")
                                    #else
                                    self.eSignViewController = ESignViewController(parentVC: self.parentViewController! )
                                    self.eSignViewController?.modalPresentationStyle = .overCurrentContext
                                        self.parentViewController?.present(self.eSignViewController!, animated: false, completion: nil)
                                    #endif
                            }
                        })]
                        actions.append((title: LocalizedStrings.alert_message_sign_e_sign_app, handler: {_ in
                            Utilities.checkESignStatus(parentViewControler: self.parentViewController!, isLogin: false, eSignMethod: .ark_signer_app) {
                                if let certData = self.parentViewController?.workFlowsignData{
                                    SessionManager.current.arkSignerSetId = UUID().uuidString
                                    ApiClient.document_workflow_sign_action_start_sign_queue(workflowInstanceId: certData.workFlowInstanceId, workflowActionId: certData.workFlowActionId, poolId: certData.poolId, documentId: certData.documentId, setId: SessionManager.current.arkSignerSetId ?? "")
                                        .execute { (_ response:FolderListResponse?, error, status) in
                                            Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                                                ArkSignerHelper.openArkSignerApp(parentVC: self.parentViewController!, callbackAction: "workflow", setId: SessionManager.current.arkSignerSetId ?? "")
                                            }
                                    }
                                }
                            }
                        }))
                    
                        actions.append((title:LocalizedStrings.alert_message_sign_method_mobile_sign, handler: {(_) in
                            Utilities.checkESignStatus(parentViewControler: self.parentViewController!, isLogin: false, eSignMethod: ESignType.mobile_sign) {
                                if var signData = self.parentViewController?.workFlowsignData{
                                    signData.isMobileSign = true
                                    self.parentViewController?.workFlowsignData = signData
                                }
                                if let certData = self.parentViewController?.workFlowsignData{
                                    ApiClient.document_workflow_sign_action_start(workflowInstanceId: certData.workFlowInstanceId, workflowActionId: certData.workFlowActionId, poolId: certData.poolId, documentId: certData.documentId,certificateData: "", isMobileSign: true)
                                        .execute { (_ response:WorkFlowSignPackageStartResponse?, error, statusCode) in
                                            Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                                                if let base64Data = response?.dataAsBase64{
                                                    if base64Data.count > 0{
                                                        self.mobileSign(base64Data: base64Data,itIsSecondOrNextSignature: response?.itIsSecondOrNextSignature ?? false)
                                                    }
                                                }
                                            }
                                    }
                                }
                            }
                            })
                        )
                        actions.append((title: LocalizedStrings.cancel, handler: nil))
                        self.parentViewController?.showAlert(title: LocalizedStrings.sign, message: LocalizedStrings.alert_message_pick_sign_method, actions: actions)
                    }
                    
                })),
                (title: LocalizedStrings.cancel, handler: nil)
            ])
    }
    
    func signAction(isParaph:Bool, mobileSignBase64:String?,itIsSecondOrNextSignature:Bool){
        let _ = parentViewController?.showAlert(title: .sign, message: isParaph ? .action_sign_message_paraph_confirm : .action_sign_message_sign_confirm, actions:
            [
                (title: isParaph ? LocalizedStrings.document_paraph : LocalizedStrings.sign, handler:( { (_) in
                    if isParaph{
                        let dialog = self.parentViewController?.showProgressDialog(title: LocalizedStrings.empty_string, message: isParaph ?  LocalizedStrings.document_paraph : LocalizedStrings.sign)
                        ApiClient.document_paraph(poolId: self.document?.id ?? 0, lastEditDate: self.document?.lastEditDate ?? "")
                            .execute(responseBlock: { (response:FolderListResponse?, error, statusCode) in
                                dialog?.dismiss(animated: true, completion: nil)
                                Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                                    self.parentViewController?.showBasicAlert(title: LocalizedStrings.document_paraph.localizedString(), message: LocalizedStrings.operation_successful.localizedString(), okTitle: nil, actionHandler: { (action) in
                                        SessionManager.current.setFolders(folders: response?.folders ?? nil)
                                        Observers.reload_folder.post(userInfo: nil)
                                        self.parentViewController?.navigationController?.popViewController(animated: true)
                                    })
                                }
                            })
                    }else{
                        var actions:[(title:LocalizedStrings,handler:MDCActionHandler?)] = [(title: LocalizedStrings.alert_message_sign_method_e_sign, handler: {(_) in
                            Utilities.checkESignStatus(parentViewControler: self.parentViewController!, isLogin: false, eSignMethod: .ark_signer_card) {
//                                if SessionManager.current.serviceData?.isArkEnabled ?? false{
                                    #if targetEnvironment(simulator)
                                        print("E-Sign is not supported on simulator")
                                    #else
                                    let vc = ESignViewController(parentVC: self.parentViewController!)
                                        vc.modalPresentationStyle = .overCurrentContext
                                        self.parentViewController?.present(vc, animated: false, completion: nil)
                                    #endif
//
//                                }else{
//                                    self.parentViewController?.showBasicAlert(title: LocalizedStrings.alert_message_sign_method_e_sign, message: LocalizedStrings.alert_message_e_sign_module_not_enabled, okTitle: LocalizedStrings.ok, actionHandler: nil)
//                                }
                            }
                        })]
                        if SessionManager.current.canUseArkSignerApp() {
                            actions.append((title:LocalizedStrings.alert_message_sign_e_sign_app, handler: {(_) in
                                self.signWithExternalApp()
                            }))
                        }
                        actions.append((title:LocalizedStrings.alert_message_sign_method_mobile_sign, handler: {(_) in
                            self.mobileSign(base64Data: mobileSignBase64,itIsSecondOrNextSignature: itIsSecondOrNextSignature)
                        }))
        
                        actions.append((title: LocalizedStrings.cancel, handler: nil))
                        actions.reverse()
                        self.parentViewController?.showAlert(title: LocalizedStrings.sign, message: LocalizedStrings.alert_message_pick_sign_method, actions: actions)
                        
                    }
                    
                })),
                (title: LocalizedStrings.cancel, handler: nil)
            ])
    }
    
   
    func signWithExternalApp(){
        Utilities.checkESignStatus(parentViewControler: parentViewController!, isLogin: false, eSignMethod: .ark_signer_app) {
            SessionManager.current.arkSignerSetId = UUID.init().uuidString
            let progress = self.parentViewController?.showProgressDialog(title: LocalizedStrings.sign, message: .please_wait)
                    ApiClient.create_package_for_sign_queue(poolExtended: self.documentContent!, signingGuid: SessionManager.current.arkSignerSetId ?? "")
                        .execute { (_ response:FolderListResponse?, error, status) in
                            progress?.dismiss(animated: true, completion: {
                                Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                                    ArkSignerHelper.openArkSignerApp(parentVC: self.parentViewController!, callbackAction: "singledocument", setId: SessionManager.current.arkSignerSetId ?? "")
                                }
                            })
                    }
        }
    }
    
    func checkArkSignerItemStatus(setId:String){
        guard setId == SessionManager.current.arkSignerSetId else{
            print("This is not the correct sign id")
            return;
        }
        let progress = parentViewController?.showProgressDialog(title: LocalizedStrings.alert_message_sign_e_sign_app, message: .please_wait)
        ApiClient.check_sign_queue_status(signingGuid: setId)
            .execute { (_ response:CheckSignQueueListResponse?, error, statusCode) in
                progress?.dismiss(animated: true, completion: {
                    Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                        if response?.items.count == 0{
                            AlertDialogFactory.showUnexpectedErrorFromViewController(vc: self.parentViewController!, doneButtonAction: nil)
                        }else{
                            if let item = response?.items.first{
                                guard let status:DigitalSignQueueStatusEnum = DigitalSignQueueStatusEnum(rawValue: item.digitalSignQueueStatusEnum ?? -1) else{
                                    AlertDialogFactory.showUnexpectedErrorFromViewController(vc: self.parentViewController!, doneButtonAction: nil)
                                    return
                                }
                                switch status {
                                case .completed:
                                    self.parentViewController?.showBasicAlert(title: .alert_message_sign_e_sign_app, message: .alert_e_sign_arksigner_success, okTitle: nil) { (_) in
                                        Observers.document_remove.post(userInfo: [Observers.keys.removed_document : self.document!])
                                        self.parentViewController?.navigationController?.popToRootViewController(animated: true)
                                    }
                                default:
                                    self.parentViewController?.showBasicAlert(title: LocalizedStrings.error.localizedString(), message: LocalizedStrings.alert_e_sign_arksigner_error.localizedString(params: ["\(status.getMessage())\n \(item.errorMessage ?? "")"]), okTitle: nil, actionHandler: nil)
                                }
                                
                            }else{
                                AlertDialogFactory.showUnexpectedErrorFromViewController(vc: self.parentViewController!, doneButtonAction: nil)
                            }
                        }
                    }
                })
        }
    }
    
    func rejectAction(){
        let confirmDialog = self.parentViewController?.showAlert(title:LocalizedStrings.reject, message:LocalizedStrings.document_reject_message,actions:[
            (title: LocalizedStrings.yes, handler:( { (_) in
                
                let inputDialog =  AlertDialogFactory.showAlertWithTextInputFromViewController(
                    vc: self.parentViewController!,
                    placeholder: LocalizedStrings.document_reject_placeholder.localizedString(),
                    title: LocalizedStrings.reject.localizedString(),
                    positiveTitle: LocalizedStrings.ok.localizedString(),
                    negativeTitle: LocalizedStrings.cancel.localizedString(),
                    delegate: self)
                inputDialog.modalPresentationStyle = .custom
                inputDialog.transitioningDelegate = self.dialogTranstitionController
                self.parentViewController?.present(inputDialog, animated: true, completion: nil)
                
            })),
            (title: LocalizedStrings.cancel, handler: nil)
            ]);
        
    }
    
    func performReject(message:String){
        let dialog = self.parentViewController?.showProgressDialog(title: LocalizedStrings.empty_string, message: LocalizedStrings.reject)
        ApiClient.document_reject(poolId: self.document?.id ?? 0, lastEditDate: self.document?.lastEditDate ?? "", message: message)
            .execute { (response:FolderListResponse?, error, statusCode) in
                dialog?.dismiss(animated: true, completion: {
                    Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                        self.parentViewController?.showBasicAlert(title: LocalizedStrings.reject.localizedString(), message: LocalizedStrings.operation_successful.localizedString(), okTitle: nil, actionHandler: { (action) in
                            self.parentViewController?.navigationController?.popViewController(animated: true)
                            Observers.document_remove.post(userInfo: [Observers.keys.removed_document : self.document])
                        })
                    }
                })
        }
    }
    
    func transferAction(){
        let vc = TransferDocumentViewController(document: document!)
        self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func notesAction(){
        if documentNotes != nil{
            showDocumentNotes()
        }else{
            let dialog = self.parentViewController?.showProgressDialog(title: .empty_string, message: .alert_message_loading_notes)
            ApiClient.document_notes(document: self.document!).execute { (_ response:DocumentNotesResponse?, error, statusCode) in
                dialog?.dismiss(animated: true, completion: {
                    Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                        self.documentNotes = response?.notes
                        self.showDocumentNotes()
                    }
                })
                
            }
        }
    }
    
    func showDocumentNotes(){
        guard let notes = self.documentNotes else{
            return
        }
        if notes.count == 0{
            AlertDialogFactory.showBasicAlertFromViewController(vc: self.parentViewController!, title: LocalizedStrings.document_notes.localizedString(), message: LocalizedStrings.notes_no_notes_to_show.localizedString(), doneButtonTitle: nil, doneButtonAction: nil)
            return
        }
        let vc = DocumentNotesDialogViewController(notes: notes)
        self.presentViewControllerFromBottomSheet(viewController: vc, trackingScrollView: vc.tableView)
    }
    
    func workFlowAction(){
        print("perform action workflow")
        let progress = self.parentViewController?.showProgressDialog(title: LocalizedStrings.empty_string, message: LocalizedStrings.workflow)
        ApiClient.document_workflow_select_new_action(poolId: self.document?.id ?? 0, folderId: self.document?.folderId ?? 0)
            .execute { (_ response:WorkFlowResponse?, error, statusCode) in
                progress?.dismiss(animated: true, completion: {
                    Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                        var actions:[MDCAlertAction] = []
                        actions.append(MDCAlertAction(title: LocalizedStrings.cancel.localizedString(), handler: {(action) in

                        }))
                        if self.document?.ownerUserId == SessionManager.current.loginData?.loggedUserId{
                            actions.append(MDCAlertAction(title: LocalizedStrings.take_back.localizedString(), handler: { (action) in
                                self.performAction(action: ActionMenuViewController.MenuItem.ActionType.take_back)
                            }))
                        }
                        for operation in response?.possibleWfOperations ?? []{
                            actions.append(MDCAlertAction(title: operation.displayName, handler: { (action) in
                                self.performWorkFlowAction(actionId: operation.id,folderId: self.document?.folderId ?? 0,displayName: operation.displayName,workFlowInstanceId: response?.workflowInstanceId ?? 0)
                            }))
                        }
                        Utilities.delay(1.0, closure: {
                            AlertDialogFactory.showAlertActionDialog(vc: self.parentViewController!, title: LocalizedStrings.workflow.localizedString(), message: response?.descriptionText ?? "Bir işlem seçiniz", actions: actions)
                        })
                    }
                })
        }
    }
    
    func performWorkFlowAction(actionId:Int,folderId:Int, displayName:String,workFlowInstanceId:Int){
        let progress = self.parentViewController?.showProgressDialog(title: LocalizedStrings.empty_string, message: LocalizedStrings.workflow)
        ApiClient.document_workflow_select_action(folderId: folderId, poolId: self.document?.id ?? 0, workFlowActionId: actionId)
            .execute { (_ response:WorkFlowActionResponse?, error, statusCode) in
                progress?.dismiss(animated: true, completion: {
                    Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                        if response?.doClientAction ?? false{
                            self.workflowClientAction(actionId: actionId, displayName: displayName,workflowInstanceId: workFlowInstanceId)
                        }else if response?.selectAction ?? false{
                            Utilities.delay(0.5, closure: {
                                self.workFlowAction()
                            })
                            
                        }
                        else{
                            if  let folders = response?.folders,
                                let willRefresh = response?.refreshFolders{
                                if folders.count > 0 && willRefresh{
                                    SessionManager.current.setFolders(folders: folders)
                                }
                            }
                            self.parentViewController?.showBasicAlert(title: displayName, message: response?.message ?? "", okTitle: nil, actionHandler: { (_) in
                                 Observers.reload_folder.post(userInfo: nil)
                                 self.parentViewController?.navigationController?.popViewController(animated: true)
                            })
                        }
                    }
                })
        }
    }
    
    func workflowClientAction(actionId:Int, displayName:String, workflowInstanceId:Int){
        guard let actionType = WorkFlowActionType(rawValue: displayName) else{
            print("unknown client action: \(displayName)")
            return
        }
        if actionType == .workflow_action_type_add_note{
            print("<Not ekleme henüz eklenmemiştir>")
            return
        }
        
        ApiClient.document_workflow_client_action(poolId: self.document?.id ?? 0, workFlowActionId: actionId)
            .execute { (_ response:WorkFlowClientActionResponse?, error, statusCode) in
                Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                    var documentId = 0
                    if let param = response?.parameters.first(where: { (p) -> Bool in
                        return p.key == "FirstOfItsKind"
                    }), let value = param.value as? Bool{
                        print("param value: \(value)")
                        if value == false{ //  False geliyor ise burada document Id arıyoruz
                            if let documentIdParam = response?.parameters.first(where: { (p) -> Bool in
                                return p.key == "DocumentId"
                            }), let docId = documentIdParam.value as? Int{
                                documentId = docId
                            }
                        }
                    }
                    if actionType == .workflow_action_type_sign_package{
                        self.workflowSignAction(poolId:response?.poolId ?? 0, documentId: documentId, workFlowActionId: actionId,workFlowInstanceId: workflowInstanceId,certificateData: "",isMobileSign: true)
                    }
                }
        }
    }
    
    func workflowSignAction(poolId:Int, documentId:Int, workFlowActionId:Int,workFlowInstanceId:Int,certificateData:String, isMobileSign:Bool){
        self.parentViewController?.workFlowsignData = (documentId, workFlowActionId,workFlowInstanceId,poolId,"",isMobileSign)
        self.showSignSelector(isParaph: false)
    }
    
    func mobileSign(base64Data:String?,itIsSecondOrNextSignature:Bool){
        Utilities.checkESignStatus(parentViewControler: self.parentViewController!, isLogin: false, eSignMethod: .mobile_sign) {
            if self.parentViewController?.workFlowsignData == nil{
                self.mobileSignAction()
            }else{
                ApiClient.mobile_sign_generate_fingerprint(base64Data: base64Data ?? "")
                    .execute { (_ response:MobileSignFingerPrintResponse?, error, statusCode) in
                        Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                            if let fingerPrint = response?.fingerPrint{
                                self.completeMobileSign(fingerPrint: fingerPrint, base64Data: base64Data ?? "", itIsSecondOrNextSignature: itIsSecondOrNextSignature)
                            }
                        }
                }
            }
        }
    }
    
    func completeMobileSign(fingerPrint:String, base64Data:String,itIsSecondOrNextSignature:Bool){
        let dialog = self.parentViewController?
            .showProgressDialog(
                title: LocalizedStrings.sign_mobile.localizedString(),
                message: LocalizedStrings.alert_mobile_sign_fingerPrint.localizedString(params: [fingerPrint]),
                isIndeterminate:true)
        ApiClient.mobile_sign_complete(documentId: self.document?.documentId ?? 0, base64Data: base64Data, secondOrNextSignature: itIsSecondOrNextSignature)
            .execute { (_ response:MobileSignCompleteResponse?, error, statusCode) in
                dialog?.dismiss(animated: true, completion: {
                    Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                        if let workFlowData = self.parentViewController?.workFlowsignData{
                            self.endSigningServerPackage(signDataBase64: response?.signedDataAsBase64 ?? "",documentId: workFlowData.documentId,workFlowActionId: workFlowData.workFlowActionId,workFlowInstanceId: workFlowData.workFlowInstanceId,poolId: workFlowData.poolId,operationGuid: "",isMobileSign: true)
                        }else{
                            print("Mobile sign end")
                        }
                    }
                })
        }
    }
    
    func endSigningServerPackage(signDataBase64:String,documentId:Int,workFlowActionId:Int,workFlowInstanceId:Int,poolId:Int, operationGuid:String,isMobileSign:Bool){
        ApiClient.document_workflow_mobile_sign_server_package_end(signedDataBase64: signDataBase64, workflowInstanceId:workFlowInstanceId , workFlowActionId: workFlowActionId,operationGuid: operationGuid,isMobileSign:isMobileSign )
            .execute { (_ response:ServerPackageSignEndResponse?, error, statusCode) in
                Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                    self.resumeWorkFlow(workflowInstanceId: workFlowInstanceId, workflowActionId: workFlowActionId, poolId: poolId)
                }
        }
    }
    
    func resumeWorkFlow(workflowInstanceId: Int, workflowActionId: Int, poolId: Int){
        let progress = self.parentViewController?.showProgressDialog(title: LocalizedStrings.workflow, message: .please_wait)
        ApiClient.document_workflow_resume(workflowInstanceId: workflowInstanceId, workflowActionId: workflowActionId, poolId: poolId)
            .execute { (_ response:WorkFlowActionResponse?, error, statusCode) in
                progress?.dismiss(animated: true, completion: {
                    Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                        if response?.refreshFolders ?? false && (response?.folders ?? []).count > 0{
                            SessionManager.current.setFolders(folders: response?.folders ?? [])
                        }
                        self.parentViewController?.workFlowsignData = nil
                        Observers.reload_folder.post(userInfo: nil)
                        if (response?.selectAction ?? false){
                            self.workFlowAction()
                        }else{
                            AlertDialogFactory.showBasicAlertFromViewController(vc: self.parentViewController!, title: LocalizedStrings.workflow.localizedString(), message: response?.message ?? "İş akışı devam ettirildi.", doneButtonTitle: LocalizedStrings.ok.localizedString(), doneButtonAction: {
                                self.parentViewController?.navigationController?.popViewController(animated: true)
                            })
                        }
                    }
                })
        }
    }
    
    func removeDocumentAction(){
        let _ = self.parentViewController?.showBasicAlert(title: LocalizedStrings.sign, message: LocalizedStrings.unimplemented, okTitle: .ok, actionHandler: nil)
    }
    
    func takeBackAction(){
        let _ = self.parentViewController?.showAlert(title:LocalizedStrings.take_back, message:LocalizedStrings.document_takeback_message,actions:[
            (title: LocalizedStrings.yes, handler:( { (_) in
                let dialog = self.parentViewController?.showProgressDialog(title: LocalizedStrings.empty_string, message: LocalizedStrings.take_back)
                    ApiClient.document_pull_back(poolId: self.document?.id ?? 0, lastEditDate: self.document?.lastEditDate ?? "")
                        .execute(responseBlock: { (_ response:FolderListResponse?, error, statusCode) in
                            
                                dialog?.dismiss(animated: true, completion: {
                                    Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                                        self.parentViewController?.showBasicAlert(title: .take_back, message: .operation_successful, okTitle: nil, actionHandler: { (_) in
                                            self.parentViewController?.navigationController?.popViewController(animated: true)
                                            if let document = self.document{
                                                Observers.document_remove.post(userInfo: [Observers.keys.removed_document : document])
                                            }
                                            if response?.folders.count ?? 0 > 0{
                                                SessionManager.current.setFolders(folders: response?.folders)
                                            }
                                        })
                                    }
                                })
                            
                            
                        })
                
                })),
                (title: LocalizedStrings.cancel, handler: nil)
            ]);
        
    }
    
    
    func giveBackAction(){ //İade
        let inputDialog = AlertDialogFactory
        .showAlertWithTextInputFromViewController(vc: self.parentViewController!,
                                                 placeholder: LocalizedStrings.document_giveback_placeholder.localizedString(),
                                                 title: LocalizedStrings.give_back.localizedString(),
                                                 positiveTitle: LocalizedStrings.ok.localizedString(),
                                                 negativeTitle: LocalizedStrings.cancel.localizedString(),
                                                 delegate: self)
        inputDialog.modalPresentationStyle = .custom
        inputDialog.transitioningDelegate = self.dialogTranstitionController
        self.parentViewController?.present(inputDialog, animated: true, completion: nil)
    }
    
    func performGiveBackAction(message:String){
        let dialog = self.parentViewController?.showProgressDialog(title: LocalizedStrings.empty_string, message: LocalizedStrings.give_back)
        ApiClient.document_give_back(poolId: self.document?.id ?? 0, lastEditDate: self.document?.lastEditDate ?? "", message: message)
            .execute { (response:FolderListResponse?, error, statusCode) in
                dialog?.dismiss(animated: true, completion: {
                    Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                        self.parentViewController?.showBasicAlert(title: .give_back, message: .operation_successful, okTitle: nil, actionHandler: { (_) in
                            self.parentViewController?.navigationController?.popViewController(animated: true)
                            Observers.document_remove.post(userInfo: [Observers.keys.removed_document : self.document])
                            SessionManager.current.setFolders(folders: response?.folders)
                        })
                    }
                })
        }
    }
    
    func versionsAction(){
        guard let document = self.document else{
            return
        }
        let progress = self.parentViewController?.showProgressDialog(title: .versions, message: .empty_string)
        
        ApiClient.document_verions(documentId: document.documentId)
            .execute { (_ response:DocumentVersionBaseClass?, error, statusCode) in
                progress?.dismiss(animated: true, completion: {
                    Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                        let viewController = DocumentVersionsTableViewController(versions: response?.documentVersions ?? [])
                        viewController.title = LocalizedStrings.versions.localizedString()
                        self.presentViewControllerFromBottomSheet(viewController: viewController, trackingScrollView: viewController.tableView)
                    }
                })
        }
    }
    
    func historyAction(){
        guard let document = self.document else{
            return
        }
        let progress = self.parentViewController?.showProgressDialog(title: .history, message: .empty_string)
        ApiClient.document_history(documenId: document.documentId)
            .execute { (_ response:DocumentHistoryBaseClass?, error, statucCode) in
                progress?.dismiss(animated: true, completion: {
                    Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                        let viewController = DocumetHistoryTableViewController(histories: response?.documentHistories ?? [])
                        viewController.title = LocalizedStrings.document_history.localizedString()
                        self.presentViewControllerFromBottomSheet(viewController: viewController, trackingScrollView: viewController.tableView)
                    }
                })
        }
    }
    
    func archiveAction(){
        self.parentViewController?.showAlert(title: LocalizedStrings.archive.localizedString(), message: LocalizedStrings.document_action_archive_message.localizedString(params: ["\(String.init(format: "%011d", document?.documentId ?? 0))"]), actions: [
            (title: LocalizedStrings.yes, handler: ({action in
                print("arşivle")
                let progress = self.parentViewController?.showProgressDialog(title: LocalizedStrings.empty_string, message: LocalizedStrings.archive)
                ApiClient.document_archive(poolId: self.document?.id ?? 0, departmentId: SessionManager.current.loginData?.usersDepartmentsManagementDepartmentId ?? 0, passiveUserId: SessionManager.current.loginData?.passiveUserId ?? 0)
                    .execute(responseBlock: { (_ response:ApiResponse?, error, statusCode) in
                        progress?.dismiss(animated: true, completion: {
                            Utilities.processApiResponse(parentViewController: self.parentViewController!, response: response) {
                                self.parentViewController?.showBasicAlert(title: .archive, message: .operation_successful, okTitle: nil, actionHandler: { (_) in
                                    Utilities.delay(0.5, closure: {
                                        self.parentViewController?.navigationController?.popViewController(animated: true)
                                        Observers.reload_folder.post(userInfo: nil)
                                    })
                                })
                            }
                        })
                    })
            })),
            (title: LocalizedStrings.no, handler: ({action in print("arşivle iptal")}))
            ])
    }
    
    func presentViewControllerFromBottomSheet(viewController:UIViewController, trackingScrollView:UIScrollView){
        let container = MDCAppBarContainerViewController(contentViewController: viewController)
        container.appBarViewController.headerView.trackingScrollView = trackingScrollView
        container.isTopLayoutGuideAdjustmentEnabled = true
        ThemeManager.applyAppBarTheme(appBar: container.appBarViewController)
        let bottomSheet = MDCBottomSheetController(contentViewController: container)
        bottomSheet.trackingScrollView = trackingScrollView
        MDCBottomSheetControllerShapeThemer.applyShapeScheme(self.shapeScheme, to: bottomSheet)
        parentViewController?.present(bottomSheet, animated: true, completion: nil)
    }
}

extension DocumentActionBusinessLogic:InputDialogDelegate{
    
    
    func didTapPositive(dialog: DialogWithInputFieldViewController, text: String?) {
        if text?.count ?? 0 > 0 {
            dialog.dismiss(animated: true) {
                if dialog.mainTitle.elementsEqual(LocalizedStrings.reject.localizedString()){
                    self.performReject(message: text!)
                }else if dialog.mainTitle.elementsEqual(LocalizedStrings.give_back.localizedString()){
                    self.performGiveBackAction(message: text!)
                }
            }
        }else{
            if dialog.mainTitle.elementsEqual(LocalizedStrings.give_back.localizedString()){
                self.parentViewController?.showBasicAlert(title: LocalizedStrings.give_back, message: LocalizedStrings.give_back_empty_desc_error, okTitle: .ok, actionHandler: nil)
            }
        }
    }
    
    func didTapNegative(dialog: DialogWithInputFieldViewController) {
        print("did tap negative")
        dialog.dismiss(animated: true, completion: nil)
    }
}
