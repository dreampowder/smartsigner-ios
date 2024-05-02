//
//  DistributionFlowDetailTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 7.02.2020.
//  Copyright © 2020 Seneka. All rights reserved.
//

import UIKit

class DistributionFlowDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var lblDistributionType:UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.lblDistributionType?.textColor = UIColor.primaryColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func load(distribution:DaDistribution){
        if distribution.targetDepartmentId != nil{
            self.lblTitle?.text = distribution.targetDepartmentName
        }else if distribution.targetUserId != nil{
            self.lblTitle?.text = "\(distribution.targetUserName ?? "") \(distribution.targetUserSurname ?? "")"
        }
        self.lblDistributionType?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        guard let distributionType = DocumentDistrubutionTypeEnum(rawValue: distribution.documentDistributionTypeEnum) else{
            self.lblDistributionType?.text = ""
            return
        }
        self.lblDistributionType?.text = distributionType.stringValue().localizedString()
    }
    
}
