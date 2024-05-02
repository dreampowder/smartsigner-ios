//
//  DistributionFlowTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 7.02.2020.
//  Copyright © 2020 Seneka. All rights reserved.
//

import UIKit

class DistributionFlowTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTypeIcon:UILabel?
    @IBOutlet weak var lblSender:UILabel?
    @IBOutlet weak var lblStatus:UILabel?
    @IBOutlet weak var lblDescription:UILabel?
    @IBOutlet weak var lblStatusIcon:UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func load(flow:DistributionFlowDaFlow) {
        self.lblStatus?.text = ""
        self.lblTypeIcon?.text = ""
        self.lblSender?.text = ""
        self.lblDescription?.text = ""
        guard let status:DaFlowStateEnum = DaFlowStateEnum(rawValue: flow.daFlowStateEnum) else{
            return
        }
        var iconColor = UIColor.gray
        if status != DaFlowStateEnum.finished{
            iconColor = .primaryColor
        }
        self.lblStatus?.text = status.getTitle().localizedString()
        self.lblStatusIcon?.attributedText = Utilities.getIconString(icon: status.getIcon(), size: 28, color: UIColor.primaryTextColor)
        if flow.userId != nil { //User
            self.lblTypeIcon?.attributedText = Utilities.getIconString(icon: .user, size: 28, color: iconColor )
            self.lblSender?.text = "\(flow.userName ?? "") \(flow.userSurname ?? "")"
        }else if flow.departmentId != nil{ //Department
            self.lblTypeIcon?.attributedText = Utilities.getIconString(icon: .building, size: 28, color: iconColor )
            self.lblSender?.text = flow.departmentName
        }
        var operatorFullName = "\(flow.operatorUserName ?? "") \(flow.operatorUserSurname ?? "")"
        if flow.notes != nil && flow.notes.count > 0{
            operatorFullName.append("\n")
            let attributedString = NSMutableAttributedString(string: operatorFullName,attributes: [NSAttributedString.Key.font:self.lblSender?.font ?? UIFont.systemFont(ofSize: 18),NSAttributedString.Key.foregroundColor:UIColor.primaryTextColor])
            attributedString.append(Utilities.getIconString(icon: .stickyNote, size: 16,color: UIColor.primaryColor))
            attributedString.append(NSAttributedString(string:  "  \(flow.notes ?? "")", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16, weight: .light),NSAttributedString.Key.foregroundColor:UIColor.secondaryTextColor]))
            self.lblDescription?.attributedText = attributedString
        }else{
            self.lblDescription?.text = operatorFullName
        }
        
    }
    
}
