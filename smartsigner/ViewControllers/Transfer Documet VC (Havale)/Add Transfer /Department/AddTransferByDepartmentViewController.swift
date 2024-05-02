//
//  AddTransferByDepartmentViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 23.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents

protocol TransferSearchHeaderProtocol {
    func didTapSearchButton()
}

class AddTransferByDepartmentViewController: BaseViewController {

    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var btnAddItems:MDCButton?
    
    var favResponse:DepartmentListResponse?
    var searchResponse:DepartmentListResponse?
    var searchHeader:DepartmentSearchHeader? = Bundle.main.loadNibNamed("DepartmentSearchHeader", owner: self)?.first as? DepartmentSearchHeader
    
    var selectedDepartments:[Department] = []
    
    
    convenience init() {
        self.init(nibName: "AddTransferByDepartmentViewController", bundle: .main)
        self.subViewLayoutBlock = {
            self.commonInit(trackingScrollView: self.tableView)
            self.searchHeader?.frame = CGRect(x: 0, y: 0, width: self.tableView?.bounds.width ?? 200, height: 72)
            self.searchHeader?.searchDelegate = self
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
        self.fetchDepartments(isFavorite: true)
        let barBtnClose = UIBarButtonItem(title: LocalizedStrings.cancel.localizedString(), style: .done, target: self, action: #selector(closeView))
        self.navigationItem.leftBarButtonItem = barBtnClose
        self.title = LocalizedStrings.target_department.localizedString()
        self.searchHeader?.txtSearchQuery?.delegate = self
        self.tableView?.register((UINib(nibName: "TransferSelectionTableViewCell", bundle: .main)), forCellReuseIdentifier: "Cell")
        self.btnAddItems?.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
    
    @objc func closeView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapAddButton(){
        if self.selectedDepartments.count == 0 {
            return
        }
        self.dismiss(animated: true) {
            Observers.transfer_department_select.post(userInfo: [Observers.keys.selected_departments : self.selectedDepartments])
        }
    }
    
    func updateAddButton(){
        let isEmpty = (self.selectedDepartments.count == 0)
//        self.btnAddItems?.setEnabled(!isEmpty, animated: true)
        self.btnAddItems?.setTitle(isEmpty ? LocalizedStrings.department_select_button_title_empty.localizedString() : LocalizedStrings.department_select_button_title.localizedString(params: ["\(self.selectedDepartments.count)"]), for: .normal)
    }
    
    func fetchDepartments(isFavorite:Bool){
        ApiClient.transfer_get_depoartments(isFavorites: isFavorite, searchQuery: self.searchHeader?.txtSearchQuery?.text ?? "", departmentType: self.searchHeader?.selectedDepartment ?? DepoartmentTypeEnum.depoartment_type_empty)
            .execute { (_ response:DepartmentListResponse?, error, statusCode) in
                if isFavorite{
                    self.favResponse = response
                }else{
                    self.searchResponse = response
                    self.view.endEditing(true)
                }
                self.tableView?.reloadData()
        }
    }
    
    func performSearch(){
        if let departmentType = self.searchHeader?.selectedDepartment{
            if departmentType == .depoartment_type_empty{
                showBasicAlert(title: LocalizedStrings.target_department, message: .department_search_error_department_empty, okTitle: .ok, actionHandler: nil)
            }else{
                self.fetchDepartments(isFavorite: false)
            }
        }else {
            showBasicAlert(title: LocalizedStrings.target_department, message: .department_search_error_department_empty, okTitle: .ok, actionHandler: nil)
        }
    }
}

extension AddTransferByDepartmentViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.favResponse?.departments.count ?? 0
        }else{
            return self.searchResponse?.departments.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return (self.favResponse?.departments.count ?? 0 > 0) ? LocalizedStrings.recently_used.localizedString() : nil
        }else{
            return (self.searchResponse?.departments.count ?? 0 > 0) ? LocalizedStrings.search_result.localizedString() : nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TransferSelectionTableViewCell
        let department = indexPath.section == 0 ? self.favResponse?.departments[indexPath.row] : self.searchResponse?.departments[indexPath.row]
        cell.load(title: department?.name, subTitle: department?.titleOne, isSelected: self.selectedDepartments.contains(where: {$0.id == department?.id}))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let department = indexPath.section == 0 ? self.favResponse?.departments[indexPath.row] : self.searchResponse?.departments[indexPath.row]
        if self.selectedDepartments.contains(where: {$0.id == department?.id}){
            self.selectedDepartments.removeAll(where: {$0.id == department?.id})
        }else{
            self.selectedDepartments.append(department!)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        self.updateAddButton()
    }
    
    
}

extension AddTransferByDepartmentViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.count ?? 0 > 0){
            performSearch()
            return true
        }else{
            return false
        }
        
    }
}

extension AddTransferByDepartmentViewController:TransferSearchHeaderProtocol{
    func didTapSearchButton() {
        self.view.endEditing(true)
        performSearch()
    }
}
