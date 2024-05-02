//
//  TaskFilterUserSelectTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 22.11.2019.
//  Copyright © 2019 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents

protocol InputFieldFilterCellDelegate {
    func didEnterText(dataType:TaskFilterFieldType, text:String?)
    func didFocusTextInput(dataType:TaskFilterFieldType)
    func didTapClearButton(dataType:TaskFilterFieldType)
    func didTapDateInputField(dataType:TaskFilterFieldType, isBeginDate:Bool)
    func didTapClearDateButton(dataType:TaskFilterFieldType, isBeginDate:Bool)
}

class TaskFilterInputFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var txtValue:MDCTextField!
    @IBOutlet weak var txtValue2:MDCTextField!
    
    var dataType:TaskFilterFieldType = .none
    var isEditable = false
    var delegate:InputFieldFilterCellDelegate?
    
    deinit {
        self.delegate = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        txtValue.tintColor = .primaryTextColor
        txtValue.clearButtonMode = .always
        txtValue.delegate = self
//        ThemeManager.applyTextFieldTheme(textField: txtValue)
        if txtValue2 != nil {
            txtValue2.tintColor = .primaryTextColor
            txtValue2.clearButtonMode = .always
            txtValue2.delegate = self
//            ThemeManager.applyTextFieldTheme(textField: txtValue2)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func load(delegate:InputFieldFilterCellDelegate, title:String, placeholder:String?, dataType:TaskFilterFieldType, isEditable:Bool, value:String?){
        self.isEditable = isEditable
        lblTitle.text = title
        txtValue.placeholder = placeholder
        txtValue.text = value
        self.dataType = dataType
        self.delegate = delegate

    }
    
    func loadForDate(delegate:InputFieldFilterCellDelegate, title:String, dataType:TaskFilterFieldType, beginVal:String?, endVal:String?){
        self.isEditable = false
        lblTitle.text = title
        txtValue.placeholder = LocalizedStrings.begin_date.localizedString()
        txtValue2.placeholder = LocalizedStrings.end_date.localizedString()
        txtValue.text = beginVal
        txtValue2.text = endVal
        self.dataType = dataType
        self.delegate = delegate
    }
    
    @objc func didTapClearButton(){
        print("Clear!")
    }
    
}

extension TaskFilterInputFieldTableViewCell:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !isEditable{
            if dataType == .created_at || dataType == .due_date {
                self.delegate?.didTapDateInputField(dataType: self.dataType, isBeginDate: textField == txtValue)
            }else{
                self.delegate?.didFocusTextInput(dataType: self.dataType)
            }
            
        }
        return isEditable
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if dataType == .created_at || dataType == .due_date {
            self.delegate?.didTapClearDateButton(dataType: dataType, isBeginDate: textField == txtValue)
        }else{
            self.delegate?.didTapClearButton(dataType: self.dataType)
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        self.delegate?.didEnterText(dataType: self.dataType, text: txtAfterUpdate)
        return isEditable
    }
    
}
