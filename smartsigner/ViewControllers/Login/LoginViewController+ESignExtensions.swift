//
//  LoginViewController+ESignExtensions.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 17.12.2019.
//  Copyright © 2019 Seneka. All rights reserved.
//

import UIKit

extension LoginViewController {
    func beginESigLogin(){
        Utilities.checkESignStatus(parentViewControler: self, isLogin: true, eSignMethod: .ark_signer_card) {
            #if targetEnvironment(simulator)
                print("E-Sign is not supported on simulator")
            #else
            SessionManager.current.serviceData = self.selectedCompany
                self.eSignViewcontroller = ESignViewController(parentVC: self)
                self.eSignViewcontroller?.modalPresentationStyle = .overCurrentContext
                self.present(self.eSignViewcontroller!, animated: false, completion: nil)
            #endif
        }
        
    }
    
    func beginArkSignerLogin(){
        Utilities.checkESignStatus(parentViewControler: self, isLogin: true, eSignMethod: .ark_signer_app) {
            self.toggleLoadingView(isVisible: false)
                    SessionManager.current.arkSignerSetId = UUID().uuidString
                    ApiClient.init_login_e_sign(username: "", certificateDate: "", isReadOnly: false, setId: SessionManager.current.arkSignerSetId)
                        .execute { (_ response:ESignLoginResponse?, error, status) in
                            Utilities.processApiResponse(parentViewController: self, response: response) {
                                ArkSignerHelper.openArkSignerApp(parentVC: self, callbackAction: "login", setId: SessionManager.current.arkSignerSetId ?? "")
                            }
                    }
        }
        
    }
    
    @objc func didReceiveArksignerLoginNotification(notification:Notification){
        guard let setId = notification.userInfo?[Observers.keys.sign_queue_guid.rawValue] as? String,
            setId == SessionManager.current.arkSignerSetId, let action = notification.userInfo?[Observers.keys.ark_signer_action.rawValue] as? String, action == "login" else{
                print("Not My Set ID for login");
                return
        }
        toggleLoadingView(isVisible: true)
        if SessionManager.current.serviceData == nil {
            SessionManager.current.serviceData = selectedCompany
        }
        ApiClient.login_e_sign(username: "", eSignedData: "", transactionUUID: "", isReadOnly: false,setId: SessionManager.current.arkSignerSetId)
            .execute { (_ response:LoginResponse?, error, statusCode) in
                if statusCode == 200{
                    if let errorMessage = response?.exceptionMessage{
                        self.toggleLoadingView(isVisible: false)
                        AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.error.localizedString(), message: errorMessage, doneButtonTitle: nil, doneButtonAction: nil)
                    }else{
                        if let loginData = response{
                            if loginData.delegationPrompt != nil && loginData.delegationPrompt.count > 0{
                                self.showDelegateAlertForLogin(loginData: loginData)
                                return;
                            }
                            SessionManager.current.loginType = .e_sign_app
                            self.performSuccessfullLoginActions(loginData: loginData,isReadOnly: false,loginType: .e_sign_app)
                        }else{
                            self.toggleLoadingView(isVisible: false)
                            AlertDialogFactory.showUnexpectedErrorFromViewController(vc: self, doneButtonAction: nil)
                        }
                    }
                }else{
                    self.toggleLoadingView(isVisible: false)
                    if statusCode == 400{
                        AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.error.localizedString(), message: "Kullanıcı adı veya parolası hatalı", doneButtonTitle: nil, doneButtonAction: nil)
                        return
                    }else{
                        AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.error.localizedString(), message: LocalizedStrings.error_unexpected.localizedString(), doneButtonTitle: nil, doneButtonAction: nil)
                        return
                    }
                }
        }
    }
}

extension LoginViewController:ESignCompleterDelegate {
    func didSelectCertificate(withSerialNumber serialNumber: String, andWithPinCode pinCode: String, andWithIdentity identity: String) {
        self.eSignUserTCKN = identity
    }
    
    func createESignPackage(withCertificateData certificateData: String, completion: @escaping (String?) -> Void) {
        ApiClient.init_login_e_sign(username: self.eSignUserTCKN ?? "", certificateDate: certificateData, isReadOnly: false, setId: nil)
            .execute { (_ response:ESignLoginResponse?, error, status) in
                guard let response = response else{
                    print("Error generating e-sign login")
                    completion(nil)
                    return
                }
                if let errorContent = response.errorContent() {
                    self.eSignViewcontroller?.dismiss(animated: true, completion: {
                        self.showBasicAlert(title: LocalizedStrings.error.localizedString(), message: errorContent, okTitle: nil, actionHandler: nil)
                    })
                }else{
                    self.eSignTransactionUUID = response.transactionUuid ?? ""
//                    let data = response.digest.withUnsafeBufferPointer({Data(buffer: $0)})
//                    completion(data.base64EncodedString())
                    completion(response.digestAsBase64) //13.04.2020 DigestAsBase64 Parametresi eklendi
                }
        }
    }
    
    func completeSigning(withBase64String base64String: String, completition: @escaping (Bool, String?) -> Void) {
        ApiClient.login_e_sign(username: self.eSignUserTCKN ?? "", eSignedData: base64String, transactionUUID: self.eSignTransactionUUID ?? "", isReadOnly: false,setId: nil)
            .execute { (_ response:LoginResponse?, error, statusCode) in

                print("TCKN \(self.eSignUserTCKN ?? ""), uuid: \(self.eSignTransactionUUID ?? "")")
                self.eSignViewcontroller?.dismiss(animated: true, completion: {
                    if statusCode == 200{
                        if let errorMessage = response?.exceptionMessage{
                            self.toggleLoadingView(isVisible: false)
                            AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.error.localizedString(), message: errorMessage, doneButtonTitle: nil, doneButtonAction: nil)
                        }else{
                            if let loginData = response{
                                if loginData.delegationPrompt != nil && loginData.delegationPrompt.count > 0{
                                    self.showDelegateAlertForLogin(loginData: loginData)
                                    return;
                                }
                                self.performSuccessfullLoginActions(loginData: loginData,isReadOnly: false,loginType: .username)
                            }else{
                                self.toggleLoadingView(isVisible: false)
                                AlertDialogFactory.showUnexpectedErrorFromViewController(vc: self, doneButtonAction: nil)
                            }
                        }
                    }else{
                        self.toggleLoadingView(isVisible: false)
                        if statusCode == 400{
                            AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.error.localizedString(), message: "Kullanıcı adı veya parolası hatalı", doneButtonTitle: nil, doneButtonAction: nil)
                            return
                        }else{
                            AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.error.localizedString(), message: LocalizedStrings.error_unexpected.localizedString(), doneButtonTitle: nil, doneButtonAction: nil)
                            return
                        }
                    }
                })
        }
    }
    
    func completeSigning(withBase64String base64String: String, isMobileSign: Bool, completition: @escaping (Bool, String?) -> Void) {
        print("Code shouldn't be here!")
    }
    
    func continueWorkFlow(withBase64String base64String: String) {
        print("Code shouldn't be here!")
    }
    
    func viewController(_ viewController: ESignViewController, signingCompleteWithSuccess success: Bool, andWithMessage message: String) {
        
    }
}
