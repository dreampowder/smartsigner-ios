//
//  TaskUserCollectionViewCell.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 21.11.2019.
//  Copyright © 2019 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents

class TaskUserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblUserName:UILabel!
    @IBOutlet weak var lblAsssignmentType:UILabel!
    @IBOutlet weak var viewAssignmentContainer:UIView!
//    @IBOutlet weak var btnDelete:UIButton!
    @IBOutlet weak var card:MDCCard!
    
    var user:TaskNoteUser?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.lblUserName.textColor = .primaryTextColor
        MDCIcons.imageFor_ic_info()
        ThemeManager.applyCardTheme(card: card)
    }
    
    @objc func didTapDeleteButton(){
        guard let user = self.user else {return}
        Observers.task_note_remove_user.post(userInfo: [Observers.keys.task_note_user : user ])
    }
    
    func load(user:TaskNoteUser){
        self.user = user
        self.lblUserName.text = user.userFullName
        if let type = user.assignmentType, let title = type.first?.uppercased(){
            self.viewAssignmentContainer.isHidden = false
            self.lblAsssignmentType.text = title
        }else{
            self.viewAssignmentContainer.isHidden = true
            self.lblAsssignmentType.text = ""
        }
        
    }

}
