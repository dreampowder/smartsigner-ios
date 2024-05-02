//
//  SideMenuTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 23.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var imgFolder:UIImageView?
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var imageLeftConstraint:NSLayoutConstraint?
    @IBOutlet weak var viewDocumentCount:UIView?
    @IBOutlet weak var lblDocumentCount:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.indentationWidth = 8.0
        self.tintColor = UIColor.primaryColor
        self.viewDocumentCount?.backgroundColor = UIColor.primaryColor.withAlphaComponent(0.3)
        self.viewDocumentCount?.layer.cornerRadius = 4.0
        self.viewDocumentCount?.layer.masksToBounds = true
        self.lblDocumentCount?.textColor = .secondaryTextColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func loadWithFolder(node:Folder, isExpanded:Bool){
//        if node.isExpandable {
//            if isExpanded {
//                self.imgFolder?.image = UIImage(named: "folder_open")
//            } else {
//                self.imgFolder?.image = UIImage(named: "folder_closed")
//            }
//        } else {
//            self.imgFolder?.image = nil
//        }
        self.imgFolder?.tintColor = .primaryColor
        self.imgFolder?.image = UIImage(named: "folder_open")?.withRenderingMode(.alwaysTemplate)
        self.lblTitle?.text = node.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let leftOffset =  CGFloat(node.folderLevel) * indentationWidth
        self.imageLeftConstraint?.constant = leftOffset
        self.layoutIfNeeded()
        
        self.lblDocumentCount?.isHidden = node.documentCount ?? 0 == 0
        self.lblDocumentCount?.text = "\(node.documentCount ?? 0)"
    }
}
