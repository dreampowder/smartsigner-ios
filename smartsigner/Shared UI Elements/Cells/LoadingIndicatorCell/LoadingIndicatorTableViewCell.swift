//
//  LoadingIndicatorTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 6.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class LoadingIndicatorTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator:NVActivityIndicatorView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.activityIndicator?.color = .primaryColor
        self.activityIndicator?.tintColor = .primaryColor
        self.activityIndicator?.type = .ballScaleMultiple
        
        self.activityIndicator?.startAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
