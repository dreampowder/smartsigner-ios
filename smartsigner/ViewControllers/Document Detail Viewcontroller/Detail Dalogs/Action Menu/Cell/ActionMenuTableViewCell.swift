//
//  ActionMenuTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 4.01.2019.
//  Copyright © 2019 Seneka. All rights reserved.
//

import UIKit

class ActionMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var lblIcon:UILabel?
    @IBOutlet weak var lblTitle:UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
