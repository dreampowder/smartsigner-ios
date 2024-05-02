//
//  DistributionApprovalViewController.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 7.02.2020.
//  Copyright © 2020 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents

enum DAViewMode{
    case flow
    case actual_distribution
}



class DistributionApprovalViewController: BaseViewController {

    
    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var viewButtonContainer:UIStackView?
    let sgmSelector:UISegmentedControl = UISegmentedControl(frame: CGRect.zero)
    
    var document:PoolItem! = nil
    
    var flows:[DistributionFlowDaFlow] = []
    
    var viewMode:DAViewMode = .flow
    
    var distributions:[DaDistribution] = []
    var distributionNote:String?
    var dialogTranstitionController = MDCDialogTransitionController()
    
    var menuState:[FlowSideMenuItemType:Bool] = [:]
    
    var myDepartmentIds:[Int] = []
    
    convenience init(document:PoolItem) {
        self.init(nibName: DistributionApprovalViewController.getNibName(), bundle: .main)
        self.document = document
    }
    
    deinit {
        Observers.transfer_department_select.removeObserver(observer: self)
        Observers.transfer_user_select.removeObserver(observer: self)
        Observers.distribution_flow_copy_action.removeObserver(observer: self)
    }
    
    override func viewDidLayoutSubviews() {
        if !didLayoutSubviews{
            didLayoutSubviews = true
            self.tableView?.backgroundColor = .tableviewBackground
            self.view.backgroundColor = .tableviewBackground
            self.tableView?.separatorStyle = .none
            commonInit(trackingScrollView: self.tableView)
            self.sgmSelector.sizeToFit()
            self.sgmSelector.tintColor = UIColor.primaryColor
            let contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.sgmSelector.bounds.height + 16))
            self.sgmSelector.frame = CGRect(x: 8, y: 8, width: contentView.bounds.width - 16, height: contentView.bounds.height - 16)
            contentView.addSubview(self.sgmSelector)
            self.tableView?.tableHeaderView = contentView
            self.sgmSelector.insertSegment(withTitle: LocalizedStrings.distribution_flow_segment_flow.localizedString(), at: 0, animated: false)
            self.sgmSelector.insertSegment(withTitle: LocalizedStrings.distribution_flow_segment_distribution.localizedString(), at: 1, animated: false)
            self.sgmSelector.selectedSegmentIndex = 0
            self.sgmSelector.addTarget(self, action: #selector(didChangeTabs), for: .valueChanged)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizedStrings.document_distribution_flow.localizedString()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.register(UINib(nibName: "DistributionFlowTableViewCell", bundle: .main), forCellReuseIdentifier: "FlowCell")
        self.tableView?.register(UINib(nibName: "DistributionFlowDetailTableViewCell", bundle: .main), forCellReuseIdentifier: "DistributionCell")
        Observers.transfer_department_select.addObserver(observer: self, selector: #selector(didReceiveDepartmentSelectNotification(notification:)))
        Observers.transfer_user_select.addObserver(observer: self, selector: #selector(didReceiveUserSelectNotification(notification:)))
        
        getFlowSettings()
        fetchDistributions()
        
        var approveEnabled = true
        var declineEnabled = true
        if "OutgoingForDistributionApproval" == document.poolTypeEnumNameAsString{
            approveEnabled = false
            declineEnabled = false
        }else if "IncomingDeclinedForDocumentDistribution" == document.poolTypeEnumNameAsString{
            declineEnabled = false
        }else if "OutgoingDeclinedForDocumentDistribution" == document.poolTypeEnumNameAsString{
            approveEnabled = false
            declineEnabled = false
        }
        
        if declineEnabled {
            let button = MDCButton(frame: CGRect.zero)
            button.setTitle(LocalizedStrings.da_flow_btn_decline_title.localizedString(), for: .normal)
            ThemeManager.applyButtonColorTheme(button: button)
            button.sizeToFit()
            button.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            button.addTarget(self, action: #selector(didTapDecline), for: .touchUpInside)
            self.viewButtonContainer?.addArrangedSubview(button)
        }
        
        if approveEnabled {
            let button = MDCButton(frame: CGRect.zero)
            button.setTitle(LocalizedStrings.da_flow_btn_approve_title.localizedString(), for: .normal)
            ThemeManager.applyButtonColorTheme(button: button)
            button.sizeToFit()
            button.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            button.addTarget(self, action: #selector(didTapApprove), for: .touchUpInside)
            self.viewButtonContainer?.addArrangedSubview(button)
            
        }
        
        let barBtnRightMenu = UIBarButtonItem(image: UIImage(awesomeType: .bars, size: 10, textColor: .white), style: .done, target: self, action: #selector(didTapShowSideMenu))
        self.navigationItem.rightBarButtonItem = barBtnRightMenu
        Observers.distribution_flow_copy_action.addObserver(observer: self, selector: #selector(didReceiveCopyNotification(notification:)))
    }
    
    @objc func didReceiveCopyNotification(notification:Notification){
        guard let distributions = notification.userInfo?[Observers.keys.distribution_items.rawValue] as? [DaDistribution] else{
            return
        }
        distributions.forEach { (dist) in
            if !self.distributions.contains(where: { (d) -> Bool in
                if dist.targetDepartmentId != nil{
                    return dist.targetDepartmentId == d.targetDepartmentId
                }else if dist.targetUserId != nil{
                    return dist.targetUserId == d.targetUserId
                }else if dist.targetDepartmentGroupId != nil{
                    return dist.targetDepartmentGroupId == d.targetDepartmentGroupId
                }
                else{
                    return false
                }
            }){
                self.distributions.append(dist)
                self.sgmSelector.selectedSegmentIndex = 1
                self.viewMode = .actual_distribution
                self.refreshTableview()
            }
        }
    }
    
    func refreshTableview(){
        self.sgmSelector.setTitle("\(LocalizedStrings.distribution_flow_segment_flow.localizedString()) (\(self.flows.count))", forSegmentAt: 0)
        self.sgmSelector.setTitle("\(LocalizedStrings.distribution_flow_segment_distribution.localizedString()) (\(self.distributions.count))", forSegmentAt: 1)
        self.tableView?.reloadData()
    }
    
    func getChildDepartments(dontShowDerpartmentsUnderMe:Bool){
        ApiClient.distribution_flow_get_user_child_departments(documentId: self.document.documentId, lastEditDate: self.document.poolLastEditDate, dontShowDepartmentsUnderMe: dontShowDerpartmentsUnderMe)
            .execute { (_ response:DistributionListResponse?, error, status) in
                if response?.errorContent() != nil{
                    self.showBasicAlert(title: LocalizedStrings.error.localizedString(), message: response?.errorContent() ?? LocalizedStrings.error_unexpected.localizedString(), okTitle: nil, actionHandler: nil)
                }else{
                    if let dists = response?.daDistributions {
                        self.distributions.removeAll(where: {$0.isAddedByUser == false})
                        self.distributions.insert(contentsOf: dists, at: 0)
                    }
                    self.refreshTableview()
                }
        }
    }
    
    func getFlowSettings(){
        if let setting = SessionManager.current.getUserSetting(settingType: .UseLastDistributionForDistributionApprovalControl_Nullable_Bool), let value = setting.value as? Bool{
            self.menuState[.use_last_distribution_automatically] = value
        }
        
        if let setting = SessionManager.current.getUserSetting(settingType: .DontShowMessageOnSuccessForDistributionApprovalControl_Nullable_Bool), let value = setting.value as? Bool{
            self.menuState[.dont_warn_on_success] = value
        }
        
        if let setting = SessionManager.current.getUserSetting(settingType: .AddAdministrativeDepartmentForDistributionApprovalControl_Nullable_Bool), let value = setting.value as? Bool{
            self.menuState[.automatically_add_added_department_to_flow] = value
        }
        
        if let setting = SessionManager.current.getUserSetting(settingType: .DontShowNoteForDistributionApprovalControl_Nullable_Bool), let value = setting.value as? Bool{
            self.menuState[.dont_show_distribution_note] = value
        }
        
        if let setting = SessionManager.current.getUserSetting(settingType: .MyDepartmentAndUserList_List_MyDepartmentAndUserList), let value = setting.value as? [[String:Any]]{
            myDepartmentIds = []
            value.forEach { (dict) in
                if let departmentId = dict["DepartmentId"] as? Int{
                    myDepartmentIds.append(departmentId)
                }
            }
        }
    }
    
    @objc func didTapDecline(){
        let dialog = AlertDialogFactory.showAlertWithTextInputFromViewController(vc: self, placeholder: LocalizedStrings.da_action_input_placeholder.localizedString(), title: LocalizedStrings.da_action_decline_title.localizedString(), positiveTitle: LocalizedStrings.da_flow_btn_decline_title.localizedString(), negativeTitle: LocalizedStrings.cancel.localizedString()) { (text) in
            if text.count == 0{
                self.showBasicAlert(title: LocalizedStrings.error, message: LocalizedStrings.da_action_decline_empty_error, okTitle: nil) { (_) in
                    self.didTapDecline()
                }
            }else{
                let progress = self.showProgressDialog(title: LocalizedStrings.da_action_decline_title, message: LocalizedStrings.empty_string)
                ApiClient.decline_distribution_flow(poolId: self.document.id, userResponse: text)
                    .execute { (_ response:FolderListResponse?, error, statusCode) in
                        progress?.dismiss(animated: true, completion: {
                            if response?.errorContent() != nil{
                                self.showBasicAlert(title: LocalizedStrings.error.localizedString(), message: response?.errorContent() ?? LocalizedStrings.error_unexpected.localizedString(), okTitle: nil, actionHandler: nil)
                            }else{
                                self.showBasicAlert(title: LocalizedStrings.success.localizedString(), message: response?.successMessage ?? LocalizedStrings.operation_successful.localizedString(), okTitle: nil) { (_) in
                                    Observers.reload_folder.post(userInfo: nil)
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                        })
                }
            }
        }
        dialog.modalPresentationStyle = .custom
        dialog.transitioningDelegate = self.dialogTranstitionController
        dialog.preferredContentSize = CGSize(width: self.view.bounds.width - 32, height: 200)
        present(dialog, animated: true, completion: nil)
    }
    
    @objc func didTapApprove(){
        
        guard distributions.count > 0 else{
            self.showBasicAlert(title: LocalizedStrings.document_distribution_flow.localizedString(), message: LocalizedStrings.da_flow_error_approve_empty_distribution.localizedString(), okTitle: nil, actionHandler: nil)
            return
        }
        if menuState[.dont_show_distribution_note] ?? false {
            performApproveAction(note: nil)
        }else{
            let dialog = AlertDialogFactory.showAlertWithTextInputFromViewController(vc: self, placeholder: LocalizedStrings.da_action_input_placeholder.localizedString(), title: LocalizedStrings.da_action_approve_title.localizedString(), positiveTitle: LocalizedStrings.da_flow_btn_approve_title.localizedString(), negativeTitle: LocalizedStrings.cancel.localizedString()) { (text) in
                    self.performApproveAction(note: text)
                }
            dialog.modalPresentationStyle = .custom
            dialog.transitioningDelegate = self.dialogTranstitionController
            dialog.preferredContentSize = CGSize(width: self.view.bounds.width - 32, height: 200)
            present(dialog, animated: true, completion: nil)
        }
        
    }
    
    func performApproveAction(note:String?){
        if let index = self.flows.firstIndex(where: { (flow) -> Bool in
            guard let status:DaFlowStateEnum = DaFlowStateEnum(rawValue: flow.daFlowStateEnum) else{
                return false
            }
            return status == .finished
        }){
            self.flows[index].daDistributions = self.distributions
        }
        var req = ApproveDistributionFlowRequest(fromDictionary: [:])
        req.daFlows = self.flows
        req.distributionNote = self.distributionNote
        req.flowNote = note
        req.lastEditDate = self.document.poolLastEditDate
        req.poolId = self.document.id
        
        req.chkDontShowNote = self.menuState[.dont_show_distribution_note] ?? false
        req.chkDontShowMessageOnSuccess = self.menuState[.dont_warn_on_success] ?? false
        let progress = self.showProgressDialog(title: LocalizedStrings.da_action_approve_title, message: LocalizedStrings.empty_string)
        ApiClient.approve_distribution_flow(request: req)
            .execute { (_ response:FolderListResponse?, error, statusCode) in
                progress?.dismiss(animated: true, completion: {
                    if response?.errorContent() != nil{
                        self.showBasicAlert(title: LocalizedStrings.error.localizedString(), message: response?.errorContent() ?? LocalizedStrings.error_unexpected.localizedString(), okTitle: nil, actionHandler: nil)
                    }else{
                        if self.menuState[.dont_warn_on_success] ?? false {
                            Observers.reload_folder.post(userInfo: nil)
                            self.navigationController?.popToRootViewController(animated: true)
                        }else{
                            self.showBasicAlert(title: LocalizedStrings.success.localizedString(), message: response?.successMessage ?? LocalizedStrings.operation_successful.localizedString(), okTitle: nil) { (_) in
                                Observers.reload_folder.post(userInfo: nil)
                                self.navigationController?.popToRootViewController(animated: true)
                                
                            }
                        }
                    }
                })
            }
    }
    
    @objc func didTapShowSideMenu(){
        let vc = DistributionFlowSideMenuViewController(menuState: self.menuState)
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
    }
    
    @objc func didReceiveUserSelectNotification(notification:Notification){
        guard let users = notification.userInfo?[Observers.keys.selected_departments.rawValue] as? [User] else{
            return
        }
        users.forEach { (user) in
            switch viewMode {
            case .actual_distribution:
                addUserToDistribution(user: user)
//                addUserToFlow(user: user)
            case .flow:
                addUserToFlow(user: user)
                
            }
        }
        self.refreshTableview()
    }
    
    @objc func didReceiveDepartmentSelectNotification(notification:Notification){
        guard let departments = notification.userInfo?[Observers.keys.selected_departments.rawValue] as? [Department] else{
            return
        }
        departments.forEach { (department) in
            switch viewMode {
            case .actual_distribution:
                addDepartmentToDistribution(department: department)
                if department.id == department.administrativeDepartmentId {
                    addDepartmentToFlow(department: department)
                }
            case .flow:
                addDepartmentToFlow(department: department)
            }
        }
        self.refreshTableview()
    }
    
    
    func addUserToDistribution(user:User){
        if self.distributions.contains(where: {user.id == $0.targetUserId}) {
            print("User already found distribution")
            return
        }
        var distribution = DaDistribution(fromDictionary: [:])
        distribution.targetUserId = user.id
        distribution.targetUserName = user.name
        distribution.targetUserSurname = user.surname
        distribution.documentId = document?.documentId ?? 0
        distribution.orderNumber = self.distributions.count
        distribution.documentDistributionTypeEnum = DocumentDistrubutionTypeEnum.distribution_type_geregi.rawValue
        distribution.isAddedByUser = true
        self.distributions.append(distribution)
    }
    
    
    func addUserToFlow(user:User){
        if self.flows.contains(where: {user.id == $0.userId}) {
            print("User already found in flow")
            return
        }
        var flow = DistributionFlowDaFlow(fromDictionary: [:])
        flow.userId = user.id
        flow.userName = user.name
        flow.userSurname = user.surname
        flow.documentId = document?.documentId ?? 0
        flow.operatorUserId = SessionManager.current.loginData?.loggedUserId
//        flow.operatorUserName = SessionManager.current.loginData?.loggedUserUserName
//        flow.operatorUserSurname = SessionManager.current.loginData?.loggedUserSurname
        flow.daFlowStateEnum = DaFlowStateEnum.normal.rawValue
        self.flows.append(flow)
    }
    
    func addDepartmentToDistribution(department:Department){
        if self.distributions.contains(where: {department.id == $0.targetDepartmentId}) {
            print("Department already found in distribution")
            return
        }
        var distribution = DaDistribution(fromDictionary: [:])
        distribution.targetDepartmentId = department.id
        distribution.targetDepartmentName = department.name
        distribution.documentId = document?.documentId ?? 0
        distribution.orderNumber = self.distributions.count
        distribution.documentDistributionTypeEnum = DocumentDistrubutionTypeEnum.distribution_type_geregi.rawValue
        distribution.isAddedByUser = true
        self.distributions.append(distribution)
    }
    
    func addDepartmentToFlow(department:Department){
        if self.flows.contains(where: {department.id == $0.departmentId}) {
            print("User already found in flow")
            return
        }
        var flow = DistributionFlowDaFlow(fromDictionary: [:])
        flow.departmentId = department.id
        flow.departmentName = department.name
        flow.documentId = document?.documentId ?? 0
        flow.operatorUserId = SessionManager.current.loginData?.loggedUserId
//        flow.operatorUserName = SessionManager.current.loginData?.loggedUserUserName
//        flow.operatorUserSurname = SessionManager.current.loginData?.loggedUserSurname
        flow.daFlowStateEnum = DaFlowStateEnum.normal.rawValue
        self.flows.append(flow)
    }
    
    @objc func didChangeTabs(){
        self.viewMode = self.sgmSelector.selectedSegmentIndex == 0 ? .flow : .actual_distribution
        self.refreshTableview()
    }
    
    func fetchDistributions(){
        ApiClient.get_distribution_flow(documentId: document.documentId ?? 0, lastEditDate: document?.lastEditDate ?? "")
            .execute { (_ response:DistributionFlowListResponse?, error, statusCode) in
                Utilities.processApiResponse(parentViewController: self, response: response) {
                    self.flows = response?.daFlows ?? []
                    if self.menuState[.use_last_distribution_automatically] ?? false{
                        if let flow = self.flows.first(where: { (flow) -> Bool in
                            guard let status:DaFlowStateEnum = DaFlowStateEnum(rawValue: flow.daFlowStateEnum) else{
                                return false
                            }
                            return status == .finished
                        }){
                            self.distributions = flow.daDistributions
                        }
                    }
                    self.refreshTableview()
                }
        }
    }
    
    func showAddNoteAlert(){
        let dialog = AlertDialogFactory.showAlertWithTextInputFromViewController(vc: self, placeholder: "", title: LocalizedStrings.add_note.localizedString(), positiveTitle: LocalizedStrings.save.localizedString(), negativeTitle: LocalizedStrings.cancel.localizedString(), delegate: self)
        dialog.initialValue = self.distributionNote ?? ""
        dialog.modalPresentationStyle = .custom
        dialog.transitioningDelegate = self.dialogTranstitionController
        dialog.preferredContentSize = CGSize(width: self.view.bounds.width - 32, height: 200)
        present(dialog, animated: true, completion: nil)
    }
    
    func showUpdateDistributionAlert(indexPath:IndexPath){
        let dist = self.distributions[indexPath.row]
        AlertDialogFactory.showAlertActionDialog(vc: self, title: dist.getActualTitle(), message: LocalizedStrings.da_flow_please_select_distribution.localizedString(), actions: [
            MDCAlertAction(title: LocalizedStrings.distribution_type_coordinated.localizedString(), handler: { (_) in
                self.distributions[indexPath.row].documentDistributionTypeEnum = DocumentDistrubutionTypeEnum.distribution_type_coordinated.rawValue
                self.tableView?.reloadRows(at: [indexPath], with: .automatic)
            }),
            MDCAlertAction(title: LocalizedStrings.distribution_type_information.localizedString(), handler: { (_) in
                self.distributions[indexPath.row].documentDistributionTypeEnum = DocumentDistrubutionTypeEnum.distribution_type_information.rawValue
                self.tableView?.reloadRows(at: [indexPath], with: .automatic)
            }),
            MDCAlertAction(title: LocalizedStrings.distribution_type_geregi.localizedString(), handler: { (_) in
                self.distributions[indexPath.row].documentDistributionTypeEnum = DocumentDistrubutionTypeEnum.distribution_type_geregi.rawValue
                self.tableView?.reloadRows(at: [indexPath], with: .automatic)
            }),
        ])
    }
    
    func showAddDistributionAlert(){
        let vc:TransferSourceActionViewController = TransferSourceActionViewController(nibName:"TransferSourceActionViewController", bundle:.main)
        let bottomSheet = MDCBottomSheetController(contentViewController: vc)
        vc.alertTitle = viewMode == .flow ? LocalizedStrings.da_flow_add_flow_title.localizedString() : LocalizedStrings.da_flow_tap_here_to_add_distribution.localizedString()
        vc.parentVC = self
        vc.isShowingForDistributionFlow = true
        bottomSheet.dismissOnBackgroundTap = true
        present(bottomSheet, animated: true, completion: nil)
    }
}

extension DistributionApprovalViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewMode {
        case .flow:
            return flows.count + 2
        case .actual_distribution:
            return distributions.count + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewMode {
        case .flow:
            if indexPath.row < flows.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FlowCell", for: indexPath) as! DistributionFlowTableViewCell
                cell.load(flow: self.flows[indexPath.row])
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "DistributionCell", for: indexPath) as! DistributionFlowDetailTableViewCell
                if indexPath.row == flows.count{
                    cell.lblTitle?.text =  LocalizedStrings.da_flow_tap_here_to_add_flow.localizedString()
                    cell.lblDistributionType?.attributedText = Utilities.getIconString(icon: .plusCircle, size: 28)
                }else{
                    cell.lblTitle?.text = distributionNote ?? LocalizedStrings.da_flow_tap_here_to_add_note.localizedString()
                    cell.lblDistributionType?.attributedText = Utilities.getIconString(icon: .stickyNote, size: 28)
                }
                
                return cell
            }
            
        case .actual_distribution:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistributionCell", for: indexPath) as! DistributionFlowDetailTableViewCell
            if indexPath.row < distributions.count {
                cell.load(distribution: self.distributions[indexPath.row])
            }else{
                cell.lblTitle?.text = LocalizedStrings.da_flow_tap_here_to_add_distribution.localizedString()
                cell.lblDistributionType?.attributedText = Utilities.getIconString(icon: .plusCircle, size: cell.lblDistributionType?.font.pointSize ?? 20)
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewMode {
        case .flow:
            if indexPath.row == flows.count {
                showAddDistributionAlert()
                return
            }else if indexPath.row == flows.count + 1{
                showAddNoteAlert()
                return
            }
            let flow = self.flows[indexPath.row]
            var willShowCopyButton = false
            if let status:DaFlowStateEnum = DaFlowStateEnum(rawValue: flow.daFlowStateEnum){
                willShowCopyButton = status == .finished
            }
            let vc = DistributionDetailViewController(distributions: flow.daDistributions ?? [],willShowCopyButton: willShowCopyButton)
            self.navigationController?.pushViewController(vc, animated: true)
        case .actual_distribution:            
            if indexPath.row == distributions.count {
                showAddDistributionAlert()
                return
            }
            showUpdateDistributionAlert(indexPath: indexPath)
        }
    }
}

extension DistributionApprovalViewController: InputDialogDelegate{
    func didTapPositive(dialog: DialogWithInputFieldViewController, text: String?) {
        dialog.dismiss(animated: true) {
            if text?.count == 0{
                self.distributionNote = nil
            }else{
                self.distributionNote = text
            }
            self.tableView?.reloadRows(at: [IndexPath(row: self.flows.count + 1, section: 0)], with: .automatic)
        }
        
    }
    
    func didTapNegative(dialog: DialogWithInputFieldViewController) {
        dialog.dismiss(animated: true) {

        }
    }
}

extension DistributionApprovalViewController:FlowSideMenuDelegate{
    func didTapApply(menuState: [FlowSideMenuItemType : Bool], willFetchDistributions: Bool) {
        self.menuState = menuState
        if willFetchDistributions {
            getChildDepartments(dontShowDerpartmentsUnderMe: (menuState[.show_connected_departments] ?? false))
        }
    }
    
    func didTapcancel() {
        print("Cancel")
    }
}
