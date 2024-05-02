//
//  GiveDelegateDateTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 28.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class GiveDelegateDateTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMainTitle:UILabel?
    @IBOutlet weak var lblMainVal:UILabel?
    @IBOutlet weak var datePicker:UIDatePicker?
    @IBOutlet weak var cardContainer:MDCCard!
    
    let df:DateFormatter = DateFormatter()
    
    var date:Date?
    var isBeginDate:Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        df.dateFormat = "dd.MM.yyyy HH:mm EEEE"
        self.datePicker?.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        ThemeManager.applyCardTheme(card: cardContainer)
        self.lblMainTitle?.textColor = .secondaryTextColor
        self.lblMainVal?.textColor = .primaryTextColor
    }
    
    func load(title:String,date:Date?,isBeginDate:Bool){
        lblMainTitle?.text = "\(title)"
        self.date = date
        self.isBeginDate = isBeginDate
        self.updateDateLabel()
        self.datePicker?.minimumDate = Date()
    }
    
    func updateDateLabel(){
        if let d = self.date{
            lblMainVal?.text = df.string(from: d)
        }else{
            lblMainVal?.text = LocalizedStrings.give_delegate_tap_here_to_choose.localizedString()
        }
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker){
        self.date = sender.date
        updateDateLabel()
        Observers.give_delegate_set_date.post(userInfo: [Observers.keys.is_begin_date : self.isBeginDate,Observers.keys.selected_date:sender.date])
    }
}
