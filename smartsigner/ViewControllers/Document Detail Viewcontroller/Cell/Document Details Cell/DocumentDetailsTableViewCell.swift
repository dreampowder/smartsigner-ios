//
//  DocumentTitleTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 25.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class DocumentDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblFrom:UILabel?
    @IBOutlet weak var lblTo:UILabel?
    @IBOutlet weak var lblDate:UILabel?
    @IBOutlet weak var lblType:UILabel?
    @IBOutlet weak var lblNumber:UILabel?
    @IBOutlet weak var lblBarcode:UILabel?
    @IBOutlet weak var lblProcess:UILabel?
    @IBOutlet weak var btnShowDetails:UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnShowDetails?.tintColor = .primaryTextColor
        self.btnShowDetails?.addTarget(self, action: #selector(didTapExpandButton), for: .touchUpInside)
        self.btnShowDetails?.setTitle(nil, for: .normal)
        self.selectionStyle = .none
        self.lblFrom?.textColor = .primaryTextColor
        self.lblTo?.textColor = .secondaryTextColor
        self.lblDate?.textColor = .secondaryTextColor
        self.lblNumber?.textColor = .secondaryTextColor
        self.lblBarcode?.textColor = .secondaryTextColor
        self.lblType?.textColor = .secondaryTextColor
        self.lblProcess?.isHidden = true
    }
    
    func loadWithDocument(document:PoolItem?, isExpanded:Bool){
        self.lblFrom?.text = document?.fromSentence ?? ""
        self.lblTo?.text = "\(document?.toSentence ?? "")"
        self.lblDate?.text = document?.sentDateAsString.getRelativeDateString(inputDateFormat: nil) ?? ""
        self.lblNumber?.text = "\(LocalizedStrings.number.localizedString()): \(document?.documentNo ?? "-")"
        self.lblBarcode?.text = "\(LocalizedStrings.barcode.localizedString()): \(String.init(format: "%011d", document?.documentId ?? 0))"
        self.lblType?.text = document?.poolTypeEnumString
        
        self.btnShowDetails?.setImage(UIImage(awesomeType: isExpanded ? .angleDown : .angleLeft, size: 10, textColor: .primaryTextColor), for: .normal)
        
        
    }
    
    @objc func didTapExpandButton(){
        Observers.toggle_document_detail.post(userInfo: nil)
    }
}
