//
//  GiveDelegateSwitchTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 28.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class GiveDelegateSwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var imgSelected:UIImageView?
    @IBOutlet weak var cardContainer:MDCCard!
    
    let iconSize:CGFloat = 30.0
    
    var type:GiveDelegationType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        imgSelected?.image = UIImage(awesomeType: FontAwesomeType.circle, size: iconSize, textColor: .darkGray)
        ThemeManager.applyCardTheme(card: cardContainer)
    }
    
    func loadCell(type:GiveDelegationType,isSelected:Bool){
        self.lblTitle?.text = type.getLocalisedString()
        imgSelected?.image = UIImage(awesomeType: isSelected ? .checkCircle : .circle, size: iconSize, textColor: isSelected ? .primaryTextColor : .secondaryTextColor)
        self.type = type
    }
}
