//
//  AppSettingsViewController.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 1.03.2020.
//  Copyright © 2020 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
import LocalAuthentication
import FirebaseMessaging

class AppSettingsViewController: BaseViewController {

    
    @IBOutlet weak var lblPushTitle:UILabel?
    @IBOutlet weak var swPushNotification:UISwitch?
    @IBOutlet weak var viewPushContainer:MDCCard?
    
    @IBOutlet weak var lblLanguageTitle:UILabel?
    @IBOutlet weak var lblSelectedLanguage:UILabel?
    @IBOutlet weak var viewLanguageContainer:MDCCard?
    
    @IBOutlet weak var lblBiometricTitle:UILabel?
    @IBOutlet weak var imgBiometricIcon:UIImageView?
    @IBOutlet weak var viewBiometricContainer:MDCCard?
    @IBOutlet weak var scrollView:UIScrollView?
    
    @IBOutlet weak var lblVersionTitle:UILabel?
    @IBOutlet weak var lblVersionCode:UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewPushContainer?.addTarget(self, action: #selector(didTapPushView), for: .touchUpInside)
        self.viewLanguageContainer?.addTarget(self, action: #selector(didTapLanguage), for: .touchUpInside)
        self.viewBiometricContainer?.addTarget(self, action: #selector(didTapBiometric), for: .touchUpInside)
        
        self.swPushNotification?.addTarget(self, action: #selector(togglePush), for: .valueChanged)
        self.imgBiometricIcon?.image = UIImage(awesomeType: .fingerprint, size: 30, textColor: .secondaryTextColor)
        initLabels()
        
        
        let context = LAContext()
        var authError: NSError?
        let canShowBiometric = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError)
        if !canShowBiometric {
            self.viewBiometricContainer?.removeFromSuperview()
        }
        checkFastLogin()
        checkPushSettings()
        
        self.lblVersionCode?.text = Bundle.main.releaseVersionNumberPretty
    }
    
    
    
    override func viewDidLayoutSubviews() {
        if !didLayoutSubviews{
            didLayoutSubviews = true
            commonInit(trackingScrollView: self.scrollView)
        }
    }
    
    func initLabels(){
        self.title = LocalizedStrings.settings_title.localizedString()
        lblPushTitle?.text = LocalizedStrings.settings_push_title.localizedString()
        lblLanguageTitle?.text = LocalizedStrings.settings_language_title.localizedString()
        lblBiometricTitle?.text = LocalizedStrings.settings_biometric_title.localizedString()
        self.lblSelectedLanguage?.text = LocalizedStrings.getCurrentLocale().elementsEqual("tr") ? "TR" : "EN"
        self.lblVersionTitle?.text = LocalizedStrings.settings_version.localizedString()
    }
    
    func checkFastLogin(){
        let doesAlreadyHaveFastLogin = (UserDefaultsManager.fast_login_data.getDefaultsValue() != nil)
        self.imgBiometricIcon?.alpha = doesAlreadyHaveFastLogin ? 1 : 0.6
    }
    
    @objc func didTapBiometric(){
        let context = LAContext()
        var authError: NSError?
        let canShowBiometric = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError)
        
        if canShowBiometric{
            if UserDefaultsManager.fast_login_data.getDefaultsValue() == nil{
                AlertDialogFactory.showAlertActionDialog(vc: self, title: LocalizedStrings.btn_fast_login.localizedString(), message: LocalizedStrings.fast_login_confirm_message.localizedString(), actions: [MDCAlertAction(title: LocalizedStrings.yes.localizedString(), handler: { (action) in
                    
                    self.setFastLoginForCurrentUser()
                }),MDCAlertAction(title: LocalizedStrings.no.localizedString(), handler: { (action) in
                    
                })])
            }else{
                let doesAlreadyHaveFastLogin = (UserDefaultsManager.fast_login_data.getDefaultsValue() != nil)
                
                var actions:[MDCAlertAction] = [MDCAlertAction(title: LocalizedStrings.cancel.localizedString(), handler: { (action) in
                    
                })]
                if doesAlreadyHaveFastLogin{
                    actions.append(MDCAlertAction(title: LocalizedStrings.fast_login_remove.localizedString(), handler: { (action) in
                        UserDefaultsManager.fast_login_data.clearValue()
                        self.checkFastLogin()
                        self.showBasicAlert(title: LocalizedStrings.btn_fast_login, message: LocalizedStrings.fast_login_clear_success, okTitle: .ok, actionHandler: nil)
                    }))
                }else{
                    actions.append(MDCAlertAction(title: LocalizedStrings.fasr_login_enable_for_this_account.localizedString(), handler: { (action) in
                        
                        self.setFastLoginForCurrentUser()
                        
                    }))
                }
                AlertDialogFactory.showAlertActionDialog(vc: self, title: LocalizedStrings.btn_fast_login.localizedString(), message: LocalizedStrings.fast_login_select_action.localizedString(), actions: actions)
            }
        }else{
            
        }
        
    }
    
    func setFastLoginForCurrentUser(){
        if
            let company = SessionManager.current.serviceData,
            let username = SessionManager.current.loginData?.loggedUserUserName,
            let rawpw = SessionManager.current.rawpw,
            let password = String(data: rawpw, encoding: .utf8){
            
            let dataDict:[String:Any] = ["company":company.toDictionary(),"username":username,"pwd":password]
            let jsonData = try! JSONSerialization.data(withJSONObject: dataDict, options: [])
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8){
                UserDefaultsManager.fast_login_data.setDefaultValue(value: jsonString)
                
            }
            self.checkFastLogin()
            showBasicAlert(title: LocalizedStrings.btn_fast_login, message: LocalizedStrings.fast_login_enable_success, okTitle: .ok, actionHandler: nil)
        }
    }
    
    ///mark - Language Settings
    @objc func didTapLanguage(){
        if LocalizedStrings.getCurrentLocale().elementsEqual("tr") {
            LocalizedStrings.setCurrentLocale(locale: "en")
        }else{
            LocalizedStrings.setCurrentLocale(locale: "tr")
        }
        self.lblSelectedLanguage?.text = LocalizedStrings.getCurrentLocale().elementsEqual("tr") ? "TR" : "EN"
        Observers.reload_folder.post(userInfo: nil)
        SessionManager.current.refreshFolders()
        initLabels()
    }
    
    ///mark - Push Settings
    
    func checkPushSettings(){
        var isPushBlocked = false
        if let banList =  UserDefaultsManager.push_block_list.getDefaultsValue() as? [Int]{
            if banList.contains(SessionManager.current.loginData?.loggedUserId ?? -1) {
                isPushBlocked = true
            }
        }
        self.swPushNotification?.isOn = !isPushBlocked
    }
    
    @objc func didTapPushView(){
        self.swPushNotification?.setOn(!(self.swPushNotification?.isOn ?? false), animated: true)
        self.togglePush()
    }
    
    @objc func togglePush(){
        let isOn = swPushNotification?.isOn ?? false
        let currentUserId = SessionManager.current.loginData?.loggedUserId ?? -1
        var blockList = [Int]()
        if let list = UserDefaultsManager.push_block_list.getDefaultsValue() as? [Int]{
            blockList.append(contentsOf: list)
        }
        if isOn {
            if blockList.contains(currentUserId) {
                blockList.removeAll(where: {$0 == currentUserId})
            }
            enablePush()
        }else{
            if !blockList.contains(currentUserId){
                blockList.append(currentUserId)
            }
            disablePush()
        }
        UserDefaultsManager.push_block_list.setDefaultValue(value: blockList)
    }
    
    func disablePush(){
        Messaging.messaging().token { token, error in
            if let error = error {
              print("Error fetching remote instance ID: \(error)")
            } else if let token = token {
              print("Remote instance ID token: \(token)")
              ApiClient.delete_push_token(pushToken: token)
                  .execute { (_ response:ApiResponse?, error, status) in
                      print("Push Register Response: \(response?.rawData)")
              }
            }
        }
    }
    
    func enablePush(){
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
    }
}
