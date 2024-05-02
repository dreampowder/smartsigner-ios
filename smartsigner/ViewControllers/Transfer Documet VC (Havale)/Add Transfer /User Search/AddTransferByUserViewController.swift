//
//  AddTransferByUserViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 26.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class AddTransferByUserViewController: BaseViewController {

    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var btnAddItems:MDCButton?
    
    var selectedUsers:[User] = []
    
    var searchResponse:SearchUserResponse?
    var favResponse:SearchUserResponse?
    
    let searchHeader:TransferSearchHeader? = Bundle.main.loadNibNamed("TransferSearchHeader", owner: self)?.first as? TransferSearchHeader
    
    convenience init() {
        self.init(nibName: "AddTransferByUserViewController", bundle: .main)
        self.subViewLayoutBlock = {
            self.view.backgroundColor = .tableviewBackground
            self.tableView?.backgroundColor = .tableviewBackground
            self.commonInit(trackingScrollView: self.tableView)
            self.searchHeader?.frame = CGRect(x: 0, y: 0, width: self.tableView?.bounds.width ?? 200, height: 72)
            self.searchHeader?.searchDelegate = self
            self.searchHeader?.txtSearchQuery?.delegate = self
            self.tableView?.tableHeaderView = self.searchHeader
            self.navigationItem.hidesBackButton = false
            if let btn = self.btnAddItems{
                ThemeManager.applyButtonColorTheme(button: btn)
            }
            self.btnAddItems?.setElevation(ShadowElevation.cardResting, for: .normal)
            self.updateAddButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSearch(isFavorite: true)
        self.tableView?.register((UINib(nibName: "TransferSelectionTableViewCell", bundle: .main)), forCellReuseIdentifier: "Cell")
        self.btnAddItems?.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        let barBtnClose = UIBarButtonItem(title: LocalizedStrings.cancel.localizedString(), style: .done, target: self, action: #selector(closeView))
        self.navigationItem.leftBarButtonItem = barBtnClose
        self.title = LocalizedStrings.target_user.localizedString()
    }
    
    @objc func closeView(){
        self.dismiss(animated: true, completion: nil)
    }

    func updateAddButton(){
        let isEmpty = (self.selectedUsers.count == 0)
        self.btnAddItems?.setTitle(isEmpty ? LocalizedStrings.user_select_button_title_empty.localizedString() : LocalizedStrings.user_select_button_title.localizedString(params: ["\(self.selectedUsers.count)"]), for: .normal)
    }
    
    @objc func didTapAddButton(){
        if self.selectedUsers.count == 0 {
            return
        }
        self.dismiss(animated: true) {
            Observers.transfer_user_select.post(userInfo: [Observers.keys.selected_departments : self.selectedUsers])
        }
    }
    
    func searchAction(){
        if let query = self.searchHeader?.txtSearchQuery?.text{
            self.performSearch(isFavorite: false)
        }else{
            showBasicAlert(title: LocalizedStrings.transfer_source_user, message: LocalizedStrings.transfer_search_error_query_empty, okTitle: .ok, actionHandler: nil)
        }
    }
    
    func performSearch(isFavorite:Bool) {
        let apiAction:ApiClient = isFavorite ? ApiClient.transfer_get_recent_users : ApiClient.delegate_search_user(searchQuery: self.searchHeader?.txtSearchQuery?.text)
        apiAction.execute { (_ response:SearchUserResponse?, error, statusCode) in
            if isFavorite{
                self.favResponse = response
            }else{
                self.searchResponse = response
            }
            self.view.endEditing(true)
            self.tableView?.reloadData()
        }
    }
}

extension AddTransferByUserViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? self.favResponse?.users.count ?? 0 : self.searchResponse?.users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TransferSelectionTableViewCell
        let user = indexPath.section == 0 ? self.favResponse?.users[indexPath.row] : self.searchResponse?.users[indexPath.row]
        cell.load(title: "\(user?.name ?? "") \(user?.surname ?? "")", subTitle: user?.departmentName ?? "", isSelected: self.selectedUsers.contains(where: {$0.id == user?.id}))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = indexPath.section == 0 ? self.favResponse?.users[indexPath.row] : self.searchResponse?.users[indexPath.row]{
            if  self.selectedUsers.contains(where: {$0.id == user.id}){
                self.selectedUsers.removeAll(where: {$0.id == user.id})
            }else{
                self.selectedUsers.append(user)
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
            self.updateAddButton()
        }
    }
}

extension AddTransferByUserViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.count ?? 0 > 0){
            performSearch(isFavorite: false)
            return true
        }else{
            return false
        }
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let textFieldText: NSString = (textField.text ?? "") as NSString
//        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
//        if txtAfterUpdate.count > 2{
//            performSearch(isFavorite: false)
//        }
//        return true
//    }
}

extension AddTransferByUserViewController:TransferSearchHeaderProtocol{
    func didTapSearchButton() {
        self.performSearch(isFavorite: false)
    }
}
