//
//  FlowSideMenuTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 12.02.2020.
//  Copyright © 2020 Seneka. All rights reserved.
//

import UIKit

class FlowSideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblIcon:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func load(title:String,isSelected:Bool){
        self.lblTitle.text = title
        self.lblIcon.attributedText = Utilities.getIconString(icon: isSelected ? .checkCircle : .circle, size: 30, color: .primaryColor)
    }
    
}
