//
//  HelperExtensions.swift
//  smartsigner
//
//  Created by Serdar Coskun on 20.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import Security
import CommonCrypto
import MaterialComponents

var salt = "b7R5tGs34lMjsn"
var password = "gk7Bfa40OhYrtfA"
var iv = "e675f725e675f725"

class HelperExtensions: NSObject {

}

extension Int {
    func hexString() -> String {
        return NSString(format:"%02x", self) as String
    }
}

extension Data {
    func hexString() -> String {
        let string = self.map{Int($0).hexString()}.joined()
        var stringReadable = String()
        var counter = 1
        for _ in string.indices {
            if (counter % 2) == 0 {
                stringReadable += " "
            }
            counter += 1;
        }
        return string
    }
    
    func MD5() -> Data {
        var result = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        _ = result.withUnsafeMutableBytes {resultPtr in
            self.withUnsafeBytes {(bytes: UnsafePointer<UInt8>) in
                CC_MD5(bytes, CC_LONG(count), resultPtr)
            }
        }
        return result
    }
    
    func SHA1() -> Data {
        var result = Data(count: Int(CC_SHA1_DIGEST_LENGTH))
        _ = result.withUnsafeMutableBytes {resultPtr in
            self.withUnsafeBytes {(bytes: UnsafePointer<UInt8>) in
                CC_SHA1(bytes, CC_LONG(count), resultPtr)
            }
        }
        return result
    }
    
    func SHA256() -> Data {
        var result = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = result.withUnsafeMutableBytes {resultPtr in
            self.withUnsafeBytes {(bytes: UnsafePointer<UInt8>) in
                CC_SHA256(bytes, CC_LONG(count), resultPtr)
            }
        }
        return result
    }
}

extension String {
    func replaceTurkishChars() -> String {
        let normalized = self.folding(options: .diacriticInsensitive, locale: Locale.current)
        return normalized
    }
    
    
    func MD5() -> String {
        return (self as NSString).data(using: String.Encoding.utf8.rawValue)!.MD5().hexString()
    }
    
    func MD5HashToBase64String() -> String
    {
        return (self as NSString).data(using: String.Encoding.utf8.rawValue)!.MD5().base64EncodedString(options: NSData.Base64EncodingOptions())
    }
    
    func SHA1() -> String {
        return (self as NSString).data(using: String.Encoding.utf8.rawValue)!.SHA1().hexString()
    }
    
    func SHA256() -> String {
        return (self as NSString).data(using: String.Encoding.utf8.rawValue)!.SHA256().hexString()
    }
    
    var base64: String!{
        let plainData = data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String!
    }
    

    
    func AESEncrypt() -> String
    {
        let saltData = (salt as NSString).data(using: String.Encoding.utf8.rawValue)
        var err : NSError?
        
        let keyData = generateAesKeyForPassword(password, salt: saltData!, roundCount: 100, error: &err)!
        
        let keyBytes         = (keyData as NSData).bytes.bindMemory(to: UInt8.self, capacity: keyData.count)
        let keyLength        = size_t(kCCKeySizeAES128)
        
        let plainData     = self.data(using: String.Encoding.utf8)
        let dataLength    = plainData?.count
        let dataBytes     = NSData(data: plainData!).bytes.bindMemory(to: UInt8.self, capacity: (plainData?.count)!)
        
        var bufferData : Data! = Data(count: Int(dataLength!) + kCCBlockSizeAES128)
        let bufferLength  = bufferData.count
        
        //let bufferData : NSMutableData! = NSMutableData(length: Int(dataLength!) + kCCBlockSizeAES128)
        //let bufferPointer = UnsafeMutablePointer<UInt8>(bufferData.mutableBytes)
        //let bufferLength  = bufferData.length
        
        let operation: CCOperation = UInt32(kCCEncrypt)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
        let options = UInt32(kCCOptionPKCS7Padding)
        
        let ivData: Data! = (iv as NSString).data(using: String.Encoding.utf8.rawValue)
        let ivPointer = NSData(data: ivData).bytes.bindMemory(to: UInt8.self, capacity: ivData.count)
        
        var numBytesEncrypted: Int = 0
        
        _ = bufferData.withUnsafeMutableBytes({ (bufferPointer: UnsafeMutablePointer<UInt8>) in
            _ = CCCrypt(operation, algoritm, options, keyBytes, keyLength, ivPointer, dataBytes, dataLength!, bufferPointer, bufferLength, &numBytesEncrypted)
        })
        
        bufferData.count = Int(numBytesEncrypted)
        let base64cryptString = bufferData.base64EncodedString(options: .lineLength64Characters)
        
        return base64cryptString
    }
    
    func AESDecrypt() -> String
    {
        
        let saltData = (salt as NSString).data(using: String.Encoding.utf8.rawValue)
        var err : NSError?
        
        let keyData = generateAesKeyForPassword(password, salt: saltData!, roundCount: 100, error: &err)!
        
        let keyBytes         = (keyData as NSData).bytes.bindMemory(to: UInt8.self, capacity: keyData.count)
        let keyLength        = size_t(kCCKeySizeAES128)
        
        let plainData     = Data(base64Encoded: self.replacingOccurrences(of: "\n", with: ""))!
        let dataLength    = plainData.count
        let dataBytes     = (plainData as NSData).bytes.bindMemory(to: UInt8.self, capacity: plainData.count)
        
        var bufferData : Data! = Data(count: Int(dataLength) + kCCBlockSizeAES128)
        let bufferLength  = bufferData.count
        
        //let bufferData : NSMutableData! = NSMutableData(length: Int(dataLength) + kCCBlockSizeAES128)
        //let bufferPointer = UnsafeMutablePointer<UInt8>(bufferData.mutableBytes)
        //let bufferLength  = bufferData.length
        
        let operation: CCOperation = UInt32(kCCDecrypt)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
        let options = UInt32(kCCOptionPKCS7Padding)
        
        let ivData: Data! = (iv as NSString).data(using: String.Encoding.utf8.rawValue)
        let ivPointer = NSData(data: ivData).bytes.bindMemory(to: UInt8.self, capacity: ivData.count)
        
        var numBytesDeccrypted: Int = 0
        
        var cryptStatus : Int32 = 0
        _ = bufferData.withUnsafeMutableBytes({ (bufferPointer: UnsafeMutablePointer<UInt8>) in
            cryptStatus = CCCrypt(operation, algoritm, options, keyBytes, keyLength, ivPointer, dataBytes, dataLength, bufferPointer, bufferLength, &numBytesDeccrypted)
        })
        
        var base64cryptString = NSString()
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            bufferData.count = Int(numBytesDeccrypted)
            base64cryptString = NSString(data: bufferData as Data, encoding: String.Encoding.utf8.rawValue) ?? "<error>"
        }
        
        return base64cryptString as String
    }
    
    func generateAesKeyForPassword(_ password: String, salt: Data, roundCount: Int?, error: NSErrorPointer) -> (Data)?
    {
        var nsDerivedKey = Data(count: kCCKeySizeAES128)
        //let nsDerivedKey = NSMutableData(length: kCCKeySizeAES128)
        var actualRoundCount: UInt32
        
        let algorithm: CCPBKDFAlgorithm        = CCPBKDFAlgorithm(kCCPBKDF2)
        let prf:       CCPseudoRandomAlgorithm = CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1)
        let saltBytes  = (salt as NSData).bytes.bindMemory(to: UInt8.self, capacity: salt.count)
        let saltLength = size_t(salt.count)
        let nsPassword        = password as NSString
        let nsPasswordPointer = UnsafePointer<Int8>(nsPassword.cString(using: String.Encoding.utf8.rawValue))
        let nsPasswordLength  = size_t(nsPassword.lengthOfBytes(using: String.Encoding.utf8.rawValue))
        //let nsDerivedKeyPointer = UnsafeMutablePointer<UInt8>(nsDerivedKey!.mutableBytes)
        let nsDerivedKeyLength = size_t(nsDerivedKey.count)
        let msec: UInt32 = 300
        
        if roundCount != nil {
            actualRoundCount = UInt32(roundCount!)
        }
        else {
            actualRoundCount = CCCalibratePBKDF(
                algorithm,
                nsPasswordLength,
                saltLength,
                prf,
                nsDerivedKeyLength,
                msec);
        }
        var result : Int32 = 0
        _ = nsDerivedKey.withUnsafeMutableBytes({ (nsDerivedKeyPointer: UnsafeMutablePointer<UInt8>) in
            result = CCKeyDerivationPBKDF(
                algorithm,
                nsPasswordPointer,   nsPasswordLength,
                saltBytes,           saltLength,
                prf,                 actualRoundCount,
                nsDerivedKeyPointer, nsDerivedKeyLength)
            
        })
        
        if result != 0 {
            _ = "CCKeyDerivationPBKDF failed with error: '\(result)'"
            return nil
        }
        
        return (nsDerivedKey as (Data)?)
    }
}

extension UIViewController{
    
    
    static func getNibName()->String{
        return String(describing: self)
    }
    
    fileprivate struct AssociatedObjectKeys {
        static var progressAlertView = "MDCProgressAlertViewController"
        static var dialogTranstitionController = "MDCDialogTranstitionController"
        static var datePickerDialog = "DatePickerDialog"
    }

    fileprivate var dialogTranstitionController:MDCDialogTransitionController?{
        set{
            objc_setAssociatedObject(self, &AssociatedObjectKeys.dialogTranstitionController, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        get{
            if let transtitionController = objc_getAssociatedObject(self, &AssociatedObjectKeys.dialogTranstitionController) as? MDCDialogTransitionController{
                return transtitionController
            }else{
                self.dialogTranstitionController = MDCDialogTransitionController()
                return self.dialogTranstitionController
            }
        }
    }

    fileprivate var progressDialog:WFProgressDialogViewController?{
        set{
            objc_setAssociatedObject(self, &AssociatedObjectKeys.progressAlertView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        get{
            if let progressAlertView = objc_getAssociatedObject(self, &AssociatedObjectKeys.progressAlertView) as? WFProgressDialogViewController{
                return progressAlertView
            }else{
                self.progressDialog = WFProgressDialogViewController(title: nil, message: nil)
                return self.progressDialog
            }
        }
    }
    
    fileprivate var datePicker:DatePickerDialogViewController?{
        set{
            objc_setAssociatedObject(self, &AssociatedObjectKeys.datePickerDialog, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }get{
            if let datePicker = objc_getAssociatedObject(self, &AssociatedObjectKeys.datePickerDialog) as? DatePickerDialogViewController{
                return datePicker
            }else{
                self.datePicker = DatePickerDialogViewController()
                return self.datePicker
            }
        }
    }
    
    @discardableResult func showDatePicker(sourceView:String,selectedDate:Date?) -> DatePickerDialogViewController?{
        guard let vc = self.datePicker else{
            print("Error instantinating datepicker")
            return nil
        }
        vc.selectedDate = selectedDate
        vc.sourceView = sourceView
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self.dialogTranstitionController
        if let presentationController =
            vc.mdc_dialogPresentationController{
            presentationController.dismissOnBackgroundTap = false
        }
        
        vc.preferredContentSize = CGSize(width: self.view.bounds.width - 32, height: self.view.bounds.height * 0.75)
        present(vc, animated: true, completion: nil)
        return vc
    }

    @discardableResult func showProgressDialog(title:LocalizedStrings, message:LocalizedStrings) -> WFProgressDialogViewController?{
            return self.showProgressDialog(title: title, message: message, isIndeterminate: true)
    }
    
    @discardableResult func showProgressDialog(title:LocalizedStrings, message:LocalizedStrings, isIndeterminate:Bool) -> WFProgressDialogViewController?{
        return showProgressDialog(title: title.localizedString(), message: message.localizedString(), isIndeterminate: isIndeterminate)
    }
    
    @discardableResult func showProgressDialog(title:String, message:String, isIndeterminate:Bool) -> WFProgressDialogViewController?{
        guard let vc = self.progressDialog else{
            print("Error instantinating progress alert")
            return nil
        }
        vc.activityIndicator?.setIndicatorMode(isIndeterminate ? .indeterminate : .determinate, animated: false)
        vc.alertTitle = title
        vc.alertMessage = message
        vc.updateLabels()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self.dialogTranstitionController
        if let presentationController =
            vc.mdc_dialogPresentationController{
            presentationController.dismissOnBackgroundTap = false
        }
        present(vc, animated: true, completion: nil)
        return self.progressDialog
    }

    //Alert Actions
    @discardableResult func showBasicAlert(title:LocalizedStrings, message:LocalizedStrings, okTitle:LocalizedStrings?, actionHandler:MDCActionHandler?) -> MDCAlertController{
        return showAlert(title: title, message: message, actions: [(title:okTitle ?? LocalizedStrings.ok,handler:actionHandler)])
    }
    
    @discardableResult func showBasicAlert(title:String, message:String, okTitle:LocalizedStrings?, actionHandler:MDCActionHandler?) -> MDCAlertController{
        return showAlert(title: title, message: message, actions: [(title:okTitle ?? LocalizedStrings.ok,handler:actionHandler)])
    }

    @discardableResult func showAlert(title:LocalizedStrings, message:LocalizedStrings, actions:[(title:LocalizedStrings,handler:MDCActionHandler?)]) -> MDCAlertController{
        return self.showAlert(title: title.localizedString(), message: message.localizedString(), actions: actions)
    }
    
    @discardableResult func showAlert(title:String, message:String, actions:[(title:LocalizedStrings,handler:MDCActionHandler?)]) -> MDCAlertController{
        let alertController = MDCAlertController(title: title, message: message)
        for action:(title:LocalizedStrings,handler:MDCActionHandler?) in actions{
            let action = MDCAlertAction(title: action.title.localizedString(), handler: action.handler)
            
            alertController.addAction(action)
        }
        alertController.mdc_dialogPresentationController?.dismissOnBackgroundTap = false
        alertController.titleColor = .black
        alertController.messageColor = .darkGray
        present(alertController, animated: true, completion: nil)
        return alertController
    }
}

extension String{
    func getRelativeDateString(inputDateFormat:String?) -> String{
        let dateFormatter = DateFormatter()
        let dfRead = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        dfRead.dateFormat = inputDateFormat ?? "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: dfRead.date(from: self)!)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension NSTextAttachment {
    func setImageHeight(height: CGFloat) {
        guard let image = image else { return }
        let ratio = image.size.width / image.size.height
        
        bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: ratio * height, height: height)
    }
}

extension UIButton{
    func setAttributedIcon(icon:FontAwesomeType, size:CGFloat){
        self.setAttributedTitle(Utilities.getIconString(icon: icon, size: size), for: .normal)
    }
}

extension Date{
    func toDotNet() -> String{
        return "/Date(\(Int(self.timeIntervalSince1970 * 1000.0)))/"
    }
}
