//
//  AddTransfersByDistributionViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 26.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class AddTransfersByDistributionViewController: BaseViewController {

    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var btnAddItems:MDCButton?
    
    var selectedGroups:[DepartmentGroup] = []
    
    var searchResponse:DepartmentGroupListResponse?

    
    let searchHeader:TransferSearchHeader? = Bundle.main.loadNibNamed("TransferSearchHeader", owner: self)?.first as? TransferSearchHeader
    
    convenience init() {
        self.init(nibName: "AddTransfersByDistributionViewController", bundle: .main)
        self.subViewLayoutBlock = {
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
        self.tableView?.register((UINib(nibName: "TransferSelectionTableViewCell", bundle: .main)), forCellReuseIdentifier: "Cell")
        self.btnAddItems?.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        let barBtnClose = UIBarButtonItem(title: LocalizedStrings.cancel.localizedString(), style: .done, target: self, action: #selector(closeView))
        self.navigationItem.leftBarButtonItem = barBtnClose
        self.title = LocalizedStrings.target_department_group.localizedString()
    }
    
    @objc func didTapAddButton(){
        if self.selectedGroups.count == 0 {
            return
        }
        self.dismiss(animated: true) {
            Observers.transfer_department_group_select.post(userInfo: [Observers.keys.selected_departments : self.selectedGroups])
        }
    }
    
    @objc func closeView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateAddButton(){
        let isEmpty = (self.selectedGroups.count == 0)
        self.btnAddItems?.setTitle(isEmpty ? LocalizedStrings.department_group_select_button_title_empty.localizedString() : LocalizedStrings.department_group_select_button_title.localizedString(params: ["\(self.selectedGroups.count)"]), for: .normal)
    }
    
    func searchAction(){
            self.performSearch()
    }
    
    func performSearch() {
        ApiClient.transfer_get_department_groups(searchQuery: self.searchHeader?.txtSearchQuery?.text).execute { (_ response:DepartmentGroupListResponse?, error, statusCode) in
            self.searchResponse = response
            self.view.endEditing(true)
            self.tableView?.reloadData()
        }
    }
}

extension AddTransfersByDistributionViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.count ?? 0 > 0){
            performSearch()
            return true
        }else{
            return false
        }
        
    }
}

extension AddTransfersByDistributionViewController:TransferSearchHeaderProtocol{
    func didTapSearchButton() {
        self.performSearch()
    }
}

extension AddTransfersByDistributionViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResponse?.departmentGroups.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TransferSelectionTableViewCell
        let group =  self.searchResponse?.departmentGroups[indexPath.row]
        cell.load(title: group?.name, subTitle: "", isSelected: self.selectedGroups.contains(where: {$0.id == group?.id}))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if var group = self.searchResponse?.departmentGroups[indexPath.row]{
            
            
            if let selected = self.selectedGroups.first(where: {$0.id == group.id}){
                group = selected
            }
            
            let vc = DepartmentGroupContentsTableViewController(departmentGroup: group)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension AddTransfersByDistributionViewController:DepartmentGroupSetupDelegate{
    
    func didFinishSetup(group: DepartmentGroup) {
        if let group = self.selectedGroups.first(where: {$0.id == group.id}){
            if let index = self.selectedGroups.firstIndex(where: {$0.id == group.id}){
                self.selectedGroups[index] = group
            }
        }else{
            self.selectedGroups.append(group)
        }
        self.updateAddButton()
        self.tableView?.reloadData()
    }
    
    func didRemoveGroup(group: DepartmentGroup) {
        if let group = self.selectedGroups.first(where: {$0.id == group.id}){
            if let index = self.selectedGroups.firstIndex(where: {$0.id == group.id}){
                self.selectedGroups.remove(at: index)
            }
        }
        self.updateAddButton()
        self.tableView?.reloadData()
    }
}
