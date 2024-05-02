//
//  LoginViewControllerPresenter.swift
//  smartsigner
//
//  Created by Serdar Coskun on 21.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
import NVActivityIndicatorView
import Kingfisher
import LocalAuthentication
class LoginViewControllerPresenter: NSObject {

}

extension LoginViewController{
    override func viewDidLayoutSubviews() {
        if !didLayoutSubviews {
            didLayoutSubviews = true
            
            viewMainContainer?.shadowLayer.elevation = .cardPickedUp
            
            
            setupFloatingTextfields()
            
//            MDCContainedButtonThemer.applyScheme(MDCButtonScheme(), to: btnToggleLoginType!)
            MDCContainedButtonThemer.applyScheme(MDCButtonScheme(), to: btnLogin!)
            MDCContainedButtonThemer.applyScheme(MDCButtonScheme(), to: btnUsernameLogin!)
            MDCContainedButtonThemer.applyScheme(MDCButtonScheme(), to: btnMobileLogin!)
            MDCContainedButtonThemer.applyScheme(MDCButtonScheme(), to: btnFastLogin!)
            
            if let _ = self.btnESignLogin{
                MDCContainedButtonThemer.applyScheme(MDCButtonScheme(), to: btnESignLogin!)
                ThemeManager.applyButtonColorTheme(button: btnESignLogin!)
            }
            
            
            
            
//            ThemeManager.applyButtonColorTheme(button: btnToggleLoginType!)
            ThemeManager.applyButtonColorTheme(button: btnLogin!)
            ThemeManager.applyButtonColorTheme(button: btnUsernameLogin!)
            ThemeManager.applyButtonColorTheme(button: btnMobileLogin!)
            
            ThemeManager.applyButtonColorTheme(button: self.btnFastLogin!)
            
            activityIndicatorView?.type = .ballScaleMultiple
            activityIndicatorView?.color = UIColor.white
            
//            setButtonState(isMobileLogin: true, hidden: true, animated: false)
//            self.lblCompanyName?.text = ""
            self.lblSelectService?.text = LocalizedStrings.btn_select_service_empty.localizedString()
            
            self.imgCompanyLogo?.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showServiceSelector))
            tapGesture.numberOfTapsRequired = 1
            self.imgCompanyLogo?.addGestureRecognizer(tapGesture)
            
            self.btnFastLogin?.setTitle(LocalizedStrings.btn_fast_login.localizedString(), for: .normal)
            
            
            let context = LAContext()
            var authError: NSError?
            self.btnFastLogin?.isHidden = !context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError)
            
            self.txtPassword?.placeholder = LocalizedStrings.login_password.localizedString()
            self.btnUsernameLogin?.setTitle(LocalizedStrings.login_button_title_username.localizedString(), for: .normal)
            self.btnMobileLogin?.setTitle(LocalizedStrings.login_button_title_mobile.localizedString(), for: .normal)
            self.btnESignLogin?.setTitle(LocalizedStrings.login_button_title_e_sign.localizedString(), for: .normal)
            self.btnLogin?.setTitle(LocalizedStrings.login_button_title.localizedString(), for: .normal)
            self.txtUserName?.placeholder = self.isMobileLogin ? LocalizedStrings.login_national_identity.localizedString() : LocalizedStrings.login_username.localizedString()
            
            self.btnMobileLogin?.addTarget(self, action: #selector(didTapMobileLoginButton(sender:)), for: .touchUpInside)
            self.btnUsernameLogin?.addTarget(self, action: #selector(didTapUsernameLoginButton(sender:)), for: .touchUpInside)
            self.btnESignLogin?.addTarget(self, action: #selector(didTapESignLoginButton(sender:)), for: .touchUpInside)
        }
    }
    
    @objc func didTapUsernameLoginButton(sender:Any){
        if self.isMobileLogin {
            toggleLoginType(isMobileLogin: false)
        }
        
    }
    
    @objc func didTapMobileLoginButton(sender:Any){
        Utilities.checkESignStatus(parentViewControler: self, isLogin: true, eSignMethod: .mobile_sign) {
            if !self.isMobileLogin{
                self.toggleLoginType(isMobileLogin: true)
            }
        }
    }
    
    @objc func didTapESignLoginButton(sender:Any){
        print("E Sign")
        if SessionManager.current.canUseArkSignerApp() {
            showAlert(title: .login_button_title_e_sign, message: .alert_message_pick_sign_method, actions: [
                (title: LocalizedStrings.cancel, handler: {_ in
                    
                }),
                (title: LocalizedStrings.alert_message_sign_method_e_sign, handler: {_ in
                    self.beginESigLogin()
                }),
                (title: LocalizedStrings.alert_message_sign_e_sign_app, handler: {_ in
                    self.beginArkSignerLogin()
                }),
            ])
        }else{
            beginESigLogin()
        }
        
    }
    
    //Login formunun mobil giriş ve tckn arasındaki geçişini ayarlar
    func updateLoginForm(){
        updateLoginForm(completion: nil)
    }

    func updateLoginForm(completion:(()->(Void))?){
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutPasswordFieldTop?.constant = self.isMobileLogin ? -40 : 8
            self.view.layoutIfNeeded()
            self.txtPassword?.alpha = self.isMobileLogin ? 0 : 1
            self.txtUserName?.placeholder = self.isMobileLogin ? LocalizedStrings.login_national_identity.localizedString() : LocalizedStrings.login_username.localizedString()
            
            let title = !self.isMobileLogin ? LocalizedStrings.login_type_mobile.localizedString() : LocalizedStrings.login_type_username.localizedString()
            self.btnToggleLoginType?.setTitle(title, for: .normal)
            
        }) { (complete) in
            self.txtPassword?.isUserInteractionEnabled = !self.isMobileLogin
            completion?()
        }
    }
    
//    //Mobil giriş butonunun görünürlüp durumunu ayarlar
//    func setButtonState(isMobileLogin:Bool, hidden:Bool, animated:Bool){
//
//        let title = isMobileLogin ? LocalisedStrings.login_type_mobile.localizedString() : LocalisedStrings.login_type_username.localizedString()
//        btnToggleLoginType?.setTitle(title, for: .normal)
//
//        UIView.animate(withDuration: animated ? 0.25 : 0, animations: {
//            self.btnToggleLoginType?.alpha = hidden ? 0 : 1
//        }) { (complete) in
//            self.btnToggleLoginType?.isUserInteractionEnabled = !hidden
//        }
//    }
//
    
    
    //Material style textfieldları düzenliyoruz
    func setupFloatingTextfields(){
        var textfieldArray = [txtUserName]
        var placeholderArray:[LocalizedStrings] = [.login_corporate_code,.login_username,.login_password]
        for i in 0..<textfieldArray.count{
            let textFieldControllerFloating = MDCTextInputControllerUnderline(textInput: textfieldArray[i])
            textFieldControllerFloating.placeholderText = placeholderArray[i].localizedString()
            floatingTextfieldControllers.append(textFieldControllerFloating)
        }
    }
    
    //Girilen kurum kodu ile logo ve başlık alanlarını güncelliyoruz
    func updateCompanyFields(){
        guard let bundlyType = Utilities.getBundleType() else{
            return
        }
        self.toggleLoadingView(isVisible: true)
        ApiClient.initial_settings.execute { (_ response:GetInitialSettingsResponse?, error, status) in
            if response?.errorContent() == nil{
                SessionManager.current.transferDepartmentSettings = response?.departmentSettings ?? []
            }
            self.toggleLoadingView(isVisible: false)
            switch bundlyType {
                    case .sanayi, .simulator:
                        self.imgCompanyLogo?.image = UIImage(named: "logo_sanayi")
                        self.lblCompanyName?.text = "T.C. Sanayi ve Teknoloji Bakanlığı"
                        self.imgCompanyLogo?.isUserInteractionEnabled = false
                        self.lblSelectService?.isHidden = true
                        self.updateButtons(isMobileEnabled: false, isESignEnabled: false)
            //            self.setButtonState(isMobileLogin: true, hidden: !(self.selectedCompany?.canUseMobileSign ?? false), animated: false)
                    default:
                        if let company = self.selectedCompany{
                            self.imgCompanyLogo?.kf.setImage(with: URL(string: company.imageUrl))
                            self.lblCompanyName?.text = company.projectName
            //                self.setButtonState(isMobileLogin: true, hidden: !company.canUseMobileSign, animated: true)
                            self.selectedCompany = company
                            self.lblSelectService?.isHidden = true
                            self.updateButtons(isMobileEnabled: company.canUseMobileSign, isESignEnabled: true)
                            SessionManager.current.serviceData = company
                        }else{
                            SessionManager.current.serviceData = nil
                            self.imgCompanyLogo?.image = UIImage(named: "logo_smart_signer")
                            self.lblCompanyName?.text = ""
            //                self.setButtonState(isMobileLogin: true, hidden: true, animated: true)
                            self.selectedCompany = nil
                            self.lblSelectService?.isHidden = false
                            self.updateButtons(isMobileEnabled: false, isESignEnabled: false)
                        }
                    }
        }
    }
    
    func updateButtons(isMobileEnabled:Bool, isESignEnabled:Bool, isUserNameEnabled:Bool = true){
        self.btnMobileLogin?.setEnabled(isMobileEnabled, animated: true)
        self.btnESignLogin?.setEnabled(isESignEnabled, animated: true)
        self.btnUsernameLogin?.setEnabled(isUserNameEnabled, animated: true)
    }
    
    //Yüklemeler için gerekli olan loadingview'i ayarlıyoruz
    func toggleLoadingView(isVisible:Bool){
        
        self.btnLogin?.isEnabled = !isVisible
        self.imgCompanyLogo?.isUserInteractionEnabled = !isVisible
        
        if btnFastLogin?.alpha != 0{
            self.btnFastLogin?.isEnabled = !isVisible
        }
        
        if btnToggleLoginType?.alpha != 0{
            self.btnToggleLoginType?.isEnabled = !isVisible
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.viewActivityContainer?.alpha = isVisible ? 1 : 0
        }) { (complete) in
            self.viewActivityContainer?.isHidden = !isVisible
            if isVisible{
                self.activityIndicatorView?.startAnimating()
                self.updateButtons(isMobileEnabled: false, isESignEnabled: false, isUserNameEnabled: false)
            }else{
                self.activityIndicatorView?.stopAnimating()
                self.updateButtons(isMobileEnabled: self.selectedCompany?.canUseMobileSign ?? false, isESignEnabled: true, isUserNameEnabled: true)
            }
        }
    }
}
