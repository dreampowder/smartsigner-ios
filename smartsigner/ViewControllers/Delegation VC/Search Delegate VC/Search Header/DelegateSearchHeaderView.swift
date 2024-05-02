//
//  DelegateSearchHeaderView.swift
//  smartsigner
//
//  Created by Serdar Coskun on 30.10.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents

protocol SearchHeaderDelegate {
    func didTapSearch(searchRequest:ListDelegateRequest)
    func didTapShowDatePicker(selectedDate:Date?)
}

class DelegateSearchHeaderView: UIView {

    @IBOutlet weak var viewDelegateSearch:UIView?
    @IBOutlet weak var viewMainUserSearch:UIView?
    @IBOutlet weak var sgmAktifPasif:UISegmentedControl?
    @IBOutlet weak var sgmYururluk:UISegmentedControl?
    @IBOutlet weak var btnSearch:MDCButton?
    @IBOutlet weak var btnClearDate:UIButton?
    
    @IBOutlet weak var txtDelegate:MDCTextField?
    @IBOutlet weak var txtMainUser:MDCTextField?
    
    var didSetupView = false
    var searchCotrollerDelegate:UISearchDisplayDelegate?
    let searchControllerDelegate = UISearchController(searchResultsController: UserSearchResultsTableViewController())
    let searchControllerMainUser = UISearchController(searchResultsController: UserSearchResultsTableViewController())
    var selectedDelegate:User?
    var selectedMainUser:User?
    
    var dfSelected = DateFormatter()
    var dfRequest = DateFormatter()
    var delegate:SearchHeaderDelegate?
    var selectedDate:Date?
    
    var parentVC:UIViewController?
    
    deinit {
        Observers.delegate_search_select.removeObserver(observer: self)
        Observers.did_select_date.removeObserver(observer: self)
    }
    
    static func instantinateView(parentVC:UIViewController) -> DelegateSearchHeaderView{
        let view = Bundle.main.loadNibNamed("DelegateSearchHeaderView", owner: self, options: nil)?.first as! DelegateSearchHeaderView
        ThemeManager.applyButtonColorTheme(button: view.btnSearch!)
        
        view.dfSelected.dateFormat = "dd.MM.yyyy"
        view.dfRequest.dateFormat = "dd/MM/yyyy"
        view.txtDelegate?.delegate = view
        view.txtMainUser?.delegate = view
        view.parentVC = parentVC
        view.txtMainUser?.placeholder = LocalizedStrings.delegate_search_main_name_placeholder.localizedString()
        view.txtDelegate?.placeholder = LocalizedStrings.delegate_search_delegate_name_placeholder.localizedString()
        Observers.delegate_search_select.addObserver(observer: view, selector: #selector(didReceiveSelectUserNotification(notification:)))
        view.txtMainUser?.clearButtonMode = .always
        view.txtDelegate?.clearButtonMode = .always
        view.backgroundColor = .clear
        view.viewDelegateSearch?.backgroundColor = UIColor.primaryColor
        view.viewMainUserSearch?.backgroundColor = UIColor.primaryColor
        view.sgmYururluk?.superview?.backgroundColor = UIColor.primaryColor
        view.btnSearch?.superview?.backgroundColor = UIColor.primaryColor
        return view
    }
    
    func showSearchUserVC(sender:MDCTextField){
        var model = GiveDelegateModel()
        model.delegateUser = self.selectedDelegate
        model.mainUser = self.selectedMainUser
        model.isUsingModelForSearch = true
        let vc = SearchDelegateViewController(model: model, isDelegate: sender == self.txtDelegate)
        let navCon = UINavigationController(rootViewController: vc)
        navCon.isNavigationBarHidden = true
        self.parentVC?.present(navCon, animated: true, completion: nil)
    }

    @objc func didReceiveSelectUserNotification(notification:Notification){
        guard let model = notification.userInfo?[Observers.keys.give_delegate_model.rawValue] as? GiveDelegateModel else{
            return
        }
        if !model.isUsingModelForSearch{
            return
        }
        self.txtMainUser?.text = model.mainUser == nil ? nil :  "\(LocalizedStrings.delegate_search_main_name_placeholder.localizedString()): \(model.mainUser?.name ?? "") \(model.mainUser?.surname ?? "")"
        self.txtDelegate?.text = model.delegateUser == nil ? nil : "\(LocalizedStrings.delegate_search_delegate_name_placeholder.localizedString()): \(model.delegateUser?.name ?? "") \(model.delegateUser?.surname ?? "")"
        self.selectedMainUser = model.mainUser
        self.selectedDelegate = model.delegateUser
    }
    
    @IBAction func didTapSearch(){
        var dict = SessionManager.current.getBaseRequest().toDictionary()
        if let config = SessionManager.current.delegateConfig?.toDictionary(){
            for key in config.keys{
                dict[key] = config[key]
            }
        }
        
        var request = ListDelegateRequest(fromDictionary: dict)
        request.passiveUserId = self.selectedDelegate?.id
        request.activeUserId = self.selectedMainUser?.id
        request.getOnlyActives = self.sgmAktifPasif?.selectedSegmentIndex == 0 ? nil : self.sgmAktifPasif?.selectedSegmentIndex == 1 ? true : false
        request.getOnlyEffectives = self.sgmYururluk?.selectedSegmentIndex == 0
        if let date = self.selectedDate{
            request.selectedDelegationDate = self.dfRequest.string(from: date)
        }
        self.delegate?.didTapSearch(searchRequest: request)
    }
}

extension DelegateSearchHeaderView:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtMainUser || textField == self.txtDelegate{
            self.showSearchUserVC(sender: textField as! MDCTextField)
            return false
        }else{
            return true
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == self.txtMainUser{
            self.selectedMainUser = nil
        }
        if textField == self.txtDelegate{
            self.selectedDelegate = nil
        }
        return true
    }
}
