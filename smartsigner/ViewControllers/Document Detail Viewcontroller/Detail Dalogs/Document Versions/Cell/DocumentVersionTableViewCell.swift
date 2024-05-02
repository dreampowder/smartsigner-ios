//
//  DocumentVersionTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 14.10.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit

class DocumentVersionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var lblDate:UILabel?
    @IBOutlet weak var lblVersion:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadCell(version:DocumentVersion) {
        self.lblTitle?.text = version.subject
        self.lblDate?.text = version.versionDate
        self.lblVersion?.text = "\(LocalizedStrings.version.localizedString()) - \(version.versionNumber ?? "")"
    }
}
