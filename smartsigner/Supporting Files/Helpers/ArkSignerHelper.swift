//
//  ArkSignerHelper.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 21.03.2020.
//  Copyright © 2020 Seneka. All rights reserved.
//
import StoreKit
struct ArkSignerHelper  {

    static func getArkSignerUrl(callbackAction:String, setId:String)->URL{
        let initUrl = "\(SessionManager.current.serviceData?.serviceUrl ?? "")GetDocumentsFromSignQueue"
        let finalizeUrl = "\(SessionManager.current.serviceData?.serviceUrl ?? "")CompleteDocumentSignInSignQueue"
        let callbackUrl = "smartsigner://\(callbackAction)?GUID=\(setId)"
        let urlString = "arksigner://action=signPKCS1&transactionUUID=\(setId)&licenseKey=\("ArkSigner".arkSignerBase64 ?? "")&initializeUrl=\(initUrl.arkSignerBase64 ?? "")&finalizeUrl=\(finalizeUrl.arkSignerBase64 ?? "")&callbackUrl=\(callbackUrl.arkSignerBase64 ?? "")"
        let url = URL(string: urlString)
        print("Callback URL: \(callbackUrl)")
        return url!
    }
    
    static func openArkSignerApp(parentVC:UIViewController, callbackAction:String, setId:String){
        UIApplication.shared.open(ArkSignerHelper.getArkSignerUrl(callbackAction:callbackAction, setId: setId), options: [:]) { (success) in
            if !success{
                parentVC.showAlert(title: .alert_message_sign_e_sign_app, message: .alert_e_sign_arksigner_app_not_founc, actions:
                    [
                        (title: LocalizedStrings.alert_e_sign_arksigner_download, handler:{ action in
                            let storeVC = SKStoreProductViewController()
                            let params = [SKStoreProductParameterITunesItemIdentifier:"1496600667"]
                            storeVC.loadProduct(withParameters: params) { (success, error) in
                                if success{
                                    parentVC.present(storeVC, animated: true, completion: nil)
                                }else{
                                    UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id1496600667")!, options: [:]) { (success) in}
                                }
                            }
                        }),
                        (title: LocalizedStrings.cancel, handler:{ action in
                            
                        })
                    ]
                )
            }
        }
    }
}

extension String{
    var arkSignerBase64: String!{
        let replacedString = self
            
        let plainData = replacedString.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String!
            .replacingOccurrences(of: "=", with: "%26")
            .replacingOccurrences(of: "/", with: "%2F")
            .replacingOccurrences(of: "+", with: "%2B")
    }
}

