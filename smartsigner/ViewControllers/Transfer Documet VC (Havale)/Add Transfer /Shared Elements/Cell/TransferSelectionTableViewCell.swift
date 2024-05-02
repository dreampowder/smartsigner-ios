//
//  TransferSelectionTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 25.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit

class TransferSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var lblSubTitle:UILabel?
    @IBOutlet weak var imgSelection:UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func load(title:String?, subTitle:String?, isSelected:Bool){
        self.lblTitle?.text = title
        self.lblSubTitle?.text = subTitle
        let img = UIImage(awesomeType: isSelected ? FontAwesomeType.checkCircle : FontAwesomeType.plusCircle, size: 30, textColor: .primaryTextColor)
        self.imgSelection?.image = img
        
    }
}
