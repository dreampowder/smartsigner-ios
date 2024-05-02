//
//  DialogWithInputFieldViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 6.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents

protocol InputDialogDelegate {
    func didTapPositive(dialog:DialogWithInputFieldViewController, text:String?)
    func didTapNegative(dialog:DialogWithInputFieldViewController)
}

class DialogWithInputFieldViewController: UIViewController {

    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var btnPositive:MDCButton?
    @IBOutlet weak var btnNegative:MDCButton?
    @IBOutlet weak var txtInput:MDCTextField?
    var delegate:InputDialogDelegate?
    
    var mainTitle:String = ""
    var positiveTitle:String = LocalizedStrings.ok.localizedString()
    var negativeTitle:String = LocalizedStrings.cancel.localizedString()
    var placeholder:String = ""
    var initialValue:String?
    var customObject:Any?
    var textController:MDCTextInputControllerFilled?
    
    var acceptBlock:((_ content:String)->Void)?
    
    static func create( title:String,
                        placeholder:String,
                        positiveTitle:String?,
                        negativeTitle:String?,
                        delegate:InputDialogDelegate?
    ) -> DialogWithInputFieldViewController{
        return DialogWithInputFieldViewController.create(title: title, placeholder: placeholder, positiveTitle: positiveTitle, negativeTitle: negativeTitle, delegate: delegate, acceptBlock: nil)
    }
    
    static func create( title:String,
                        placeholder:String,
                        positiveTitle:String?,
                        negativeTitle:String?,
                        delegate:InputDialogDelegate?,
                        acceptBlock:((_ content:String)->Void)?
                     ) -> DialogWithInputFieldViewController{
        
        let storyboard = UIStoryboard(name: "DialogWithInputField", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DialogID") as! DialogWithInputFieldViewController

        if let p = positiveTitle{
            viewController.positiveTitle = p
        }
        
        if let n = negativeTitle{
            viewController.negativeTitle = n
        }
        viewController.placeholder = placeholder
        viewController.mainTitle = title
        
        viewController.delegate = delegate
        viewController.acceptBlock = acceptBlock
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnPositive?.setTitle(positiveTitle, for: .normal)
        self.btnNegative?.setTitle(negativeTitle, for: .normal)
        
        ThemeManager.applyAlertButtonTheme(button: self.btnPositive!)
        ThemeManager.applyAlertButtonTheme(button: self.btnNegative!)
//
        
        self.txtInput?.placeholder = placeholder
        self.lblTitle?.text = mainTitle
        if let val = initialValue{
            self.txtInput?.text = val
        }
        if self.negativeTitle.count == 0 {
            self.btnNegative?.isHidden = true
        }
        self.textController = MDCTextInputControllerFilled(textInput: self.txtInput!)
        ThemeManager.applySearchTextfieldTheme(textFieldController: self.textController!)
    }

    @IBAction func positiveTapped(){
        if acceptBlock != nil {
            self.dismiss(animated: true) {
                self.acceptBlock?(self.txtInput?.text ?? "")
            }
        }else{
            self.delegate?.didTapPositive(dialog:self, text: self.txtInput?.text)
        }
        
        
    }
    
    @IBAction func negativeTapped(){
        if acceptBlock != nil{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.delegate?.didTapNegative(dialog:self)
        }
    }
}
