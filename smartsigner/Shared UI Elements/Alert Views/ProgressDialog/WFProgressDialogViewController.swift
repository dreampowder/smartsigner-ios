//
//  WFProgressDialogViewController.swift
//  worfact-student
//
//  Created by Serdar Coskun on 12.08.2018.
//  Copyright © 2018 Serdar Coskun. All rights reserved.
//

import UIKit
import MaterialComponents

class WFProgressDialogViewController: UIViewController {

    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var lblMessage:UILabel?
    @IBOutlet weak var activityIndicator:MDCActivityIndicator?

    
    var alertTitle:String?
    var alertMessage:String?
    var didLayoutSubviews:Bool = false
    var isIndeterminate:Bool = true
    
    convenience init(title:String?, message:String?) {
        self.init(nibName: "WFProgressDialogViewController", bundle: .main)
        self.alertTitle = title ?? ""
        self.alertMessage = message ?? ""
    }
    
    convenience init(title:String?, message:String?, isIndeterminate:Bool){
        self.init(title: title, message: message)
        self.isIndeterminate = isIndeterminate
    }
    
    override func viewDidLayoutSubviews() {
        if !didLayoutSubviews{

            
            
            activityIndicator?.radius = 26
            activityIndicator?.strokeWidth = 4
            self.view.layer.cornerRadius = 2
            self.view.layer.masksToBounds = true
            if isIndeterminate {
                activityIndicator?.indicatorMode = .indeterminate
            }else{
                activityIndicator?.indicatorMode = .determinate
            }
            
            activityIndicator?.sizeToFit()
            activityIndicator?.startAnimating()
            lblTitle?.textColor = UIColor.secondaryDarkColor
            lblMessage?.textColor = UIColor.secondaryColor
            updateLabels()
            //            16 + titleheight + 60 + 16 + messageHeight
            let titleSize = CGSize(width: lblTitle?.bounds.size.width ?? 30, height: CGFloat.greatestFiniteMagnitude)
            let titleHeight:CGFloat = lblTitle?.sizeThatFits(titleSize).height ?? 30
            
            let messageSize = CGSize(width: lblMessage?.bounds.size.width ?? 30, height: CGFloat.greatestFiniteMagnitude)
            let messageHeight:CGFloat = lblMessage?.sizeThatFits(messageSize).height ?? 30
            
            let height = 16 + titleHeight + 60 + 16 + messageHeight + 32
            self.preferredContentSize = CGSize(width: 100 , height: height)
            
            didLayoutSubviews = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateLabels(){
        lblTitle?.text = alertTitle
        lblMessage?.text = alertMessage
    }
    @discardableResult
    func setTitle(title:LocalizedStrings) -> WFProgressDialogViewController{
        alertTitle = title.localizedString()
        updateLabels()
        return self
    }
    
    @discardableResult
    func setTitle(title:String) -> WFProgressDialogViewController{
        alertTitle = title
        updateLabels()
        return self
    }
    
    @discardableResult
    func setMessage(message:LocalizedStrings) -> WFProgressDialogViewController{
        alertMessage = message.localizedString()
        updateLabels()
        return self
    }
    @discardableResult
    func setMessage(message:String) -> WFProgressDialogViewController{
        alertMessage = message
        updateLabels()
        return self
    }
}
