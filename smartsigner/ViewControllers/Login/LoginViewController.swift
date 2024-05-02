//
//  LoginViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 20.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
import NVActivityIndicatorView
import Kingfisher
import LocalAuthentication
import FirebaseMessaging


protocol LoginDelegate: AnyObject {
    func userDidLoginWithData(loginData:LoginResponse)
    func performPostLoginActions()
}

//uname ebysdestek
//pass y54chT5Q

class LoginViewController: UIViewController {

    @IBOutlet weak var imgCompanyLogo:UIImageView?
    @IBOutlet weak var lblCompanyName:UILabel?
    @IBOutlet weak var lblSelectService:UILabel?
    @IBOutlet weak var viewMainContainer:MDCShadowView?
    @IBOutlet weak var viewLogoContainer:MDCShadowView?
    @IBOutlet weak var viewActivityContainer:UIView?
    @IBOutlet weak var txtUserName:MDCTextField?
    @IBOutlet weak var txtPassword:UITextField?
    @IBOutlet weak var btnToggleLoginType:MDCButton?
    @IBOutlet weak var btnLogin:MDCButton?
    @IBOutlet weak var btnUsernameLogin:MDCButton?
    @IBOutlet weak var btnMobileLogin:MDCButton?
    @IBOutlet weak var btnESignLogin:MDCButton?
    @IBOutlet weak var btnFastLogin:MDCButton?
    @IBOutlet weak var layoutLoginTypeTop:NSLayoutConstraint?
    @IBOutlet weak var layoutPasswordFieldTop:NSLayoutConstraint?
    @IBOutlet weak var activityIndicatorView:NVActivityIndicatorView?
    @IBOutlet weak var lblVersionNumber:UILabel?
    
    
    var floatingTextfieldControllers:[MDCTextInputControllerUnderline] = []
    
    var serviceArray:[ServiceData] = []
    var isMobileLogin = false
    
    var didLayoutSubviews = false
    
    var selectedCompany:ServiceData?
    
    weak var loginDelegate:LoginDelegate?
    
    var isPerformingLogin = false

    var eSignViewcontroller:ESignViewController?
    var eSignUserTCKN:String?
    var eSignTransactionUUID:String?
    
    deinit {
        Observers.did_complete_ark_signer_sign.removeObserver(observer: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtPassword?.delegate = self
//        self.txtUserName?.delegate = self
        
        self.view.backgroundColor = UIColor.primaryColor
            if let lastSelectedCompanyDict = UserDefaultsManager.last_selected_company.getDefaultsValue() as? [String:Any]{
                self.selectedCompany = ServiceData(fromDictionary: lastSelectedCompanyDict, willDecrypt: false)
                SessionManager.current.serviceData = self.selectedCompany
                self.updateCompanyFields()
            }
            if let bundle = Utilities.getBundleType(), bundle == .sanayi{
                self.updateCompanyFields()
            }
        
        if let lastUsername = UserDefaultsManager.last_login_username.getDefaultsValue() as? String{
            self.txtUserName?.text = lastUsername
        }
        self.lblSelectService?.textColor = .black
        
        Observers.did_complete_ark_signer_sign.addObserver(observer: self, selector: #selector(didReceiveArksignerLoginNotification(notification:)))
        
        txtUserName?.text = "ebysdestek"
        txtPassword?.text = "OB73w2eN"
        //txtUserName?.text = "tolga.test"
        //txtPassword?.text = "acBeuEmh"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchServiceDataArray()
    }
    
    
    @IBAction func didTapFastLogin(){
        guard let fastLoginData = UserDefaultsManager.fast_login_data.getDefaultsValue() as? String else{
            showBasicAlert(title: LocalizedStrings.btn_fast_login, message: LocalizedStrings.fast_login_alert_not_set_message, okTitle: .ok, actionHandler: nil)
            return
        }
        
        if self.isMobileLogin {
            self.isMobileLogin = false
            self.updateLoginForm { () -> (Void) in
                self.showBiometricLoginAlert(fastLoginData: fastLoginData)
            }
        }else{
            self.showBiometricLoginAlert(fastLoginData: fastLoginData)
        }
    }
    
    func showBiometricLoginAlert(fastLoginData:String){
        let context = LAContext()
        var authError: NSError?
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: LocalizedStrings.fast_login_sign_description.localizedString()) { (success, error) in
                DispatchQueue.main.async {
                    if success{
                        let decrypted = fastLoginData
                        if  let data = decrypted.data(using: String.Encoding.utf8),
                            let dict = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]) as [String : Any]??),
                            let companyDict = dict?["company"] as? [String:Any],
                            let username = dict?["username"] as? String,
                            let pwd = dict?["pwd"] as? String{
                            
                            self.txtUserName?.text = username
                            self.txtPassword?.text = pwd
                            self.selectedCompany = ServiceData(fromDictionary: companyDict, willDecrypt: false)
                            self.updateCompanyFields()
                            self.didTapLoginButton(sender:self.btnFastLogin!)
                        }else{
                            UserDefaultsManager.fast_login_data.clearValue()
                            AlertDialogFactory.showUnexpectedErrorFromViewController(vc: self, doneButtonAction: nil)
                        }
                    }
                }
            }
        }else if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &authError) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: LocalizedStrings.fast_login_sign_description.localizedString()) { (success, error) in
                DispatchQueue.main.async {
                    if success{
                        let decrypted = fastLoginData
                        if  let data = decrypted.data(using: String.Encoding.utf8),
                            let dict = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]) as [String : Any]??),
                            let companyDict = dict?["company"] as? [String:Any],
                            let username = dict?["username"] as? String,
                            let pwd = dict?["pwd"] as? String{
                            
                            self.txtUserName?.text = username
                            self.txtPassword?.text = pwd
                            self.selectedCompany = ServiceData(fromDictionary: companyDict, willDecrypt: false)
                            self.updateCompanyFields()
                            self.didTapLoginButton(sender:self.btnFastLogin!)
                        }else{
                            UserDefaultsManager.fast_login_data.clearValue()
                            AlertDialogFactory.showUnexpectedErrorFromViewController(vc: self, doneButtonAction: nil)
                        }
                    }
                }
            }
        }
        else{
            print("not supported")
        }
    }
    
    @IBAction func didTapToggleLoginTypeButton(){
        self.isMobileLogin = !self.isMobileLogin
        self.toggleLoginType(isMobileLogin: isMobileLogin)
    }
    
    func toggleLoginType(isMobileLogin:Bool){
        self.isMobileLogin = isMobileLogin
        self.txtUserName?.text = ""
        self.txtPassword?.text = ""
        
        self.txtUserName?.keyboardType = self.isMobileLogin ? .numberPad : .default
        
        self.updateLoginForm()
    }
    
    @IBAction func didTapLoginButton(sender:MDCButton){
        
        var errorMsg:String?
        if selectedCompany == nil{
            errorMsg = LocalizedStrings.login_error_must_enter_company_code.localizedString()
        }else if txtUserName?.text?.count == 0{
            errorMsg = LocalizedStrings.login_error_must_enter_username.localizedString()
        }else if txtPassword?.text?.count == 0 && !self.isMobileLogin{
            errorMsg = LocalizedStrings.login_error_must_enter_password.localizedString()
        }
        if self.isMobileLogin && !ObjCUtils.isTurkishIdentityValid(self.txtUserName?.text ?? ""){
            errorMsg = LocalizedStrings.login_error_turkish_identity_wrong.localizedString()
        }
        if let _ = errorMsg{
            AlertDialogFactory.showBasicAlertFromViewController(vc: self,
                                                                title: LocalizedStrings.error.localizedString(),
                                                                message: errorMsg!,
                                                                doneButtonTitle: LocalizedStrings.ok.localizedString(),
                                                                doneButtonAction: nil)
            return
        }
        
        SessionManager.current.serviceData = selectedCompany
        guard let username = txtUserName?.text,let password = txtPassword?.text else{
                return
        }
        doLogin(username: username, password: password, isReadOnly: false)
    }
    
    func doLogin(username:String,password:String, isReadOnly:Bool){
        self.toggleLoadingView(isVisible: true)
        
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        
        let loginText = LocalizedStrings.login_mobile_sign_text.localizedString(params: [df.string(from: Date()),selectedCompany?.projectName ?? "EBYS"])
        
        let action:ApiClient = !self.isMobileLogin ?  ApiClient.login(username: username, password: password,isReadOnly:isReadOnly) : ApiClient.login_mobile(username: username, password: password, loginText: loginText,isReadOnly:isReadOnly)
        
        
        var progress:WFProgressDialogViewController?
        if isMobileLogin{
            progress = showProgressDialog(title: LocalizedStrings.login_type_mobile.localizedString(), message: loginText,isIndeterminate: true)
        }
        
        action.execute { (_ response:LoginResponse?, error, statusCode) in
            progress?.dismiss(animated: true, completion: nil)
            
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
                        self.performSuccessfullLoginActions(loginData: loginData,isReadOnly: isReadOnly,loginType: self.isMobileLogin ? .mobile_sign : .username)
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
    
    func showDelegateAlertForLogin(loginData:LoginResponse){
        if loginData.canUseReadOnly {

            AlertDialogFactory.showAlertActionDialog(vc: self, title: LocalizedStrings.warning.localizedString(), message: loginData.delegationPrompt, actions:
            [
                MDCAlertAction(title: LocalizedStrings.end_delegation.localizedString(), handler: { (_) in
                    var newLoginData = loginData
                    newLoginData.unencryptedPass = self.isMobileLogin ? "123" :  self.txtPassword?.text ?? "";
                    newLoginData.deactivateDelegationUsername = self.txtUserName?.text ?? ""
                    
                    ApiClient.deactivate_delegation(loginResponse: newLoginData).execute(responseBlock: { (_ response:DeactivateDelegateResponse?, error, statusCode) in
                        self.toggleLoadingView(isVisible: false)
                        if response?.isSuccess ?? false{
                            AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.info.localizedString(), message: response?.promptText ?? LocalizedStrings.deactivate_delegate_success.localizedString(), doneButtonTitle: nil, doneButtonAction: {
                                self.didTapLoginButton(sender: self.btnLogin!)
                            })
                        }else{
                            AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.warning.localizedString(), message: response?.promptText ?? LocalizedStrings.error_unexpected.localizedString(), doneButtonTitle: nil, doneButtonAction: nil)
                        }
                    })
                }),
                MDCAlertAction(title: LocalizedStrings.login_as_readonly.localizedString(), handler: { (_) in
                    guard let username = self.txtUserName?.text, let password = self.txtPassword?.text else{
                        self.toggleLoadingView(isVisible: false)
                        return
                    }
                    self.doLogin(username: username, password: password, isReadOnly: true)
                }),
                MDCAlertAction(title: LocalizedStrings.cancel.localizedString(), handler: { (_) in
                    self.toggleLoadingView(isVisible: false)
                })
            ])
        }else{
            AlertDialogFactory.showAlertActionDialog(vc: self, title: LocalizedStrings.warning.localizedString(), message: loginData.delegationPrompt, actions:
            [
                MDCAlertAction(title: LocalizedStrings.yes.localizedString(), handler: { (_) in
                    var newLoginData = loginData
                    newLoginData.unencryptedPass = self.isMobileLogin ? "123" :  self.txtPassword?.text ?? "";
                    newLoginData.deactivateDelegationUsername = self.txtUserName?.text ?? ""
                    
                    ApiClient.deactivate_delegation(loginResponse: newLoginData).execute(responseBlock: { (_ response:DeactivateDelegateResponse?, error, statusCode) in
                        self.toggleLoadingView(isVisible: false)
                        if response?.isSuccess ?? false{
                            AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.info.localizedString(), message: response?.promptText ?? LocalizedStrings.deactivate_delegate_success.localizedString(), doneButtonTitle: nil, doneButtonAction: {
                                self.didTapLoginButton(sender: self.btnLogin!)
                            })
                        }else{
                            AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.warning.localizedString(), message: response?.promptText ?? LocalizedStrings.error_unexpected.localizedString(), doneButtonTitle: nil, doneButtonAction: nil)
                        }
                    })
                }),
                MDCAlertAction(title: LocalizedStrings.cancel.localizedString(), handler: { (_) in
                    self.toggleLoadingView(isVisible: false)
                })
            ])
        }
        
    }
    
    func performSuccessfullLoginActions(loginData:LoginResponse,isReadOnly:Bool, loginType:SessionManager.LoginType){
        var mutableLoginData = loginData
        if isReadOnly {
            mutableLoginData.ntUserName = "#RO#"
        }
        SessionManager.current.loginData = mutableLoginData
        SessionManager.current.startRefreshTimer()
        SessionManager.current.rawpw = self.txtPassword?.text?.data(using: String.Encoding.utf8)
        SessionManager.current.loginType = loginType
        ApiClient.delegate_confirue
            .execute(responseBlock: { (_ config:DelegateConfigurationResponse?, error, statusCode) in
                SessionManager.current.delegateConfig = config
                if let lastSelectedComp = self.selectedCompany{
                    UserDefaultsManager.last_selected_company.setDefaultValue(value: lastSelectedComp.toDictionary())
                }
                
                if !self.isMobileLogin{
                    UserDefaultsManager.last_login_username.setDefaultValue(value: self.txtUserName?.text ?? "")
                }
                
                self.loginDelegate?.userDidLoginWithData(loginData: loginData)
                self.toggleLoadingView(isVisible: false)
                self.checkAndShowFastLoginAlert(loginType: loginType)
            })
        var willSendPushToken = true
        if let list = UserDefaultsManager.push_block_list.getDefaultsValue() as? [Int]{
            willSendPushToken = (list.contains(SessionManager.current.loginData?.loggedUserId ?? -1) == false)
        }
        if willSendPushToken{
            Messaging.messaging().token { token, error in
                if let error = error {
                  print("Error fetching remote instance ID: \(error)")
                } else if let token = token {
                  print("Remote instance ID token: \(token)")
                  ApiClient.register_push(pushToken: token)
                      .execute { (_ response:ApiResponse?, error, status) in
                          print("Push Register Response: \(response?.rawData)")
                  }
                }
            }
        }else{
            print("Push messages for this device has been blocked")
        }
    }
    
    func showRemoveFastLoginAlert(){
        AlertDialogFactory.showAlertActionDialog(vc: self, title: LocalizedStrings.btn_fast_login.localizedString(), message: LocalizedStrings.fast_login_logine_error_message.localizedString(), actions: [MDCAlertAction(title: LocalizedStrings.yes.localizedString(), handler: { (_) in
            UserDefaultsManager.fast_login_data.clearValue();
        }),MDCAlertAction(title: LocalizedStrings.no.localizedString(), handler: { (_) in
            
        })])
        
    }
    
    func checkAndShowFastLoginAlert(loginType:SessionManager.LoginType){
        
        let context = LAContext()
        var authError: NSError?
        let canShowBiometric = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError)
        
        let willShowAlert = UserDefaultsManager.fast_login_data.getDefaultsValue() == nil && canShowBiometric && loginType == .username
        
        if !willShowAlert {
            self.dismiss(animated: true, completion: {
                self.loginDelegate?.performPostLoginActions()
            })
        }else{
            AlertDialogFactory.showAlertActionDialog(vc: self, title: LocalizedStrings.btn_fast_login.localizedString(), message: LocalizedStrings.fast_login_first_time_setup_message.localizedString(), actions: [MDCAlertAction(title: LocalizedStrings.yes.localizedString(), handler: { (action) in
                
                if let company = self.selectedCompany, let username = self.txtUserName?.text, let password = self.txtPassword?.text{
                    let dataDict:[String:Any] = ["company":company.toDictionary(),"username":username,"pwd":password]
                    let jsonData = try! JSONSerialization.data(withJSONObject: dataDict, options: [])
                    if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8){
                        UserDefaultsManager.fast_login_data.setDefaultValue(value: jsonString)
                    }
                }
                
                self.dismiss(animated: true, completion: {
                    self.loginDelegate?.performPostLoginActions()
                })
                
            }),MDCAlertAction(title: LocalizedStrings.no.localizedString(), handler: { (action) in
                self.dismiss(animated: true, completion: {
                    self.loginDelegate?.performPostLoginActions()
                })
            })])
        }
    }
    
    //Network Operations
    
    func fetchServiceDataArray(){
        if serviceArray.count == 0{
            self.toggleLoadingView(isVisible: true)
            //Cache temizliği yapmamız gerekiyor
            URLCache.shared.removeAllCachedResponses()
            ImageCache.default.clearDiskCache()
            ImageCache.default.clearMemoryCache()
            
            ApiClient.service_list.execute { (_ response:ServiceDataResponse?, error, statusCode) in
                self.toggleLoadingView(isVisible: false)
                if let e = error{
                    print("Error: \(e.localizedDescription)")
                }else{
                    
                    self.serviceArray = response?.serviceDatas.filter({ (s) -> Bool in
                        let bundleType = Utilities.getBundleType() ?? .seneka
                        if bundleType == .sanayi{
                            return s.code.elementsEqual("060015")
                        }else{
                            return s.isEnabled == true
                        }
                    }) ?? []
                    if  let versionData = response?.appVersions,
                        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String{
                        print("app ver: \(appVersion)")
                        if(versionData.iOS != appVersion && Utilities.getBundleType() == .seneka){
//                            self.showVersionAlert(version: versionData.iOS)
                        }
                    }
                    if let bundleType = Utilities.getBundleType(),
                        bundleType == .sanayi || bundleType == .simulator{
                        if let company = self.serviceArray.first(where: { (service) -> Bool in
                            return service.code.elementsEqual("060015")
                        }){
                            self.didSelectService(service: company)
                        }
                    }
                }
            }
        }
    }
    
    func showVersionAlert(version:String){
        AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.version_alert_title.localizedString(), message: LocalizedStrings.version_alert_message.localizedString(params: [version]), doneButtonTitle: LocalizedStrings.version_alert_update_button_title.localizedString(), doneButtonAction: {
            self.showVersionAlert(version:version)
            UIApplication.shared.open(URL(string: "itms://itunes.apple.com/tr/app/smartsigner/id1455456819?ls=1&mt=8")!, options: [:], completionHandler: nil)
        });
    }
    
    @objc func showServiceSelector(){
        let vc = ServiceSelectorViewController(services: self.serviceArray)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
}

extension LoginViewController:ServiceSelectorDelegate{
    func didSelectService(service: ServiceData) {
        self.selectedCompany = service
        SessionManager.current.serviceData = service
        self.updateCompanyFields()
    }
}

extension LoginViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
