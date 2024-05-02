//
//  TaskOperationTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 21.11.2019.
//  Copyright © 2019 Seneka. All rights reserved.
//

import UIKit

class TaskOperationTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblOperation:UILabel!
    @IBOutlet weak var constTitleHeight:NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        let attrTitle = NSMutableAttributedString(string: String.fa.fontAwesome(.tasks), attributes: [NSAttributedString.Key.font:UIFont.fa?.fontSize(14), NSAttributedString.Key.foregroundColor : UIColor.primaryTextColor])
        attrTitle.append(NSAttributedString(string: " \(LocalizedStrings.task_operations.localizedString())"))
        lblTitle.attributedText = attrTitle
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func load(operation:TaskNoteOperation, isFirstCell:Bool){
        if isFirstCell {
            let attrTitle = NSMutableAttributedString(string: String.fa.fontAwesome(.tasks), attributes: [NSAttributedString.Key.font:UIFont.fa?.fontSize(14), NSAttributedString.Key.foregroundColor : UIColor.primaryTextColor])
            attrTitle.append(NSAttributedString(string: " \(LocalizedStrings.task_operations.localizedString())"))
            lblTitle.attributedText = attrTitle
        }else{
            lblTitle.attributedText = nil
        }
        constTitleHeight.constant = isFirstCell ? 20.0 : 0.0
        lblOperation.text = operation.uIString
    }
}
