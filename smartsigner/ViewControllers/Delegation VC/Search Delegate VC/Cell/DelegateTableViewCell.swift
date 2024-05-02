//
//  DelegateTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 30.10.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents

class DelegateTableViewCell: UITableViewCell {

    @IBOutlet weak var lblActive:UILabel?
    @IBOutlet weak var lblPassive:UILabel?
    @IBOutlet weak var lblDelegatedBy:UILabel?
    @IBOutlet weak var viewActivePassive:UIView!
    @IBOutlet weak var lblBeginDate:UILabel?
    @IBOutlet weak var lblEndDate:UILabel?
    @IBOutlet weak var lblIcon:UILabel?
    @IBOutlet weak var card:MDCCard!
    let lblActivePassive:UILabel = UILabel()

    let dfJson = DateFormatter()
    let dfCellDate = DateFormatter()
    let dfCellHour = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dfJson.dateFormat = "dd/MM/yyyy HH:mm:ss"
        dfCellDate.dateFormat = "dd.MMM.yyyy"
        dfCellHour.dateFormat = "HH:mm"
        var frame = self.viewActivePassive.bounds
        
        lblActivePassive.transform = CGAffineTransform(rotationAngle: -1 * CGFloat.pi / 2)
        viewActivePassive.addSubview(lblActivePassive)
        frame.origin = CGPoint.zero
        frame.size = CGSize(width: frame.size.width, height: frame.size.height)
        lblActivePassive.frame = frame
        lblActivePassive.textAlignment = .center
        lblActivePassive.font = UIFont.systemFont(ofSize: 10)
        lblActivePassive.textColor = .secondaryTextColor
        lblActivePassive.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.lblDelegatedBy?.text = LocalizedStrings.delegated_by.localizedString()
        
        lblIcon?.attributedText = NSAttributedString(string: "\(String.fa.fontAwesome(FontAwesomeType.angleDoubleRight))", attributes: [NSAttributedString.Key.font : UIFont.fa?.fontSize(14)])
        
        ThemeManager.applyCardTheme(card: card)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func load(delegateItem:DelegationItem){
        
        self.lblActive?.text = delegateItem.activeUserNameSurname
        self.lblPassive?.text = delegateItem.passiveUserNameSurname
        
//        let attrDelegation = NSMutableAttributedString(string: delegateItem.activeUserNameSurname)
//        attrDelegation.append(NSAttributedString(string: " \(LocalisedStrings.delegated_by.localizedString()) ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray]))
//        attrDelegation.append(NSAttributedString(string: delegateItem.passiveUserNameSurname))
//        self.lblDelegation?.attributedText = attrDelegation
        
        if let date = self.dfJson.date(from: delegateItem.startDate){
            self.lblBeginDate?.text = "\(dfCellDate.string(from: date))\n\(dfCellHour.string(from: date))"
        }else{
            self.lblBeginDate?.text = delegateItem.startDate ?? "-"
        }
        
        if let date = self.dfJson.date(from: delegateItem.endDate){
            self.lblEndDate?.text = "\(dfCellDate.string(from: date))\n\(dfCellHour.string(from: date))"
        }else{
            self.lblEndDate?.text = delegateItem.endDate ?? "-"
        }
        
        self.lblActivePassive.text = delegateItem.isEffective ? LocalizedStrings.delegate_search_active.localizedString() : LocalizedStrings.delegate_search_passive.localizedString()
    }
}
