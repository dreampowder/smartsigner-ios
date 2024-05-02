//
//  AttachmentItemCollectionViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 20.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class AttachmentItemCollectionViewCell: MDCCollectionViewCell {

    @IBOutlet weak var imgAttachment:UIImageView?
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var lblSubtitle:UILabel?
    @IBOutlet weak var innerView:UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.innerView?.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.innerView?.layer.borderWidth = 0.5
        self.innerView?.layer.cornerRadius = 4.0
        self.backgroundColor = .clear
        self.lblTitle?.textColor = .primaryTextColor
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.innerView?.backgroundColor = .serviceItemBackground
        self.imgAttachment?.tintColor = .primaryTextColor
        self.imgAttachment?.image = self.imgAttachment?.image?.withRenderingMode(.alwaysTemplate)
    }

}
