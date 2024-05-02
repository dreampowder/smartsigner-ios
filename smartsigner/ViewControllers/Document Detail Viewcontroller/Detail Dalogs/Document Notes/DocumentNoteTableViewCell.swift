//
//  DocumentNoteTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 25.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class DocumentNoteTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView:MDCCard?
    @IBOutlet weak var lblNote:UILabel?
    @IBOutlet weak var lblNoteTaker:UILabel?
    @IBOutlet weak var lblDate:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cardView?.cornerRadius = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadWithNote(note:DocumentNote){
        self.lblNote?.text = note.note;
        self.lblNoteTaker?.text = note.ownerUserName
        self.lblDate?.text = note.noteDateAsString.getRelativeDateString(inputDateFormat: nil)
    }
    
}
