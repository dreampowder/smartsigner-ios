//
//  CorporationCollectionViewCellCollectionViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 1.10.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import Kingfisher
import MaterialComponents
class ServiceCollectionViewCell: MDCCardCollectionCell {

    @IBOutlet weak  var imgLogo:UIImageView?
    @IBOutlet weak  var lblTitle:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        self.shadowElevation(for: .normal)
        self.contentView.backgroundColor = .serviceItemBackground
        self.backgroundColor = .serviceItemBackground
        self.lblTitle?.textColor = .primaryTextColor
        
    }
    
    func loadWithService(service:ServiceData?){
        if let _ = service , let url = URL(string: service?.imageUrl ?? ""){
            self.imgLogo?.kf.setImage(with: url)
            self.lblTitle?.text = service?.projectName
        }
    }
}
