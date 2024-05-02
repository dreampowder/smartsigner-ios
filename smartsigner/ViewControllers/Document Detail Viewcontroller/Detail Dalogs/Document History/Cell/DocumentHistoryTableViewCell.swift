//
//  DocumentHistoryTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 14.10.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class DocumentHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var chipView:MDCChipView?
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var lblDate:UILabel?
    @IBOutlet weak var lblUsers:UILabel?
    @IBOutlet weak var lblTargetUnit:UILabel?
    @IBOutlet weak var lblDescription:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadCell(history:DocumentHistory){
        self.lblTitle?.text = history.documentMotionTypeEnumToString
        self.lblDate?.text = history.motionDate
        if history.targetDepartmentToString != nil && history.targetDepartmentToString.count > 0 {
            self.lblTargetUnit?.attributedText = self.getTitleAndText(title: .target_department, text: history.targetDepartmentToString)
        }else{
            self.lblTargetUnit?.text = nil
        }
        if history.descriptionField != nil && history.descriptionField.count > 0 {
            self.lblDescription?.attributedText = getTitleAndText(title: .description, text: history.descriptionField)
        }else{
            self.lblDescription?.text = nil
        }
        
        let attrString = NSMutableAttributedString(attributedString: NSAttributedString(string: history.sourceUserToString))
        if history.targetUserToString != nil && history.targetUserToString.count > 0{
            attrString.append(NSAttributedString(string: "  \(String.fa.fontAwesome(.arrowRight))  ", attributes: [NSAttributedString.Key.font : UIFont.fa?.fontSize(self.lblUsers?.font.pointSize ?? 15)]))
            attrString.append(NSAttributedString(string: history.targetUserToString))
        }
        self.lblUsers?.attributedText = attrString
    }
    
    func getTitleAndText(title:LocalizedStrings, text:String) -> NSMutableAttributedString{
        var attrTargetUnit = NSMutableAttributedString(string: "\(title.localizedString()): ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: self.lblTargetUnit?.font.pointSize ?? 14, weight: UIFont.Weight.semibold)])
        attrTargetUnit.append(NSAttributedString(string: text))
        return attrTargetUnit
    }
}
