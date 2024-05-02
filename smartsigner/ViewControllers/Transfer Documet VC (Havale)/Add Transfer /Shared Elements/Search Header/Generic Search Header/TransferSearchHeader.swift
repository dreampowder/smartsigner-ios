//
//  TransferSearchHeader.swift
//  smartsigner
//
//  Created by Serdar Coskun on 26.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents

class TransferSearchHeader: UIView {

    @IBOutlet weak var txtSearchQuery:MDCTextField?
    @IBOutlet weak var lblSearchButton:UILabel?
    var controllers:[MDCTextInputController] = []
    var searchDelegate:TransferSearchHeaderProtocol?
 
    override func awakeFromNib() {
        
        self.backgroundColor = .primaryColor
        controllers = [MDCTextInputControllerUnderline(textInput: self.txtSearchQuery)]
        self.txtSearchQuery?.placeholder = LocalizedStrings.department_search_placeholder.localizedString()
        
        lblSearchButton?.attributedText = Utilities.getIconString(icon: FontAwesomeType.search, size: 20)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearchButton))
        self.lblSearchButton?.isUserInteractionEnabled = true
        self.lblSearchButton?.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapSearchButton(){
        searchDelegate?.didTapSearchButton()
    }
}
