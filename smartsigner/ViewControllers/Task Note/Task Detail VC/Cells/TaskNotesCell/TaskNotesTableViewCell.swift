//
//  TaskNotesTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 21.11.2019.
//  Copyright © 2019 Seneka. All rights reserved.
//

import UIKit

class TaskNotesTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblNote:UILabel!
   
   override func awakeFromNib() {
       super.awakeFromNib()
       self.backgroundColor = .clear
       self.contentView.backgroundColor = .clear
       let attrTitle = NSMutableAttributedString(string: String.fa.fontAwesome(.checkCircle), attributes: [NSAttributedString.Key.font:UIFont.fa?.fontSize(14), NSAttributedString.Key.foregroundColor : UIColor.primaryTextColor])
       attrTitle.append(NSAttributedString(string: " \(LocalizedStrings.task_notes.localizedString())"))
       lblTitle.attributedText = attrTitle
   }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func load(note:String){
        lblNote.text = note
    }
    
}
