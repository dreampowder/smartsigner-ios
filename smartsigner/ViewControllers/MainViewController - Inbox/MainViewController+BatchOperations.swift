//
//  MainViewController+BatchOperations.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 11.11.2019.
//  Copyright © 2019 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftUI


extension MainViewController{

    func setupForBatchOperations(){
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressOnTableView(sender:)))
        self.tableView?.addGestureRecognizer(longPressGR)
    }
    
    @objc func didLongPressOnTableView(sender:UILongPressGestureRecognizer){
        
        guard sender.state == .began, self.tableViewState.isNormal(),
            let indexPath = self.tableView?.indexPathForRow(at: sender.location(in: self.tableView))
            else{
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                return}
        let batchType:BatchOperationType = BatchOperationType.getBatchType(poolTypeEnum: folderContents[indexPath.row].poolTypeEnumNameAsString)
        if(batchType != .none){
            self.selectedIndexPathsForBatch.append(indexPath)
            self.switchTableViewState(state: .batch(batchType: batchType))
        }
    }
    
    func switchTableViewState(state:MainTableViewState){
        self.tableViewState = state
        self.tableView?.reloadSections(IndexSet(integer: 0), with: .automatic)
        if state.isNormal(){
            self.selectedIndexPathsForBatch.removeAll()
        }
        updateBatButtonItemsForBatch()
    }
    
    func updateBatButtonItemsForBatch(){
        switch self.tableViewState{
        case .normal:
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem =
                    UIBarButtonItem(image: UIImage(awesomeType: .search, size: 10, textColor: .white), style: .done, target: self, action: #selector(self.showSearchViewController))
                self.navigationItem.leftBarButtonItem =
                    UIBarButtonItem(image: UIImage(awesomeType: .bars, size: 10, textColor: .white), style: .done, target: self, action: #selector(self.revealSideMenu))
            }
            
        case .batch(let batchType):
            let barBtnCancel = UIBarButtonItem(title: LocalizedStrings.cancel.localizedString(), style: .done, target: self, action: #selector(didTapCancelBatchBarButton(sender:)))
            var buttonTitle = "";
            switch batchType {
            case .confirm:
                buttonTitle = LocalizedStrings.confirm.localizedString()
            case.sign:
                buttonTitle = LocalizedStrings.sign.localizedString()
            case .transfer:
                buttonTitle = LocalizedStrings.transfer.localizedString()
            default:
                buttonTitle = ""
            }
            let barBtnAction = UIBarButtonItem(title: "\(buttonTitle) \(self.selectedIndexPathsForBatch.count > 0 ? "(\(self.selectedIndexPathsForBatch.count))" : "")", style: .done, target: self, action: #selector(didTapBatchOperationButton(sender:)))
            barBtnAction.isEnabled = self.selectedIndexPathsForBatch.count > 0
            DispatchQueue.main.async {
                self.navigationItem.leftBarButtonItem = barBtnAction
                self.navigationItem.rightBarButtonItem = barBtnCancel
            }
            
        }
    }
    
    @objc func didTapCancelBatchBarButton(sender:UIBarButtonItem){
        switchTableViewState(state: .normal)
    }
    
    @objc func didTapBatchOperationButton(sender:UIBarButtonItem){
        self.batchOperationViewController = nil
        if case MainTableViewState.batch(let batchType) = tableViewState{
            switch batchType{
                case .transfer:
                    let documents:[PoolItem] = self.selectedIndexPathsForBatch.map({self.folderContents[$0.row]})
                    let vc = TransferDocumentViewController(documents: documents)
                    self.navigationController?.pushViewController(vc, animated: true)
                case .sign:
                    
                    var actions:[(title:LocalizedStrings,handler:MDCActionHandler?)] = [(title: LocalizedStrings.alert_message_sign_method_e_sign, handler: {(_) in
                        Utilities.checkESignStatus(parentViewControler: self, isLogin: false, eSignMethod: .ark_signer_card) {
                         self.isEsign = true
                            self.startBatchESignoperation()
                        }
                    })]
                    if SessionManager.current.canUseArkSignerApp() {
                        actions.append((title:LocalizedStrings.alert_message_sign_e_sign_app, handler: {(_) in
                            self.signWitArkSignerApp()
                        }))
                    }
                    actions.append((title:LocalizedStrings.alert_message_sign_method_mobile_sign, handler: {(_) in
                        self.isEsign = false
                        self.isBatchSignTypeIsESign = false
                        self.startBatchMobileSignOperation()
                    }))
                
                if selectedIndexPathsForBatch.count > 1 && (SessionManager.current.loginData?.canMultiMobileSign() ?? false) {
                        actions.append((title:LocalizedStrings.alert_message_sign_method_multi_mobile_sign, handler: {(_) in
                            self.isEsign = false
                            self.isBatchSignTypeIsESign = false
                            self.startMultiMobileSignOperation()
                        }))
                    }
                
                    actions.append((title: LocalizedStrings.cancel, handler: nil))
                    actions.reverse()
                    self.showAlert(title: LocalizedStrings.sign, message: LocalizedStrings.alert_message_pick_sign_method, actions:actions)
                case .none:
                    print("No need for an action")
                case .confirm:
                    startBatchConfirmAction()
            }
        }
    }
    
    func signWitArkSignerApp(){
        Utilities.checkESignStatus(parentViewControler: self, isLogin: false, eSignMethod: .ark_signer_app) {
            let documents = self.selectedIndexPathsForBatch.map({self.folderContents[$0.row]})
                    self.selectedDocumentsForBatchArkSigner = documents
                    self.batchOperationViewController = BatchOperationViewController.presentFromBotomSheet(parent: self, documents: documents, operationType: .sign,isArkSignerOperation: true)
                    SessionManager.current.arkSignerSetId = UUID.init().uuidString
                    documents.forEach { (document) in
                        ApiClient.document_details(document: document)
                            .execute { (_ documentContent:DocumentContent?, error, statusCode) in
                                guard self.checkJsonResponse(document: document, response: documentContent), let documentContent = documentContent else{return}
                                ApiClient.create_package_for_sign_queue(poolExtended: documentContent, signingGuid: SessionManager.current.arkSignerSetId ?? "")
                                    .execute { (_ response:FolderListResponse?, error, statusCode) in
                                        if let errorContent = response?.errorContent(){
                                            Observers.batch_operation_progress.post(userInfo: [
                                                Observers.keys.operation_id : document.id ?? 0,
                                                Observers.keys.operation_success: false,
                                                Observers.keys.operation_error_content: errorContent
                                            ])
                                        }else{
                                            Observers.batch_operation_progress.post(userInfo: [
                                                Observers.keys.operation_id : document.id ?? 0,
                                                Observers.keys.operation_success: true,
                                            ])
                                        }
                                        if self.batchOperationViewController?.operations.filter({$0.isInProgress == false}).count == self.selectedIndexPathsForBatch.count{
                                            print("Did Finish Preparing OperationQueue")
                                            ArkSignerHelper.openArkSignerApp(parentVC: self, callbackAction: "batchsign", setId: SessionManager.current.arkSignerSetId ?? "")
                                        }
                                }
                        }
                    }
        }
        
    }
    
    @objc func didReceiveBatchArksignerCompleteNotification(notification:Notification){
        guard let setId = notification.userInfo?[Observers.keys.sign_queue_guid.rawValue] as? String,
            setId == SessionManager.current.arkSignerSetId, let action = notification.userInfo?[Observers.keys.ark_signer_action.rawValue] as? String, action == "batchsign" else{
                print("Not My Set ID");
                return
        }
        let documents = self.selectedDocumentsForBatchArkSigner
        self.batchOperationViewController = BatchOperationViewController.presentFromBotomSheet(parent: self, documents: documents, operationType: .sign,isArkSignerOperation: true)
        self.batchOperationViewController?.willDelayOnSuccess = true
        ApiClient.check_sign_queue_status(signingGuid: setId)
            .execute { (_ response:CheckSignQueueListResponse?, error, statusCode) in
                Utilities.processApiResponse(parentViewController: self, response: response) {
                    if response?.items.count == 0{
                        self.batchOperationViewController?.dismissAndDispose(completion: {
                            AlertDialogFactory.showUnexpectedErrorFromViewController(vc: self) {
                                self.clearBatchOperation()
                            }
                        })
                    }else{
                        response?.items.forEach({ (item) in
                            let status:DigitalSignQueueStatusEnum = DigitalSignQueueStatusEnum(rawValue: item.digitalSignQueueStatusEnum ?? 0) ?? .unknown
                            if status == DigitalSignQueueStatusEnum.completed{
                                Observers.batch_operation_progress.post(userInfo: [
                                    Observers.keys.operation_id : item.entityId ?? 0,
                                    Observers.keys.operation_success: true,
                                ])
                            }else{
                                Observers.batch_operation_progress.post(userInfo: [
                                    Observers.keys.operation_id : item.entityId ?? 0,
                                    Observers.keys.operation_success: false,
                                    Observers.keys.operation_error_content: "\(LocalizedStrings.operation_cancelled.localizedString())\n\(item.errorMessage ?? "")",
                                ])
                            }
                        })
                    }
                }
        }
    }
    
    func didSelectDocumentAtIndexPathForBatchOperation(indexPath:IndexPath){
        let document = folderContents[indexPath.row]
        let documentBatchType = BatchOperationType.getBatchType(poolTypeEnum: document.poolTypeEnumNameAsString)
        if case MainTableViewState.batch(let batchType) = tableViewState{
            if documentBatchType == batchType{
                if let index = self.selectedIndexPathsForBatch.firstIndex(of: indexPath){
                    self.selectedIndexPathsForBatch.remove(at: index)
                }else{
                    self.selectedIndexPathsForBatch.append(indexPath)
                }
                self.tableView?.reloadRows(at: [indexPath], with: .automatic)
                updateBatButtonItemsForBatch()
            }
        }else{
            self.tableView?.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //MARK: Mobil İmza İşlemleri - Başlangıç
    
    func startMultiMobileSignOperation(){
        
        ///OK 1- Eğer türkcell ise çıkması gerek
        ///2- Sim kartının toplu mobil imza destekleyen yeni 128 bit kart olması grekiyor uyarısı çıkması gerekiyor. Eğer kartı değilse imza çalışmayabilir uyarısı gösterilmeli (bir daha gösterme butonu olmalı)
        ///3- işlem giderken loading
        ///4- cevap alınınca da liste gösteriliyor
        ///5- folder refresh
        AlertDialogFactory.showMultiMobileSignSimAlert(vc: self) {
            let documents = self.selectedIndexPathsForBatch.map({self.folderContents[$0.row]})
            let op = SessionManager.current.loginData?.phoneNumbers?.first?.mobileOperator.rawValue ?? 0
            let phone = SessionManager.current.loginData?.phoneNumbers?.first(where: { number in
                number.mobileOperator == .Turkcell
            })
            let items = documents.map { poolItem in
                MultiMobileSignRequestItem(poolItemID: "\(poolItem.id ?? 0)", lastEditDateAsString: poolItem.lastEditDateAsString)
            }
            let req = MultiMobileSignRequest(mobileOperator: (phone?.mobileOperator ?? .Turkcell).rawValue, mobilePhoneNumber: phone?.phoneNumber ?? "", items: items)
            let dialog = self.showProgressDialog(title: LocalizedStrings.empty_string, message: LocalizedStrings.please_wait)
            
            ApiClient.multi_mobile_sign(request: req)
                .execute { (_ resp:MultiMobileSignResponse?, error, statusCode) in
                    self.clearBatchOperation()
                    SessionManager.current.refreshFolders()
                    dialog?.dismiss(animated: true, completion: {
                        guard error == nil else{
                            AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.error.localizedString(), message: error?.localizedDescription ?? "Unhandled multi mobile sign error", doneButtonTitle: nil, doneButtonAction: nil)
                            return
                        }
                        if let responseError = resp?.errorContent(){
                            AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.error.localizedString(), message:responseError, doneButtonTitle: nil, doneButtonAction: nil)
                            return
                        }
                        self.navigationController?.present(
                            UIHostingController(rootView: NavigationView { MultiMobileSignResultScreen(result: resp!).navigationBarTitle(LocalizedStrings.alert_message_sign_method_multi_mobile_sign.localizedString(), displayMode: .inline) }),
                            animated: true
                        )
                    })
                }
        }
        
    }
    
    func startBatchMobileSignOperation(){
        Utilities.checkESignStatus(parentViewControler: self, isLogin: false, eSignMethod: .mobile_sign) {
            let documents = self.selectedIndexPathsForBatch.map({self.folderContents[$0.row]})
            self.batchOperationQueue = self.selectedIndexPathsForBatch.map({BathOperationItem(title: self.folderContents[$0.row].subject,detail:self.folderContents[$0.row].fromSentence, identifier: self.folderContents[$0.row].id, operationType: .sign, isInProgress: true,hasError: false,errorContent: nil) })
            self.batchOperationViewController = BatchOperationViewController.presentFromBotomSheet(parent: self, documents: documents, operationType: .sign)
            self.performBatchMobileSignOperation()
            self.updateBatButtonItemsForBatch()
        }
    }
    
    func performBatchMobileSignOperation(){
        if self.batchOperationQueue.count > 0{
            if let document = self.folderContents.first(where: {$0.id == self.batchOperationQueue[0].identifier}){
                mobileSignSingleDocument(document: document)
            }
        }else{
            print("All Operations Are Complete")
        }
    }
    
    func mobileSignSingleDocument(document:PoolItem){
        guard let _ = self.batchOperationViewController else{return}
        ApiClient.document_details(document: document)
            .execute { (_ documentContent:DocumentContent?, error, statusCode) in
                
                guard self.checkJsonResponse(document: document, response: documentContent), let documentContent = documentContent else{return}
                
                ApiClient.e_sign_create_package(document: documentContent, certificateData: "<mobile_sign>", isMobileSign: true)
                    .execute(responseBlock: { (_ createPackageResponse:ESignPackageResponse?, error, statusCode) in
                        guard self.checkJsonResponse(document: document, response: createPackageResponse) else {return}
                        let completeSignData = CompleteSignData(document: documentContent, createPackageResponse: createPackageResponse!)
                        if completeSignData.paketOzetiBytes == nil{
                            Observers.batch_operation_progress.post(userInfo: [
                                Observers.keys.operation_id : document.id ?? 0,
                                Observers.keys.operation_error_content: LocalizedStrings.sign_smart_card_error_no_sign_data.localizedString()
                                ])
                            self.batchOperationQueue.removeAll(where: {$0.identifier == document.id})
                            self.performBatchMobileSignOperation()
                            self.batchOperationViewController?.discardFingerPrintAlert(completion: {
                                
                            })
                        }else{
                            guard let _ = self.batchOperationViewController else{return}
                        ApiClient.mobile_sign_generate_fingerprint(base64Data: completeSignData.paketOzetiBytes ?? "")
                            .execute(responseBlock: { (_ fingerPrintResponse:MobileSignFingerPrintResponse?, error, statusCode) in
                                guard self.checkJsonResponse(document: document, response: fingerPrintResponse) else {return}
                                self.batchOperationViewController?.showFingerPrintAlert(title: document.subject ?? "", fingerPrint: fingerPrintResponse?.fingerPrint ?? "<null>")
                                var completeReq = CompleteSignDataRequest(fromDictionary: completeSignData.dictionaryValue() )
                                completeReq.signedDataAsString = completeSignData.paketOzetiBytes
                                completeReq.documentId = document.documentId
                                completeReq.operationGuid = completeSignData.operationGuid
                                completeReq.isSignature = completeSignData.isSignature
                                completeReq.isMobileSign = true
                                guard let _ = self.batchOperationViewController else{return}
                                ApiClient.e_sign_complete_signing(completeRequest: completeReq)
                                    .execute(responseBlock: { (_ completeSignResponse:FolderListResponse?, error, statusCode) in
                                        guard self.checkJsonResponse(document: document, response: completeSignResponse) else {return}
                                        SessionManager.current.setFolders(folders: completeSignResponse?.folders)
                                        Observers.document_remove.post(userInfo: [Observers.keys.removed_document : document])
                                        Observers.batch_operation_progress.post(userInfo: [
                                            Observers.keys.operation_id : document.id ?? 0,
                                            Observers.keys.operation_success: true
                                            ])
                                        self.batchOperationQueue.removeAll(where: {$0.identifier == document.id})
                                        self.performBatchMobileSignOperation()
                                    })
                            })
                        }
                    })
            }
    }
    
    func checkJsonResponse(document:PoolItem, response:JsonProtocol?)->Bool{
        
        var hasError = false
        if response == nil || response?.errorContent() != nil{
            hasError = true
        }
        
        if hasError{
            Observers.batch_operation_progress.post(userInfo: [
                Observers.keys.operation_id : document.id ?? 0,
                Observers.keys.operation_success: false,
                Observers.keys.operation_error_content: response?.errorContent() ?? "<unknown>"
                ])
            self.batchOperationQueue.removeAll(where: {$0.identifier == document.id})
            Observers.batch_operation_discard_fingerprint_dialog.post(userInfo: nil)
            self.performBatchMobileSignOperation()
            return false
        }
        return true
    }
    
    //MARK: E-İmza İşlemleri
    func startBatchESignoperation(){
        Utilities.checkESignStatus(parentViewControler: self, isLogin: false, eSignMethod: .ark_signer_card) {
            let documents = self.selectedIndexPathsForBatch.map({self.folderContents[$0.row]})
            self.batchOperationQueue = self.selectedIndexPathsForBatch.map({BathOperationItem(title: self.folderContents[$0.row].subject,detail:self.folderContents[$0.row].fromSentence, identifier: self.folderContents[$0.row].id, operationType: .sign, isInProgress: true,hasError: false,errorContent: nil) })
            if let _ = self.batchOperationViewController{
                self.batchOperationViewController = self.batchOperationViewController?.presentFromBottomSheet(completion: nil)
            }else{
                self.batchOperationViewController = BatchOperationViewController.presentFromBotomSheet(parent: self, documents: documents, operationType: .sign)
            }
            self.performBatchESignOperation()
        }
    }
    
    func performBatchESignOperation(){
        if self.batchOperationQueue.count > 0{
            if let document = self.folderContents.first(where: {$0.id == self.batchOperationQueue[0].identifier}){
                eSignSingleDocument(document: document)
            }
        }else{
            print("All Operations Are Complete")
        }
    }
    
    func eSignSingleDocument(document:PoolItem){
        ApiClient.document_details(document: document)
        .execute { (_ documentContent:DocumentContent?, error, statusCode) in
            guard self.checkJsonResponse(document: document, response: documentContent) else{return}
            self.currentSigningDocument = documentContent
            #if targetEnvironment(simulator)
            print("E-Sign is not supported on simulator")
            #else
            self.isBatchSignTypeIsESign = true
            self.eSignViewcontroller = ESignViewController(parentVC: self, isBatchOperation: true, andWithCertificateSerial: self.batchESignCertSerial, andWithPinCode: self.batchESignPinCode)
            self.eSignViewcontroller?.modalPresentationStyle = .overCurrentContext
            
            self.batchOperationViewController?.dismissAndDispose(completion: {
                self.present(self.eSignViewcontroller!, animated: false, completion: nil)
            })
            #endif
        }
    }
    
    //MARK: Toplu Onaylama İşlemleri
    func startBatchConfirmAction(){
        AlertDialogFactory.showAlertActionDialog(vc: self, title: LocalizedStrings.batch_confirm.localizedString(), message: LocalizedStrings.batch_confirm_question.localizedString(params:["\(self.selectedIndexPathsForBatch.count)"]), actions: [
            MDCAlertAction(title:LocalizedStrings.yes.localizedString(), handler: { (action) in
                    let documents = self.selectedIndexPathsForBatch.map({self.folderContents[$0.row]})
                    self.batchOperationViewController = BatchOperationViewController.presentFromBotomSheet(parent: self, documents: documents, operationType: .confirm)
                documents.forEach(self.performSingleConfirmAction(document:))
            }),
            MDCAlertAction(title:LocalizedStrings.no.localizedString(), handler:nil)
        ])
    }
    
    func performSingleConfirmAction(document:PoolItem){
        //ddMMyyyy
        ApiClient.document_confirm(poolId: document.id ?? 0, documentId: document.documentId, lastEditDate: document.lastEditDate ?? "")
            .execute { (_ response:FolderListResponse?, error, statusCode) in
                if let errorContent = response?.errorContent(){
                    Observers.batch_operation_progress.post(userInfo: [
                        Observers.keys.operation_id : document.id ?? 0,
                        Observers.keys.operation_success: false,
                        Observers.keys.operation_error_content: errorContent
                    ])
                }else{
                    Observers.batch_operation_progress.post(userInfo: [
                        Observers.keys.operation_id : document.id ?? 0,
                        Observers.keys.operation_success: true,
                    ])
                }
        }
    }
}

extension MainViewController:ESignCompleterDelegate{
    
    
    
    
    func didCancelESign() {
    if let poolExtended = currentSigningDocument{
        self.batchOperationViewController?.presentFromBottomSheet(completion: { [weak self] in
                Observers.batch_operation_progress.post(userInfo: [
                    Observers.keys.operation_id : poolExtended.pool.id ?? 0,
                    Observers.keys.operation_success: false,
                    Observers.keys.operation_error_content: LocalizedStrings.operation_cancelled
                ])
                self?.batchOperationQueue.removeAll(where: {$0.identifier == self?.currentSigningDocument?.pool.id ?? 0})
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    self?.performBatchESignOperation()
                }
                
            })
        }
    }
    
    func didSelectCertificate(withSerialNumber serialNumber: String, andWithPinCode pinCode: String, andWithIdentity identity: String) {
        self.batchESignPinCode = pinCode
        self.batchESignCertSerial = serialNumber
    }
    
    
    func viewController(_ viewController: ESignViewController, signingCompleteWithSuccess success: Bool, andWithMessage message: String) {
        viewController.animateDismiss {
            self.batchOperationViewController?.presentFromBottomSheet(completion: { [weak self] in
                Observers.batch_operation_progress.post(userInfo: [
                Observers.keys.operation_id : self?.currentSigningDocument?.pool.id ?? 0,
                Observers.keys.operation_success: success,
                Observers.keys.operation_error_content: message
                ])
                self?.batchOperationQueue.removeAll(where: {$0.identifier == self?.currentSigningDocument?.pool.id ?? 0})
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    self?.performBatchESignOperation()
                }
            })
        }
    }
    
    
    func createESignPackage(withCertificateData certificateData: String, completion: @escaping (String?) -> Void) {
        print("Create ESign Package")
        guard let document = self.currentSigningDocument else {
            completion(nil)
            return
        }
        ApiClient.e_sign_create_package(document: document,certificateData: certificateData, isMobileSign: false)
            .execute { (_ r:ESignPackageResponse?, error, statusCode) in
                guard let response = r else{
                    completion(nil)
                    return
                }
                self.eSignCreatePackageResponse = response
                self.completeSignData = CompleteSignData(document: document, createPackageResponse: response)
                guard let summaryBytes = self.completeSignData?.paketOzetiBytes else{
                    completion(nil)
                    return
                }
                completion(summaryBytes)
        }
    }
    
    func completeSigning(withBase64String base64String: String, completition: @escaping (Bool, String?) -> Void) {
        self.completeSigning(withBase64String: base64String, isMobileSign: false, completition: completition)
    }
    
    func completeSigning(withBase64String base64String: String, isMobileSign: Bool, completition: @escaping (Bool, String?) -> Void) {
        var completeReq = CompleteSignDataRequest(fromDictionary: self.completeSignData?.dictionaryValue() ?? [:])
        completeReq.signedDataAsString = base64String
        completeReq.documentId = currentSigningDocument?.pool.documentId
        completeReq.operationGuid = completeSignData?.operationGuid
        completeReq.isSignature = completeSignData?.isSignature
        completeReq.isMobileSign = isMobileSign
        ApiClient.e_sign_complete_signing(completeRequest: completeReq)
        .execute { (_ response:FolderListResponse?, error, statusCode) in
            if response?.errorContent() == nil{
                if let documentContent = self.currentSigningDocument, let document = self.folderContents.first(where: {$0.id == documentContent.pool.id}){
                    Observers.document_remove.post(userInfo: [Observers.keys.removed_document : document])
                }
                if let folders = response?.folders , folders.count > 0{
                    SessionManager.current.setFolders(folders: folders)
                }
                completition(response?.errorContent() == nil && response?.errorCode == nil, response?.errorContent())
            }else{
                completition(false,response?.errorContent())
            }
        }
    }
    
    func continueWorkFlow(withBase64String base64String: String) {
        print("continue workflow")
    }
}

extension MainViewController:BatchOperationDelegate{
    
    func didFinishAllOperations(viewController: BatchOperationViewController, isAllSuccess: Bool) {
        Observers.batch_operation_discard_fingerprint_dialog.post(userInfo: nil)
        viewController.dismissAndDispose {
            self.batchESignCertSerial = nil
                        self.batchESignPinCode = nil
                        self.batchESignCertSerial = nil
                        self.eSignCreatePackageResponse = nil
                        self.currentSigningDocument = nil
                        self.completeSignData = nil
                        if isAllSuccess {
                            var title:String = LocalizedStrings.success.localizedString()
                            var message:String = ""
                            switch(viewController.operationType ?? .none){
                                case .sign:
                                    title = LocalizedStrings.batch_sign.localizedString()
                                    message = LocalizedStrings.batch_sign_success.localizedString()
                                case .confirm:
                                    title = LocalizedStrings.batch_confirm.localizedString()
                                    message = LocalizedStrings.batch_confirm_success.localizedString()
                                default:
                                    break
                            }
                            if viewController.isArkSignerOperation{
                                self.clearBatchOperation()
                                if viewController.willDelayOnSuccess {
                                    AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: title, message: message, doneButtonTitle: nil) {
            //                            self.clearBatchOperation()
                                    }
                                }
            //                    SessionManager.current.refreshFolders()
                            }else{
                                AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: title, message: message, doneButtonTitle: nil) {
                                    self.clearBatchOperation()
                                    SessionManager.current.refreshFolders()
                                }
                            }
                        }else{
                            self.clearBatchOperation()
                        }
        }
    }
    
    func clearBatchOperation(){
        self.batchESignPinCode = nil
        self.batchESignCertSerial = nil
        self.eSignViewcontroller = nil
        self.batchOperationViewController = nil
        self.switchTableViewState(state: .normal)
        if let folder = self.selectedFolder{
            SessionManager.current.refreshFolders()
            self.resetPage(animated: true)
            self.loadFolderContents(folder: folder)
        }
    }
    
    func didTapRetryOperation(viewController: BatchOperationViewController, id: Int) {
        guard let document = self.folderContents.first(where: {$0.id == id})else{
            if id == -1 { //Arksigner uygulaması belge retry işlemi olduğu için kalan belgeleri toplu retry etmemiz gerekiyor
                let incompleteOperationIds = viewController.operations.filter({$0.hasError == true}).map({$0.identifier})
                var indexPaths = [IndexPath]()
                self.folderContents.filter({incompleteOperationIds.contains($0.id)}).forEach { (item) in
                    if let index = self.folderContents.firstIndex(where: { (poolItem) -> Bool in
                        return poolItem.id == item.id
                    }){
                        indexPaths.append(IndexPath(row: index, section: 0))
                    }
                }
                self.selectedIndexPathsForBatch = indexPaths
                self.tableView?.reloadData()
                viewController.dismissAndDispose(completion: {
                    self.signWitArkSignerApp()
                })
            }
            return
        }
        let batchType:BatchOperationType = BatchOperationType.getBatchType(poolTypeEnum: document.poolTypeEnumNameAsString)
        switch batchType{
            case .sign:
                isEsign ? eSignSingleDocument(document: document) : mobileSignSingleDocument(document: document)
            case .confirm:
                performSingleConfirmAction(document: document)
            default:
                print("❌ Unsupported retry action:\(document.id) \(batchType)")
        }
    }
    
    func cancelRemainingOperations() {
        ApiClient.cancelAllRequests { () -> Void? in
            DispatchQueue.main.async {
                self.batchESignCertSerial = nil
                self.batchESignPinCode = nil
                self.batchESignCertSerial = nil
                self.eSignCreatePackageResponse = nil
                self.currentSigningDocument = nil
                self.completeSignData = nil
                self.selectedIndexPathsForBatch = []
                self.switchTableViewState(state: .normal)
                self.batchOperationViewController = nil
                if let folder = self.selectedFolder{
                    self.didSelectFolder(folder: folder)
                }
                SessionManager.current.refreshFolders()
            }
            return nil
        }
    }
}
