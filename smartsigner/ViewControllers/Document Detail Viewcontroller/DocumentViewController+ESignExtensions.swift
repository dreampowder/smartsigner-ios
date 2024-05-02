//
//  DocumentViewController+ESignExtensions.swift
//  smartsigner
//
//  Created by Serdar Coskun on 15.12.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
class DocumentViewController_ESignExtensions: NSObject {

}

extension DocumentViewController{ //ArkSigner Tamamlama işlemleri
    @objc func didReceiveArkSignerCompleteNotification(notification:Notification){
        guard let guid = notification.userInfo?[Observers.keys.sign_queue_guid.rawValue] as? String, let action = notification.userInfo?[Observers.keys.ark_signer_action.rawValue] as? String, (action == "singledocument" || action == "workflow")  else{
            return
        }
        if action == "singledocument"{
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.documentActionBL?.checkArkSignerItemStatus(setId: guid)
            }
        }else if action == "workflow"{
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.documentActionBL?.resumeWorkFlow(workflowInstanceId: self.workFlowsignData?.workFlowInstanceId ?? 0, workflowActionId: self.workFlowsignData?.workFlowActionId ?? 0, poolId: self.workFlowsignData?.poolId ?? 0)
            }
        }
    }
}

extension DocumentViewController:ESignCompleterDelegate{
    func didSelectCertificate(withSerialNumber serialNumber: String, andWithPinCode pinCode: String, andWithIdentity identity: String) {
        print("this code  shouldn't be runing!")
    }
    
    @objc func createESignPackage(withCertificateData certificateData:String, completion:@escaping(_ packageSummaryBytes:String?)->Void){
        guard let content = self.documentContent else{
            completion(nil)
            return
        }
        var dialog:WFProgressDialogViewController? = WFProgressDialogViewController(title: nil, message: nil)
        if !certificateData.elementsEqual("<mobile_sign>") {
            dialog = showProgressDialog(title: LocalizedStrings.empty_string, message: LocalizedStrings.e_sign)
        }
        
        if let signData = self.workFlowsignData{ //WorkFlow
            ApiClient.document_workflow_sign_action_start(workflowInstanceId: signData.workFlowInstanceId, workflowActionId: signData.workFlowActionId, poolId: signData.poolId, documentId: signData.documentId,certificateData:certificateData,isMobileSign: false )
                .execute { (_ response:WorkFlowSignPackageStartResponse?, error, statusCode) in
                    if let base64 = response?.dataAsBase64{
                        self.workFlowsignData?.operationGuid = response?.operationGuid ?? ""
                        completion(base64)
                    }else{
                        completion(nil)
                    }
            }
        }else{
            ApiClient.e_sign_create_package(document: content,certificateData: certificateData, isMobileSign: (certificateData == "<mobile_sign>"))
                .execute { (_ r:ESignPackageResponse?, error, statusCode) in
                    dialog?.dismiss(animated: true, completion: nil)
                    guard let response = r else{
                        completion(nil)
                        return
                    }
                    self.eSignCreatePackageResponse = response
                    self.completeSignData = CompleteSignData(document: content, createPackageResponse: response)
                    guard let summaryBytes = self.completeSignData?.paketOzetiBytes else{
                        completion(nil)
                        return
                    }
                    completion(summaryBytes)
            }
        }
    }
    
    @objc func completeSigning(withBase64String base64String:String, completition:@escaping(_ success:Bool,_ errorContent:String?)->Void){
        self.completeSigning(withBase64String: base64String, isMobileSign: false, completition: completition)
    }
    
    @objc func completeSigning(withBase64String base64String:String,isMobileSign:Bool, completition:@escaping(_ success:Bool,_ errorContent:String?)->Void){
        if let _ = self.workFlowsignData{
                completition(true,"workflow_action")
        }else{
            var completeReq = CompleteSignDataRequest(fromDictionary: self.completeSignData?.dictionaryValue() ?? [:])
            completeReq.signedDataAsString = base64String
            completeReq.documentId = document?.documentId
            completeReq.operationGuid = completeSignData?.operationGuid
            completeReq.isSignature = completeSignData?.isSignature
            completeReq.isMobileSign = isMobileSign
            
            ApiClient.e_sign_complete_signing(completeRequest: completeReq)
                .execute { (_ response:FolderListResponse?, error, statusCode) in
                    if response?.errorContent() == nil, let folders = response?.folders{
                        if let document = self.document, folders.count > 0{
                            SessionManager.current.setFolders(folders: folders)
                            Observers.document_remove.post(userInfo: [Observers.keys.removed_document : document])
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        completition(response?.errorContent() == nil, response?.errorContent())
                    }else{
                        completition(false,response?.errorContent())
                    }
            }
        }
    }
    
    @objc func continueWorkFlow(withBase64String base64String:String){
        guard let signData = self.workFlowsignData else{
            return
        }
        self.documentActionBL?.endSigningServerPackage(signDataBase64: base64String, documentId: signData.documentId, workFlowActionId: signData.workFlowActionId, workFlowInstanceId: signData.workFlowInstanceId, poolId: self.document?.id ?? 0,operationGuid: signData.operationGuid,isMobileSign:signData.isMobileSign)
    }
    
    func viewController(_ viewController: ESignViewController, signingCompleteWithSuccess success: Bool, andWithMessage message: String) {
           print("😓 This shouldn't be here! Error: \(title) - \(message)")
    }
}
