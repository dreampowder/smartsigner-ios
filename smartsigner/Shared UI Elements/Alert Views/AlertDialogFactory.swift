//
//  AlertDialogFactory.swift
//  smartsigner
//
//  Created by Serdar Coskun on 21.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents

class AlertDialogFactory: NSObject {

    static func showBasicAlertFromViewController(vc:UIViewController,
                                          title:String,
                                          message:String,
                                          doneButtonTitle:String?,
                                          doneButtonAction:(()->())?){
        
        let alertController = MDCAlertController(title: title, message: message)
        
        alertController.addAction(MDCAlertAction(title: doneButtonTitle ?? LocalizedStrings.ok.localizedString(), handler: { (action) in
                doneButtonAction?()
        }))
        
        alertController.mdc_dialogPresentationController?.dismissOnBackgroundTap = false
        alertController.titleColor = .black
        alertController.messageColor = .darkGray
        vc.present(alertController, animated: true, completion: nil)
    }
    
    static func showUnexpectedErrorFromViewController(vc:UIViewController,
                                                      doneButtonAction:(()->())?){
        self.showBasicAlertFromViewController(vc: vc, title: LocalizedStrings.error.localizedString(), message: LocalizedStrings.error_unexpected.localizedString(), doneButtonTitle: LocalizedStrings.ok.localizedString(), doneButtonAction: doneButtonAction)
    }
    
    @discardableResult
    static func showAlertWithTextInputFromViewController(
        vc:UIViewController,
        placeholder:String,
        title:String,
        positiveTitle:String,
        negativeTitle:String,
        delegate:InputDialogDelegate) -> DialogWithInputFieldViewController{
        let alertController = DialogWithInputFieldViewController.create(title: title, placeholder: placeholder, positiveTitle: positiveTitle, negativeTitle: negativeTitle, delegate:delegate)
        return alertController
    }
    
    @discardableResult
    static func showAlertWithTextInputFromViewController(
        vc:UIViewController,
        placeholder:String,
        title:String,
        positiveTitle:String,
        negativeTitle:String,
        acceptBlock:@escaping ((_ content:String)->Void)
    ) -> DialogWithInputFieldViewController{
        let alertController = DialogWithInputFieldViewController.create(title: title, placeholder: placeholder, positiveTitle: positiveTitle, negativeTitle: negativeTitle, delegate:nil,acceptBlock: acceptBlock)
        return alertController
    }
    
    
    static func showAlertActionDialog(vc:UIViewController, title:String,message:String, actions:[MDCAlertAction]){
        let alertController = MDCAlertController(title: title, message: message)
        for action in actions {
            alertController.addAction(action)
        }
        alertController.titleColor = .black
        alertController.messageColor = .darkGray
        alertController.mdc_dialogPresentationController?.dismissOnBackgroundTap = false
        vc.present(alertController, animated: true, completion: nil)
    }
    
    static func showMultiMobileSignSimAlert(vc: UIViewController, onComplete:@escaping (()->Void)){
        let shouldSkipAlert = UserDefaultsManager.should_skip_multi_sign_push_warning.getDefaultsValue() as? Bool
        if shouldSkipAlert ?? false{
            onComplete()
            return
        }
        let alertController = MDCAlertController(
            title: LocalizedStrings.alert_message_sign_method_multi_mobile_sign.localizedString(),
            message: LocalizedStrings.alert_message_multi_mobile_sim_warning.localizedString()
        )
        let actions:[MDCAlertAction] = [
            MDCAlertAction(title: LocalizedStrings.alert_action_multi_mobile_dont_show_again.localizedString(), handler: { _ in
                UserDefaultsManager.should_skip_multi_sign_push_warning.setDefaultValue(value: true)
                onComplete()
            }),
            
            MDCAlertAction(title: LocalizedStrings.ok.localizedString(), handler: { _ in
                onComplete()
            })
        ]
        for action in actions {
            alertController.addAction(action)
        }
        alertController.titleColor = .black
        alertController.messageColor = .darkGray
        alertController.mdc_dialogPresentationController?.dismissOnBackgroundTap = false
        vc.present(alertController, animated: true)
    }
}
