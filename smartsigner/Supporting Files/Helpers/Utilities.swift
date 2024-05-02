//
//  Utilities.swift
//  smartsigner
//
//  Created by Serdar Coskun on 5.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit

class Utilities: NSObject {
    
    fileprivate static let DEFAULT_MIME_TYPE = "application/octet-stream"
    fileprivate static let mimeTypes:[String:String] = [
        "html": "text/html",
        "htm": "text/html",
        "shtml": "text/html",
        "css": "text/css",
        "xml": "text/xml",
        "gif": "image/gif",
        "jpeg": "image/jpeg",
        "jpg": "image/jpeg",
        "js": "application/javascript",
        "atom": "application/atom+xml",
        "rss": "application/rss+xml",
        "mml": "text/mathml",
        "txt": "text/plain",
        "jad": "text/vnd.sun.j2me.app-descriptor",
        "wml": "text/vnd.wap.wml",
        "htc": "text/x-component",
        "png": "image/png",
        "tif": "image/tiff",
        "tiff": "image/tiff",
        "wbmp": "image/vnd.wap.wbmp",
        "ico": "image/x-icon",
        "jng": "image/x-jng",
        "bmp": "image/x-ms-bmp",
        "svg": "image/svg+xml",
        "svgz": "image/svg+xml",
        "webp": "image/webp",
        "woff": "application/font-woff",
        "jar": "application/java-archive",
        "war": "application/java-archive",
        "ear": "application/java-archive",
        "json": "application/json",
        "hqx": "application/mac-binhex40",
        "doc": "application/msword",
        "pdf": "application/pdf",
        "ps": "application/postscript",
        "eps": "application/postscript",
        "ai": "application/postscript",
        "rtf": "application/rtf",
        "m3u8": "application/vnd.apple.mpegurl",
        "xls": "application/vnd.ms-excel",
        "eot": "application/vnd.ms-fontobject",
        "ppt": "application/vnd.ms-powerpoint",
        "wmlc": "application/vnd.wap.wmlc",
        "kml": "application/vnd.google-earth.kml+xml",
        "kmz": "application/vnd.google-earth.kmz",
        "7z": "application/x-7z-compressed",
        "cco": "application/x-cocoa",
        "jardiff": "application/x-java-archive-diff",
        "jnlp": "application/x-java-jnlp-file",
        "run": "application/x-makeself",
        "pl": "application/x-perl",
        "pm": "application/x-perl",
        "prc": "application/x-pilot",
        "pdb": "application/x-pilot",
        "rar": "application/x-rar-compressed",
        "rpm": "application/x-redhat-package-manager",
        "sea": "application/x-sea",
        "swf": "application/x-shockwave-flash",
        "sit": "application/x-stuffit",
        "tcl": "application/x-tcl",
        "tk": "application/x-tcl",
        "der": "application/x-x509-ca-cert",
        "pem": "application/x-x509-ca-cert",
        "crt": "application/x-x509-ca-cert",
        "xpi": "application/x-xpinstall",
        "xhtml": "application/xhtml+xml",
        "xspf": "application/xspf+xml",
        "zip": "application/zip",
        "bin": "application/octet-stream",
        "exe": "application/octet-stream",
        "dll": "application/octet-stream",
        "deb": "application/octet-stream",
        "dmg": "application/octet-stream",
        "iso": "application/octet-stream",
        "img": "application/octet-stream",
        "msi": "application/octet-stream",
        "msp": "application/octet-stream",
        "msm": "application/octet-stream",
        "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        "pptx": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
        "mid": "audio/midi",
        "midi": "audio/midi",
        "kar": "audio/midi",
        "mp3": "audio/mpeg",
        "ogg": "audio/ogg",
        "m4a": "audio/x-m4a",
        "ra": "audio/x-realaudio",
        "3gpp": "video/3gpp",
        "3gp": "video/3gpp",
        "ts": "video/mp2t",
        "mp4": "video/mp4",
        "mpeg": "video/mpeg",
        "mpg": "video/mpeg",
        "mov": "video/quicktime",
        "webm": "video/webm",
        "flv": "video/x-flv",
        "m4v": "video/x-m4v",
        "mng": "video/x-mng",
        "asx": "video/x-ms-asf",
        "asf": "video/x-ms-asf",
        "wmv": "video/x-ms-wmv",
        "avi": "video/x-msvideo"
    ]
    
    static func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    static func getAttachmentType(filename:String) -> FontAwesomeType{
        guard let fileExt = filename.components(separatedBy: ".").last?.replacingOccurrences(of: " ", with: "").lowercased() else{
            return FontAwesomeType.paperclip
        }
        
        if fileExt.elementsEqual("xls") || fileExt.elementsEqual("xlsx"){
            return FontAwesomeType.fileExcelO
        }else if fileExt.elementsEqual("pdf"){
            return FontAwesomeType.filePdfO
        }else if fileExt.elementsEqual("jpg") || fileExt.elementsEqual("png") {
            return FontAwesomeType.fileImageO
        }else if fileExt.elementsEqual("doc") || fileExt.elementsEqual("docx"){
            return FontAwesomeType.fileWordO
        }else if fileExt.elementsEqual("ppt") || fileExt.elementsEqual("pptx"){
            return FontAwesomeType.filePowerpointO
        }else if fileExt.elementsEqual("txt"){
            return FontAwesomeType.fileText
        }else if fileExt.elementsEqual("zip"){
            return FontAwesomeType.fileArchiveO
        }else if fileExt.elementsEqual("mov") || fileExt.elementsEqual("mp4") || fileExt.elementsEqual("3gp") {
            return FontAwesomeType.fileMovieO
        }else{
            return FontAwesomeType.paperclip
        }
    }
    
    static func getIconString(icon:FontAwesomeType, size:CGFloat) -> NSAttributedString{
        return NSAttributedString(string: String.fa.fontAwesome(icon), attributes: [NSAttributedString.Key.font : UIFont.fa?.fontSize(size)])
    }
    
    static func getIconString(icon:FontAwesomeType, size:CGFloat, color:UIColor) -> NSAttributedString{
        return NSAttributedString(string: String.fa.fontAwesome(icon), attributes: [NSAttributedString.Key.font : UIFont.fa?.fontSize(size), NSAttributedString.Key.foregroundColor:color])
    }
    
    static func getMimeTypeForExtension(fileExtension:String?)->String{
        guard let ext = fileExtension else{
            return Utilities.DEFAULT_MIME_TYPE
        }
        if let mime = Utilities.mimeTypes[ext.replacingOccurrences(of: ".", with: "")]{
            return mime
        }else{
            return Utilities.DEFAULT_MIME_TYPE
        }
    }
    
    static func getErrorContent(exceptionMessage:String?,exceptionCode:String?) -> String?{
        if (exceptionCode?.count ?? 0 == 0) && (exceptionMessage?.count ?? 0 == 0) {
            return nil
        }
        return "\(exceptionMessage ?? "")\n\(exceptionCode ?? "")"
    }
    
    static func processApiResponse(parentViewController:UIViewController, response:JsonProtocol?, successBlock:@escaping()->Void){
        if response == nil{
            AlertDialogFactory.showUnexpectedErrorFromViewController(vc: parentViewController, doneButtonAction: nil)
        }
        else if let errorContent = response?.errorContent(){
            parentViewController.showBasicAlert(title: LocalizedStrings.error.localizedString(), message: errorContent, okTitle: nil, actionHandler: nil)
        }else{
            successBlock()
        }
    }
    
    static func checkESignStatus(parentViewControler:UIViewController,isLogin:Bool, eSignMethod:ESignType, successBlock:@escaping()->Void){
        let canUse = isLogin ? SessionManager.current.canLoginWithESign(signType: eSignMethod) : SessionManager.current.canUseESign(signType: eSignMethod)
        if !canUse {
            parentViewControler.showBasicAlert(title: .error, message: .alert_e_sign_disabled_message, okTitle: nil) { (_) in
            }
        }else{
            successBlock()
        }
    }
    
    
    static func getGradientLayer(bounds:CGRect)->CAGradientLayer{
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 200.0/255.0, green: 80.0/255.0, blue: 192.0/255.0, alpha: 1).cgColor,
            UIColor(red: 65.0/255.0, green: 88.0/255.0, blue: 208.0/255.0, alpha: 1).cgColor
            
        ]
        gradientLayer.locations = [0.18,0.90]
        let angle = 360.0 - 215.0
        let x: Double! = angle / 360.0
        let a = pow(sinf(Float(2.0 * Double.pi * ((x + 0.75) / 2.0))),2.0);
        let b = pow(sinf(Float(2*Double.pi*((x+0.0)/2))),2);
        let c = pow(sinf(Float(2*Double.pi*((x+0.25)/2))),2);
        let d = pow(sinf(Float(2*Double.pi*((x+0.5)/2))),2);
        
        gradientLayer.endPoint = CGPoint(x: CGFloat(c),y: CGFloat(d))
        gradientLayer.startPoint = CGPoint(x: CGFloat(a),y:CGFloat(b))
        gradientLayer.frame = bounds
        return gradientLayer
    }
    
    static func getBundleType()->BundleType?{
        return BundleType(rawValue: Bundle.main.bundleIdentifier ?? "")
    }
}

enum BundleType:String{
    case seneka = "com.seneka.smartsigner.v2"
    case simulator = "com.seneka.smartsigner.simulator"
    case sanayi = "com.seneka.smartsigner.v2.sanayi"
}

enum BatchOperationType:String{
    case sign
    case transfer
    case confirm
    case none
    
    func getTitle()->String?{
        switch self {
        case .sign:
            return LocalizedStrings.batch_sign.localizedString()
        case .transfer:
            return LocalizedStrings.batch_transfer.localizedString()
        case .confirm:
            return LocalizedStrings.batch_confirm.localizedString()
        default:
            return nil
        }
    }
    
    static let signTypes:[String] = [
        "IncomingForSignWithDigitalSignatureEYazisma",
        "IncomingForSign",
    ]
    
    
    static let transferTypes:[String] = [
        "IncomingFromOtherOrganization",
        "OutgoingIncomingDocumentSaveAndForward",
        "OutgoingSentWithManuelMethods",
        "OutgoingForwardFromDepartmentFolder",
        "OutgoingForwardFromUserFolder",
        "IncomingForwardedFromDepartmentToDepartment",
        "IncomingForwardedFromDepartmentToDepartmentForInfo",
        "OutgoingForDistributionApproval",
        "OutgoingDeclinedForDocumentDistribution",
        "IncomingForwardedFromDepartmentToDepartmentForNeeded",
        "IncomingForwardedFromDepartmentToDepartmentForOpinionP",
        "IncomingForwardedFromDepartmentToDepartmentForSubmissionP",
        "IncomingForwardedFromDepartmentToDepartmentForCoordineDist",
        "IncomingForwardedFromDepartmentToDepartmenttWithDigitalSignatureEYazisma",
        "IncomingForwardedFromDepartmentToUser",
        "IncomingForwardedFromDepartmentToUserForInfo",
        "IncomingForwardedFromDepartmentToUserForNeeded",
        "IncomingForwardedFromDepartmentToUserForOpinionP",
        "IncomingForwardedFromDepartmentToUserForSubmissionP",
        "IncomingForwardedFromDepartmentToUserForCoordineDist",
        "IncomingForwardedFromDepartmentWithDigitalSignatureEYazisma",
        "IncomingForwardedFromUserToDepartmentForInfo",
        "IncomingForwardedFromUserToDepartmentForNeeded",
        "IncomingForwardedFromUserToDepartmentForOpinionP",
        "IncomingForwardedFromUserToDepartmentForSubmissionP",
        "IncomingForwardedFromUserToDepartmentForCoordineDist",
        "IncomingForwardedFromUserToUser",
        "IncomingForwardedFromUserToUserForInfo",
        "IncomingForwardedFromUserToUserForInfoWithDigitalSignatureEYazisma",
        "IncomingForwardedFromUserToUserForNeeded",
        "IncomingForwardedFromUserToUserForOpinionP",
        "IncomingForwardedFromUserToUserForSubmissionP",
        "IncomingForwardedFromUserToUserForCoordineDist",
        "IncomingForwardedFromUserWithDigitalSignatureEYazisma",
        "IncomingFromDepartmentSendBack",
        "OutgoingFromDepartmentSendBack",
        "OutgoingFromUserSendBack",
        "IncomingFromUserSendBack",
        "OutgoingDraftPdfNoContentCkys",
        "OutgoingForwardedFromDepartment",
        "OutgoingForwardedFromDepartmentWithDigitalSignatureEYazisma",
        "IncomingForwardedFromDepartment",
        "OutgoingSendToBox",
        "OutgoingReplyToDocument",
        "IncomingForSendWithManuelMethodsWithDigitalSignatureEYazisma",
        "IncomingForSendWithManuelMethods"
    ]
    
    static func getBatchType(poolTypeEnum:String) -> BatchOperationType{
        if signTypes.contains(poolTypeEnum){
            return .sign
        }else if transferTypes.contains(poolTypeEnum){
            return .transfer
        }else if poolTypeEnum.elementsEqual("IncomingForSignWithoutDigitalSignature"){
            return .confirm
        }else{
            return .none
        }
    }
}

