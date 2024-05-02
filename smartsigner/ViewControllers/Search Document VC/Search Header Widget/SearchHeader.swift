//
//  SearchHeader.swift
//  smartsigner
//
//  Created by Serdar Coskun on 27.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents

protocol SearchHeaderProtocol {
    func didTapSearchButton(searchObject:SearchObject)
    func didTapCancelButton()
    func didTapDateField(date:Date?,isBeginDate:Bool)
    func didTapBackButton()
}

struct SearchObject {
    let query:String?
    let beginDate:Date?
    let endDate:Date?
    let documentNumber:String?
    let barcodeNumber:String?

}

class SearchHeader: MDCShadowView {

    @IBOutlet weak var btnToggleSearch:UIButton?
    @IBOutlet weak var btnDetailedSearch:MDCButton?
    @IBOutlet weak var btnBack:UIButton?
    
    @IBOutlet weak var searchBar:UISearchBar?

    @IBOutlet weak var txtBeginDate:MDCTextField?
    @IBOutlet weak var txtEndDate:MDCTextField?
    @IBOutlet weak var txtDocumentNumber:MDCTextField?
    @IBOutlet weak var txtBarcodeNumber:MDCTextField?

    var textControllers:[MDCTextInputControllerFilled] = []
    
    var searchQueryController:MDCTextInputControllerUnderline?;
    
    var delegate:SearchHeaderProtocol?
    
    var beginDate:Date?
    var endDate:Date?
    var dateFormatter = DateFormatter()
    
    deinit {
        Observers.did_select_date.removeObserver(observer: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dateFormatter.dateFormat = "dd.MM.yyyy"
        searchBar?.delegate = self
//        self.btnDetailedSearch?.setImage(UIImage(awesomeType: .search, size: 20.0, textColor: .white), for: .normal)
        self.btnDetailedSearch?.tintColor = .white
        self.btnDetailedSearch?.setTitle(LocalizedStrings.detailed_search.localizedString(), for: .normal)
        self.btnDetailedSearch?.imageView?.contentMode = .scaleAspectFit
        self.btnDetailedSearch?.setElevation(.cardResting, for: .normal)
        ThemeManager.applyButtonColorTheme(button: self.btnDetailedSearch!)
        
        self.txtBeginDate?.placeholder = LocalizedStrings.begin_date.localizedString()
        self.txtEndDate?.placeholder = LocalizedStrings.end_date.localizedString()
        self.txtDocumentNumber?.placeholder = LocalizedStrings.document_number.localizedString()
        self.txtBarcodeNumber?.placeholder = LocalizedStrings.document_barcode_or_subject.localizedString()
        
        self.txtBeginDate?.delegate = self
        self.txtEndDate?.delegate = self
        
        self.toggleAdvancedSearch(isOpen: false)
        Observers.did_select_date.addObserver(observer: self, selector: #selector(didReceiveSearchNotification(notification:)))
        self.btnBack?.setImage(UIImage(awesomeType: FontAwesomeType.angleLeft, size: 10, textColor: .white), for: .normal)
        self.btnBack?.setTitle("", for: .normal)
        self.btnBack?.tintColor = .white
        self.btnBack?.addTarget(self, action: #selector(self.didTapBackButton), for: .touchUpInside)
        
        self.txtBeginDate?.clearButtonMode = .always
        self.txtEndDate?.clearButtonMode = .always
        
        self.txtBeginDate?.tintColor = .secondaryTextColor
        self.txtEndDate?.tintColor = .secondaryTextColor
        self.txtDocumentNumber?.tintColor = .secondaryTextColor
        self.txtBarcodeNumber?.tintColor = .secondaryTextColor
    }
    
    @objc func didTapBackButton(){
        self.delegate?.didTapBackButton()
    }
    
    @objc func didReceiveSearchNotification(notification:Notification){
        guard
            let sourceView = notification.userInfo?[Observers.keys.source_view.rawValue] as? String,
            let selectedDate = notification.userInfo?[Observers.keys.selected_date.rawValue] as? Date else{
                return
        }
        
        let isBegin:Bool = (sourceView == "SearchHeader-begin")
        if isBegin{
            self.beginDate = selectedDate
            self.txtBeginDate?.text = self.dateFormatter.string(from: selectedDate)
        }else{
            self.endDate = selectedDate
            self.txtEndDate?.text = self.dateFormatter.string(from: selectedDate)
        }
    }
    
    @IBAction func didTapDetailedSearch(){
        self.delegate?.didTapSearchButton(searchObject: getSearchObject())
    }
    
    func getSearchObject()->SearchObject{
        let searchObject = SearchObject(query: searchBar?.text, beginDate: self.beginDate, endDate: self.endDate, documentNumber: self.txtDocumentNumber?.text, barcodeNumber: self.txtBarcodeNumber?.text)
        return searchObject
    }
    
    func toggleAdvancedSearch(isOpen:Bool){
        let textFields:[MDCTextField?] = [txtBeginDate,txtEndDate,txtDocumentNumber,txtBarcodeNumber]
        UIView.animate(withDuration: 0.5) {
            for textField in textFields{
                textField?.alpha = isOpen ? 1 : 0
                if !isOpen{
                    textField?.text = nil
                }
            }
            self.btnDetailedSearch?.alpha = isOpen ? 1 : 0
        }
    }
}

extension SearchHeader:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.delegate?.didTapDateField(date: self.beginDate, isBeginDate: textField == self.txtBeginDate)
        return false
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == self.txtBeginDate {
            self.beginDate = nil
        }else if textField == self.txtEndDate{
            self.endDate = nil
        }
        return true
    }
}

extension SearchHeader:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.delegate?.didTapSearchButton(searchObject: getSearchObject())
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.delegate?.didTapCancelButton()
    }
}
