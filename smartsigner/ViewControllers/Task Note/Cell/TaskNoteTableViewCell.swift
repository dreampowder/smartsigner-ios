//
//  TaskNoteTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 21.11.2019.
//  Copyright © 2019 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class TaskNoteTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNumberTitle:UILabel?
    @IBOutlet weak var lblNumbverVal:UILabel?
    @IBOutlet weak var lblCreatorTitle:UILabel?
    @IBOutlet weak var lblCreatorVal:UILabel?
    @IBOutlet weak var lblResponsiveTitle:UILabel?
    @IBOutlet weak var lblResponsiveVal:UILabel?
    @IBOutlet weak var lblStatusTitle:UILabel?
    @IBOutlet weak var lblStatusVal:UILabel?
    @IBOutlet weak var lblCreatedAtTitle:UILabel?
    @IBOutlet weak var lblCreatedAtVal:UILabel?
    @IBOutlet weak var lblEndAtTitle:UILabel?
    @IBOutlet weak var lblEndAtVal:UILabel?
    @IBOutlet weak var lblDocumentTitle:UILabel?
    @IBOutlet weak var lblDocumentVal:UILabel?
    
    @IBOutlet weak var card:MDCCard!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblNumberTitle?.text = LocalizedStrings.task_number.localizedString()
        lblCreatorTitle?.text = LocalizedStrings.task_creator.localizedString()
        lblResponsiveTitle?.text = LocalizedStrings.task_responsive.localizedString()
        lblStatusTitle?.text = LocalizedStrings.task_status.localizedString()
        lblCreatedAtTitle?.text = LocalizedStrings.task_created_at.localizedString()
        lblEndAtTitle?.text = LocalizedStrings.task_end_at.localizedString()
        lblDocumentTitle?.text = LocalizedStrings.task_document.localizedString()
        ThemeManager.applyCardTheme(card: card)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        ThemeManager.applyCardTheme(card: self.card)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func load(note:TaskNote){
        lblNumbverVal?.text = "\(note.id ?? 0)"
        lblCreatorVal?.text = note.creatorUserFullname ?? "-"
//        lblResponsiveVal?.text = note.assignedToUsers ?? "-"
        if note.taskNoteUsers.count ?? 0 == 0{
            lblResponsiveVal?.text = "-"
        }else{
            var userStr = ""
            note.taskNoteUsers.forEach({userStr = "\(userStr)\(userStr.count == 0 ? "":", ")\($0.userFullName ?? "")"})
            lblResponsiveVal?.text = userStr
        }
        lblStatusVal?.text = note.status ?? "-"
        lblCreatedAtVal?.text = note.creationDate ?? "-"
        lblEndAtVal?.text = note.dueDate ?? "-"
        lblDocumentVal?.text = note.documentSubject ?? "-"
    }
}
