//
//  DepartmentSearchHeader.swift
//  smartsigner
//
//  Created by Serdar Coskun on 23.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents

class DepartmentSearchHeader: UIView {

    @IBOutlet weak var txtDepartmentType:MDCTextField?
    @IBOutlet weak var txtSearchQuery:MDCTextField?
    @IBOutlet weak var lblSearchButton:UILabel?
    var controllers:[MDCTextInputController] = []
    
    let departmentTypes:[LocalizedStrings] = [
       LocalizedStrings.depoartment_type_empty,
       LocalizedStrings.depoartment_type_merkez_birim,
       LocalizedStrings.depoartment_type_bagli_kurulus,
       LocalizedStrings.depoartment_type_tasra_birimi,
       LocalizedStrings.depoartment_type_diger_kamu_kurum,
//       LocalisedStrings.depoartment_type_sirket,
//       LocalisedStrings.depoartment_type_sahis
    ]
    
    var departmentPicker:UIPickerView = UIPickerView()
    var selectedDepartment:DepoartmentTypeEnum?
    
    var searchDelegate:TransferSearchHeaderProtocol?
    
    override func awakeFromNib() {
        
        self.backgroundColor = .primaryColor
        controllers = [MDCTextInputControllerUnderline(textInput: self.txtDepartmentType),
                       MDCTextInputControllerUnderline(textInput: self.txtSearchQuery)]
        self.txtDepartmentType?.placeholder = LocalizedStrings.department_type_select_placeholder.localizedString()
        self.txtSearchQuery?.placeholder = LocalizedStrings.department_search_placeholder.localizedString()
        self.departmentPicker.delegate = self
        self.txtDepartmentType?.inputView = self.departmentPicker
        self.txtDepartmentType?.clearButtonMode = .never
        self.txtDepartmentType?.tintColor = .clear
//        self.imgSearchButton?.image = UIImage(awesomeType: .search, size: 20, textColor: .darkGray)
        lblSearchButton?.attributedText = Utilities.getIconString(icon: FontAwesomeType.search, size: 20)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearchButton))
        self.lblSearchButton?.isUserInteractionEnabled = true
        self.lblSearchButton?.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapSearchButton(){
        searchDelegate?.didTapSearchButton()
    }
}

extension DepartmentSearchHeader:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.departmentTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return departmentTypes[row].localizedString()
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedDepartment = DepoartmentTypeEnum.allItems[row]
        self.txtDepartmentType?.text = departmentTypes[row].localizedString()
    }
    
}
