//
//  DepartmentGroupContentsTableViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 26.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit

protocol DepartmentGroupSetupDelegate {
    func didFinishSetup(group:DepartmentGroup)
    func didRemoveGroup(group:DepartmentGroup)
}

class DepartmentGroupContentsTableViewController: BaseViewController {

    @IBOutlet weak var tableView:UITableView?
    
    var response:DepartmentGroupItemsResponse?
    var departmentGroup:DepartmentGroup?
    var delegate:DepartmentGroupSetupDelegate?
    
    convenience init(departmentGroup:DepartmentGroup) {
        self.init(nibName: "DepartmentGroupContentsTableViewController", bundle: .main)
        self.departmentGroup = departmentGroup
        self.subViewLayoutBlock = {
            self.commonInit(trackingScrollView: self.tableView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(UINib(nibName: "DepartmentSetupTableViewCell", bundle: .main), forCellReuseIdentifier: "Cell")
        self.title = self.departmentGroup?.name
        self.fetchData()
        Observers.transfer_department_group_department_type_update.addObserver(observer: self, selector: #selector(didReceiveDistributionUpdateNotification(notification:)))
        
        let barBtnSelect:UIBarButtonItem = UIBarButtonItem(title: LocalizedStrings.select.localizedString(), style: .done, target: self, action: #selector(didTapSelectButton))
        self.navigationItem.rightBarButtonItem = barBtnSelect
    }
    
    @objc func didTapSelectButton(){
        
        var isValid = false
        for item in self.response?.departmentGroupItems ?? []{
            if item.documentDistributionTypeEnum != 3{
                isValid = true
            }
        }
        
        if !isValid{
            showBasicAlert(title: LocalizedStrings.target_department_group, message: LocalizedStrings.department_group_error_you_must_select_at_least_one, okTitle: .ok, actionHandler: nil)
            return
        }
        
        guard var group = self.departmentGroup, let items = self.response?.departmentGroupItems else{
            return
        }
        group.groupItems = items
        self.delegate?.didFinishSetup(group: group)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didReceiveDistributionUpdateNotification(notification:Notification){
        guard let department = notification.userInfo?[Observers.keys.selected_item.rawValue] as? DepartmentGroupItem else{
            return
        }
        
        if let index = self.response?.departmentGroupItems.lastIndex(where: {$0.departmentId == department.departmentId}){
            self.response?.departmentGroupItems[index].documentDistributionTypeEnum = department.documentDistributionTypeEnum
        }
    }

    func fetchData(){
        guard let group = self.departmentGroup else{
            return
        }
        if let items = group.groupItems {
            var response = DepartmentGroupItemsResponse(fromDictionary: [:])
            response.departmentGroupItems = items
            self.response = response
            self.tableView?.reloadData()
            
            let btnSelectItem =  UIBarButtonItem(title: LocalizedStrings.select.localizedString(), style: .done, target: self, action: #selector(didTapSelectButton))
            let btnUnselectItem = UIBarButtonItem(title: LocalizedStrings.unselect.localizedString(), style: .done, target: self, action: #selector(unSelectItem))
            self.navigationItem.rightBarButtonItems = [btnSelectItem, btnUnselectItem]
        }else{
            ApiClient.transfer_department_group_departments(departmentGroupId: group.id)
                .execute { (_ response:DepartmentGroupItemsResponse?, error, statusCode) in
                    self.response = response
                    self.tableView?.reloadData()
            }
        }
    }
    
    @objc func unSelectItem(){
        if let group = self.departmentGroup{
            self.delegate?.didRemoveGroup(group: group)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension DepartmentGroupContentsTableViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.response?.departmentGroupItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DepartmentSetupTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DepartmentSetupTableViewCell
        let department = self.response?.departmentGroupItems[indexPath.row]
        cell.load(department: department)
        return cell
    }
}
