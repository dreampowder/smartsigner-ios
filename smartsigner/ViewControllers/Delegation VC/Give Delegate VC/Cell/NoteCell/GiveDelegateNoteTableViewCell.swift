//
//  GiveDelegateNoteTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 28.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class GiveDelegateNoteTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var textView:UITextView?
    @IBOutlet weak var viewTextViewContainer:UIView?
    @IBOutlet weak var constTextViewHeight:NSLayoutConstraint?
    @IBOutlet weak var cardContainer:MDCCard!
    var messageController:MDCTextInputControllerFilled?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.lblTitle?.text = LocalizedStrings.give_delegation_enter_note_placeholder.localizedString()
        viewTextViewContainer?.layer.cornerRadius = 2.0
        viewTextViewContainer?.clipsToBounds = true
        textView?.delegate = self
        ThemeManager.applyCardTheme(card: cardContainer)
        viewTextViewContainer?.backgroundColor = .tableviewBackground
        textView?.textColor = .primaryTextColor
    }
    
    func load(note:String){
        self.textView?.text = note
    }
}

extension GiveDelegateNoteTableViewCell:UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        Observers.give_delegate_note.post(userInfo: [Observers.keys.string_value : textView.text ?? ""])
    }
    
}
