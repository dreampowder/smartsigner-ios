//
//  TransferDocumentViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 21.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents

struct TransferDocumentModel:Hashable {
    
    static func == (lhs: TransferDocumentModel, rhs: TransferDocumentModel) -> Bool {
        return lhs.id == rhs.id && lhs.transferSource == rhs.transferSource
    }
    
    var urgency:DocumentUrgencyEnum?
    var type:DocumentDistrubutionTypeEnum?
    var transferSource:DocumentTransferSource?
    var notes:String?
    var id:Int?
    var title:String
    var departments:[DepartmentGroupItem] = []
    
    
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title.hashValue)
        hasher.combine(id)
        hasher.combine(transferSource)
    }
    
    func getRequestDictionary(order:Int)->[String:Any]{
        var dictValue:[String:Any] = [:]
        dictValue["DocumentDistributionTypeEnum"] = self.type?.rawValue ?? 0
        dictValue["DocumentDistributionUrgencyTypeEnum"] = self.urgency?.rawValue ?? 0
        dictValue["OrderNumber"] = order
        dictValue["NoteText"] = self.notes ?? ""
        if let source = self.transferSource{
            switch source {
            case .transfer_source_depoartment:
                dictValue["TargetDepartmentId"] = id
            case .transfer_source_user:
                dictValue["TargetUserId"] = id
            case .transfer_source_distribution:
                var listString = ""
                for index in 0..<self.departments.count {
                    let item = self.departments[index]
                    if item.documentDistributionTypeEnum != 3{
                        let string = "\(item.departmentId ?? 0):\(item.documentDistributionTypeEnum ?? 0),"
                        listString.append(string)
                    }
                }
                dictValue["DepartmentGroupDepartmentList"] = String(listString.dropLast())
                dictValue["TargetDepartmentGroupId"] = id
            }
        }
        return dictValue
    }
}

class TransferDocumentViewController: BaseViewController {

    var transfers:[TransferDocumentModel] = []
    var documents:[PoolItem]?
    
    var txtTypePicker:UITextField = UITextField()
    var pickerType = UIPickerView()
    var typeNameArray = [LocalizedStrings]()
    
    var typeArray = [DocumentDistrubutionTypeEnum]()
    
    var txtUrgencyPicker:UITextField = UITextField()
    var pickerUrgency = UIPickerView()
    var urgencyNameArray = [LocalizedStrings.empty_string,LocalizedStrings.document_urgency_normal,LocalizedStrings.document_urgency_ivedi,LocalizedStrings.document_urgency_cok_ivedi,LocalizedStrings.document_urgency_gunlu]
    var urgencyTypeArray = [DocumentUrgencyEnum.document_urgency_normal,DocumentUrgencyEnum.document_urgency_ivedi,DocumentUrgencyEnum.document_urgency_cok_ivedi,DocumentUrgencyEnum.document_urgency_gunlu]
    var dialogTranstitionController = MDCDialogTransitionController()
    
    var heightDict:[TransferDocumentModel:CGFloat] = [:]
    var selectedDate:Date?
    var dateFormatter:DateFormatter = DateFormatter()
    
    var forwardNote:String?
    
    @IBOutlet weak var tableView:UITableView?
    
    var pickerSchemeSelector:UIPickerView = UIPickerView()
    var txtPicker:UITextField = UITextField(frame: CGRect(x: -10, y: -10, width: 1, height: 1))
    var schemes:[String] = []
    var selectedSchemeName:String?
    
    var documentForwardingMode:Int = 0
    var onlyForServiceMode:Int = 0
    var promptResult:Int = 0
    
    convenience init(document:PoolItem) {
        self.init(nibName: TransferDocumentViewController.getNibName(), bundle: .main)
        self.documents = [document]
    }
    
    convenience init(documents:[PoolItem]) {
        self.init(nibName: TransferDocumentViewController.getNibName(), bundle: .main)
        self.documents = documents
    }
    
    override func viewDidLayoutSubviews() {
        if !didLayoutSubviews{
            didLayoutSubviews = true
            self.tableView?.backgroundColor = .tableviewBackground
            commonInit(trackingScrollView: self.tableView)
        }
    }
    
    deinit {
        Observers.transfer_department_select.removeObserver(observer: self)
        Observers.transfer_user_select.removeObserver(observer: self)
        Observers.transfer_remove_item.removeObserver(observer: self)
        Observers.transfer_change_type_and_urgency.removeObserver(observer: self)
        Observers.transfer_change_note.removeObserver(observer: self)
        Observers.transfer_department_group_select.removeObserver(observer: self)
        Observers.did_select_date.removeObserver(observer: self)
        SessionManager.current.refreshFolders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let setting = SessionManager.current.transferDepartmentSettings.first(where: {$0.departmentSettingNameEnum == 115}){
            typeArray  = DocumentDistrubutionTypeEnum.getDepartmentsFromBitFlag(value:setting.value as! Int)
        }else{
            typeArray  = DocumentDistrubutionTypeEnum.getDepartmentsFromBitFlag(value:0)
        }
        
        for i in 0..<typeArray.count{
            typeNameArray.append(typeArray[i].stringValue())
        }
        
        if let setting = SessionManager.current.transferDepartmentSettings.first(where: {$0.departmentSettingNameEnum == DepartmentSettingTypeEnum.OnlyForServiceDocumentMode_Nullable_Int.rawValue}){
            onlyForServiceMode = setting.value as! Int
        }
        
        if let setting = SessionManager.current.transferDepartmentSettings.first(where: {$0.departmentSettingNameEnum == DepartmentSettingTypeEnum.DocumentRightModeWhileForwarding_Nullable_Int.rawValue}){
            documentForwardingMode = setting.value as! Int
        }
        
        
        self.dateFormatter.dateFormat = "dd.MM.yyyy"
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell-Empty")
        tableView?.register(UINib(nibName: "TransferCellTableViewCell", bundle: .main), forCellReuseIdentifier: "Cell")
        self.title = LocalizedStrings.transfer.localizedString()
        
        self.txtTypePicker.inputView = self.pickerType
        self.txtUrgencyPicker.inputView = self.pickerUrgency
        self.view.addSubview(txtTypePicker)
        self.view.addSubview(txtUrgencyPicker)
        self.pickerType.delegate = self
        self.pickerUrgency.delegate = self
        
        Observers.transfer_department_select.addObserver(observer: self, selector: #selector(didReceiveAddDepartmentNotification(notification:)))
        Observers.transfer_remove_item.addObserver(observer: self, selector: #selector(didReceiveRemoveItemNotification(notification:)))
        Observers.transfer_change_type_and_urgency.addObserver(observer: self, selector: #selector(didReceiveChangeTypeOrUrgencyNotification(notification:)))
        Observers.transfer_user_select.addObserver(observer: self, selector: #selector(didReceiveAddUserNotification(notification:)))
        Observers.transfer_change_note.addObserver(observer: self, selector: #selector(didReceiveChangeNoteNotification(notification:)))
        
        Observers.transfer_department_group_select.addObserver(observer: self, selector: #selector(didReceiveAddDistributionGroupNotification(notification:)))
        
        Observers.did_select_date.addObserver(observer: self, selector: #selector(didReceiveDateSelectNotification(notification:)))
        
        let barBrnSubmit = UIBarButtonItem(title: LocalizedStrings.submit.localizedString(), style: .done, target: self, action: #selector(didTapSubmitButton))
//        self.navigationItem.rightBarButtonItem = barBrnSubmit
        var actionArray = [barBrnSubmit]
        if let array = SessionManager.current.getUserSetting(settingType: .TransferDepartmentSchemes_String_Array)?.value as? [String]{
            self.schemes = array
            self.schemes.insert("", at: 0)
        }
        if self.schemes.count > 0{
            
            let barBtnScheme = UIBarButtonItem(image: UIImage(named: "menu_fav"), style: .done, target: self, action: #selector(didTapSchemeSelector(sender:)))
            
            actionArray.append(barBtnScheme)
            txtPicker.inputView = pickerSchemeSelector
            txtPicker.delegate = self
            self.view.addSubview(txtPicker)
            
            pickerSchemeSelector.delegate = self
            pickerSchemeSelector.dataSource = self
        }
        self.navigationItem.rightBarButtonItems = actionArray
    }
    
    @objc func didTapSchemeSelector(sender:Any){
        self.txtPicker.becomeFirstResponder()
    }
    
    @objc func didReceiveDateSelectNotification(notification:Notification){
        guard let selectedDate = notification.userInfo?[Observers.keys.selected_date.rawValue] as? Date else{
            return
        }
        self.selectedDate = selectedDate
        self.tableView?.reloadData()
    }
    
    @objc func didTapSubmitButton(){
        if self.transfers.count == 0{
            showAlert(title: LocalizedStrings.transfer, message: LocalizedStrings.transfer_source_error_no_targets_set, actions: [(title: LocalizedStrings.ok, handler: nil)])
        }else{
            let dialog = AlertDialogFactory.showAlertWithTextInputFromViewController(vc: self, placeholder: LocalizedStrings.transfer_alert_submit_message_enter_note.localizedString(), title: LocalizedStrings.transfer.localizedString(), positiveTitle: LocalizedStrings.submit.localizedString(), negativeTitle: LocalizedStrings.cancel.localizedString(), delegate: self)
            dialog.customObject = self.transfers
            dialog.modalPresentationStyle = .custom
            dialog.transitioningDelegate = self.dialogTranstitionController
            dialog.preferredContentSize = CGSize(width: self.view.bounds.width - 32, height: 200)
            self.present(dialog, animated: true, completion: nil)
        }
        
    }
    
    func showTransferSourceSelector(){
        let vc:TransferSourceActionViewController = TransferSourceActionViewController(nibName:"TransferSourceActionViewController", bundle:.main)
        let bottomSheet = MDCBottomSheetController(contentViewController: vc)
        vc.parentVC = self
        bottomSheet.dismissOnBackgroundTap = true
        present(bottomSheet, animated: true, completion: nil)
    }
    
    @objc func didReceiveChangeNoteNotification(notification:Notification){
        guard
            let item = notification.userInfo?[Observers.keys.selected_item.rawValue] as? TransferDocumentModel
            else{
                return
        }
        
        if let index = self.transfers.lastIndex(where: {$0.id == item.id && $0.transferSource == item.transferSource}){
            let dialog =  AlertDialogFactory.showAlertWithTextInputFromViewController(vc: self, placeholder: "Not girin", title: self.transfers[index].title, positiveTitle: LocalizedStrings.ok.localizedString(), negativeTitle: LocalizedStrings.cancel.localizedString(), delegate: self)
            let transfer = self.transfers[index]
            dialog.initialValue = transfer.notes ?? ""
            dialog.view.tag = index
            dialog.modalPresentationStyle = .custom
            dialog.transitioningDelegate = self.dialogTranstitionController
            dialog.preferredContentSize = CGSize(width: self.view.bounds.width - 32, height: 200)

            self.present(dialog, animated: true, completion: nil)
        }
    }
    
    @objc func didReceiveChangeTypeOrUrgencyNotification(notification:Notification){
        guard
            let item = notification.userInfo?[Observers.keys.selected_item.rawValue] as? TransferDocumentModel,
            let isTypeAction = notification.userInfo?[Observers.keys.transfer_change_type_and_urgency_type.rawValue] as? Bool
        else{
            return
        }
        
        if let index = self.transfers.lastIndex(where: {$0.id == item.id && $0.transferSource == item.transferSource}){
            self.pickerUrgency.tag = index
            self.pickerType.tag = index
            if isTypeAction{
                self.txtTypePicker.becomeFirstResponder()
            }else{
                self.txtUrgencyPicker.becomeFirstResponder()
            }
        }
    }
    
    @objc func didReceiveRemoveItemNotification(notification:Notification){
        guard let item = notification.userInfo?[Observers.keys.selected_item.rawValue] as? TransferDocumentModel else{
            return
        }
        showAlert(title: LocalizedStrings.transfer.localizedString(), message: LocalizedStrings.remove_transfer_message.localizedString(params: [item.title]), actions: [(title: LocalizedStrings.yes, handler: {action in
            
            if let index = self.transfers.lastIndex(where: {$0.id == item.id && $0.transferSource == item.transferSource}){
                self.transfers.remove(at: index)
                self.tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                self.tableView?.reloadSections(IndexSet(integer: 1), with: .automatic)
            }
            
        }),(title:LocalizedStrings.cancel, handler: nil)]);
    }
    
    @objc func didReceiveAddUserNotification(notification:Notification){
        guard let users = notification.userInfo?[Observers.keys.selected_departments.rawValue] as? [User] else{
            return
        }
        for user in users {
            if !self.transfers.contains(where: {$0.id == user.id && $0.transferSource == DocumentTransferSource.transfer_source_user}){
                let source = TransferDocumentModel(urgency: DocumentUrgencyEnum.document_urgency_normal, type: DocumentDistrubutionTypeEnum.distribution_type_geregi, transferSource: DocumentTransferSource.transfer_source_user, notes: "", id: user.id, title: "\(user.name ?? "") \(user.surname ?? "")", departments: [])
                self.transfers.append(source)
            }
        }
        self.tableView?.reloadData()
        self.tableView?.scrollToRow(at: IndexPath(row: 0, section: 1), at: UITableView.ScrollPosition.bottom, animated: true)
    }
    
    @objc func didReceiveAddDepartmentNotification(notification:Notification){
        guard let departments = notification.userInfo?[Observers.keys.selected_departments.rawValue] as? [Department] else{
            return
        }
        for department in departments{
            if !self.transfers.contains(where: {$0.id == department.id && $0.transferSource == DocumentTransferSource.transfer_source_depoartment}){
                let source = TransferDocumentModel(urgency: DocumentUrgencyEnum.document_urgency_normal, type: DocumentDistrubutionTypeEnum.distribution_type_geregi, transferSource: DocumentTransferSource.transfer_source_depoartment, notes: "", id: department.id, title: department.name, departments: [])
                self.transfers.append(source)
            }
        }
        self.tableView?.reloadData()
        self.tableView?.scrollToRow(at: IndexPath(row: 0, section: 1), at: UITableView.ScrollPosition.bottom, animated: true)
    }
    
    @objc func didReceiveAddDistributionGroupNotification(notification:Notification){
        guard let groups = notification.userInfo?[Observers.keys.selected_departments.rawValue] as? [DepartmentGroup] else{
            return
        }
        for group in groups{
            if !self.transfers.contains(where: {$0.id == group.id && $0.transferSource == DocumentTransferSource.transfer_source_distribution}){
                let source = TransferDocumentModel(urgency: DocumentUrgencyEnum.document_urgency_normal, type: DocumentDistrubutionTypeEnum.distribution_type_geregi, transferSource: DocumentTransferSource.transfer_source_distribution, notes: "", id: group.id, title: group.name, departments: group.groupItems ?? [])
                self.transfers.append(source)
            }
        }
        self.tableView?.reloadData()
        self.tableView?.scrollToRow(at: IndexPath(row: 0, section: 1), at: UITableView.ScrollPosition.bottom, animated: true)
    }
    
    func postTransfers(note:String?){
        self.forwardNote = note
        if self.transfers.count == 0{
        }else{
            ApiClient.prepare_for_forward(poolIds: self.documents?.map({$0.id}) ?? [], transfers: self.transfers ?? [])
                .execute { (_ response:PrepareForForwardResponse?, error, statusCode) in
                    Utilities.processApiResponse(parentViewController: self, response: response) {
                        if response?.giveRightAutomatically ?? false{
                            self.proceedToTransferWithPropmptResult(promptResult: 1, note: note)
                        }
                        else if response?.showPrompt ?? false {
                            self.showAlert(title: LocalizedStrings.transfer.localizedString(),
                                           message: response?.promptMessage ?? "",
                                      actions: [
                                        (title:.cancel, handler:{action in print("Did Tap CANCEL")} ),
                                        (title:.no, handler:{action in self.proceedToTransferWithPropmptResult(promptResult: 2, note: note)} ),
                                        (title:.yes, handler:{action in self.proceedToTransferWithPropmptResult(promptResult: 1, note: note)} )
                                ]
                            )
                        }else{
                            self.proceedToTransferWithPropmptResult(promptResult: 2, note: note)
                        }
                    }
            }
        }
    }
    
    func proceedToTransferWithPropmptResult(promptResult:Int, note:String?){
        if documents?.count == 1{
            let document = self.documents?.first
            let progress = showProgressDialog(title: LocalizedStrings.transfer.localizedString(), message: "", isIndeterminate: true)
            ApiClient.transfer_post(poolId: document?.id ?? 0, forwardNote: note, dueDate: self.selectedDate, transfers: self.transfers, promptResult: promptResult)
                .execute { (_ response:FolderListResponse?, error, statusCode) in
                    progress?.dismiss(animated: true, completion: {
                        Utilities.processApiResponse(parentViewController: self, response: response) {
                            if let folders =  response?.folders{
                                SessionManager.current.setFolders(folders: folders)
                            }
                            self.showBasicAlert(title: LocalizedStrings.transfer, message: LocalizedStrings.transfer_alert_submit_success, okTitle: .ok, actionHandler: { (action) in
                                self.navigationController?.popToRootViewController(animated: true)
                                Observers.reload_folder.post(userInfo: nil)
                            })
                        }
                    })
            }
        }else if documents?.count ?? 0 > 1{
            self.promptResult = promptResult
            let _ = BatchOperationViewController.presentFromBotomSheet(parent: self, documents: self.documents ?? [], operationType: .transfer)
            for document in documents ?? []{
                self.postDocumentForBatchTransfer(document: document,promptResult: promptResult)
            }
        }
    }
    
    func postDocumentForBatchTransfer(document:PoolItem,promptResult:Int){
        ApiClient.transfer_post(poolId: document.id ?? 0, forwardNote: self.forwardNote ?? "", dueDate: self.selectedDate, transfers: self.transfers,promptResult:promptResult)
            .execute { (_ response:FolderListResponse?, error, statusCode) in
                Utilities.processApiResponse(parentViewController: self, response: response) {
                        Observers.batch_operation_progress.post(userInfo: [Observers.keys.operation_id : document.id ?? 0, Observers.keys.operation_success : response?.errorContent() == nil])
                }
                
        }
    }
    
    @objc func didTapHeaderView(){
        print("header tap!")
        if self.selectedDate != nil{
            showAlert(title: LocalizedStrings.transfer_date_action_title, message:LocalizedStrings.fast_login_select_action , actions: [(title: LocalizedStrings.transfer_date_action_remove_date, handler:
                {_ in
                    self.selectedDate = nil
                    self.tableView?.reloadData()
            }),(title:LocalizedStrings.transfer_date_action_pick_new_date, handler: { _ in
                self.showDatePicker(sourceView: TransferDocumentViewController.getNibName(), selectedDate: self.selectedDate)
                
            })])
        }else{
            showDatePicker(sourceView: TransferDocumentViewController.getNibName(), selectedDate: self.selectedDate)
        }
        
    }
    
    func getHeaderTitle() -> NSAttributedString{
        var attrHeader = NSMutableAttributedString(string: String.fa.fontAwesome(.calendar), attributes: [NSAttributedString.Key.font : UIFont.fa?.fontSize(14), NSAttributedString.Key.foregroundColor:UIColor.primaryTextColor])
        if let date = self.selectedDate{
            attrHeader.append(NSAttributedString(string: " \(LocalizedStrings.transfer_date_header_selected_date.localizedString(params: [dateFormatter.string(from: date)]))", attributes: nil))
        }else{
            attrHeader.append(NSAttributedString(string: " \(LocalizedStrings.transfer_date_header_tap_to_set_date.localizedString())", attributes: nil))
        }
        return attrHeader
    }
}

extension TransferDocumentViewController: UITableViewDataSource,UITableViewDelegate{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.transfers.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 && self.transfers.count > 0{
            var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")
            if header == nil{
                header = UITableViewHeaderFooterView(reuseIdentifier: "Header")
                let chipView = MDCChipView(frame: CGRect(x: 8, y: 4, width: tableView.bounds.width - 16, height: 40))
                chipView.backgroundColor = .serviceItemBackground
                chipView.tag = 1000
                chipView.addTarget(self, action: #selector(didTapHeaderView), for: .touchUpInside)
                header?.contentView.addSubview(chipView)
                header?.backgroundColor = tableView.backgroundColor
                header?.contentView.backgroundColor = tableView.backgroundColor
            }
            if let chipView = header?.contentView.viewWithTag(1000) as? MDCChipView{
                chipView.titleLabel.attributedText = self.getHeaderTitle()
            }
            return header
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return self.transfers.count > 0 ? 48.0 : 0
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{ //Transfer listesi
            
            let cell:TransferCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TransferCellTableViewCell
            cell.load(transfer: self.transfers[indexPath.row])
            cell.contentView.backgroundColor = tableView.backgroundColor
            cell.backgroundColor = tableView.backgroundColor
            return cell
        }else{ //Yeni transfer ekle
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell-Empty")!
            if cell.contentView.viewWithTag(1000) == nil{
                let chipView = MDCChipView(frame: CGRect(x: 8, y: 4, width: tableView.bounds.width - 16, height: 40))
                chipView.backgroundColor = .serviceItemBackground
                var attrString = NSMutableAttributedString(string: String.fa.fontAwesome(.plusCircle), attributes: [NSAttributedString.Key.font : UIFont.fa?.fontSize(14), NSAttributedString.Key.foregroundColor:UIColor.primaryTextColor])
                attrString.append(NSAttributedString(string: " \(LocalizedStrings.transfer_source_tap_here_to_add.localizedString())"))
                chipView.titleLabel.attributedText = attrString
                chipView.isUserInteractionEnabled = false
                chipView.tag = 1000
                cell.contentView.addSubview(chipView)//
            }
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = tableView.backgroundColor
            cell.backgroundColor = tableView.backgroundColor
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 { //Yeni Ekle
            self.showTransferSourceSelector()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            heightDict[self.transfers[indexPath.row]] = cell.frame.size.height
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return heightDict[self.transfers[indexPath.row]] ?? UITableView.automaticDimension
        }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return heightDict[self.transfers[indexPath.row]] ?? 200
        }else{
            return 60
        }
    }
}

extension TransferDocumentViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.isEqual(self.pickerSchemeSelector) {
            return self.schemes.count
        }
        return pickerView.isEqual(self.pickerUrgency) ? urgencyNameArray.count : typeNameArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isEqual(self.pickerSchemeSelector) {
            return self.schemes[row]
        }
        return pickerView.isEqual(self.pickerUrgency) ? urgencyNameArray[row].localizedString() : typeNameArray[row].localizedString()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.isEqual(self.pickerSchemeSelector) {
            print("selected: \(schemes[row])")
            self.selectedSchemeName = schemes[row].count == 0 ? nil : schemes[row]
            return
        }

        if pickerView.isEqual(self.pickerUrgency) && row > 0{
            self.transfers[pickerView.tag].urgency = self.urgencyTypeArray[row-1]
        }else{
            self.transfers[pickerView.tag].type = self.typeArray[row]
        }
        self.tableView?.reloadRows(at: [IndexPath(row: pickerView.tag, section: 0)], with: .none)
    }
}

extension TransferDocumentViewController:InputDialogDelegate{
    
    func didTapPositive(dialog: DialogWithInputFieldViewController, text: String?) {
        dialog.dismiss(animated: true) {
            
            guard let _ = dialog.customObject as? [TransferDocumentModel] else{
                self.heightDict.removeValue(forKey: self.transfers[dialog.view.tag]) //Not girilmiş
                self.transfers[dialog.view.tag].notes = text
                self.tableView?.reloadRows(at: [IndexPath(row: dialog.view.tag, section: 0)], with: .none)
                return
            }
            self.postTransfers(note:text)
        }
    }
    
    func didTapNegative(dialog: DialogWithInputFieldViewController) {
        print("cancel")
        dialog.dismiss(animated: true, completion: nil)
    }
}

extension TransferDocumentViewController:BatchOperationDelegate{
    
    func didFinishAllOperations(viewController: BatchOperationViewController,isAllSuccess: Bool) {
        viewController.dismiss(animated: true, completion: nil)
        
        if isAllSuccess {
            AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.batch_transfer.localizedString(), message: LocalizedStrings.batch_transfer_success.localizedString(), doneButtonTitle: nil) {
                Observers.reload_folder.post(userInfo: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func didTapRetryOperation(viewController: BatchOperationViewController, id: Int) {
        guard let document = self.documents?.first(where: {$0.id == id}) else {return}
        self.postDocumentForBatchTransfer(document: document,promptResult: self.promptResult)
    }
    
    func cancelRemainingOperations() {
        ApiClient.cancelAllRequests { () -> Void? in
            DispatchQueue.main.async {
                Observers.reload_folder.post(userInfo: nil)
                self.navigationController?.popViewController(animated: true)
                
            }
            return nil
        }
    }
}

extension TransferDocumentViewController:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtPicker {
            print("end editing: \(textField.text)")
            guard let selectedScheme = self.selectedSchemeName else{
                return
            }
            ApiClient.get_saved_distribution_detail(name: selectedScheme)
                .execute { (_ response:GetDistributionDetailResponse?, error, statusCode) in
                    if let response = response, response.distributions.count > 0{
                        if self.transfers == nil {
                            self.transfers = []
                        }
                        var transferList:[TransferDocumentModel] = []
                        var doesHaveDuplicate = false
                        for dist in response.distributions{
                            var transfer = TransferDocumentModel(urgency: .document_urgency_normal, type: .distribution_type_information, transferSource: .none, notes: "", id: 0, title: "", departments: [])
                            transfer.urgency = .document_urgency_normal
                            transfer.type = DocumentDistrubutionTypeEnum(rawValue: dist.documentDistributionTypeEnum)
                            if dist.targetUserId != nil{
                                transfer.title = dist.name
                                transfer.id = dist.targetUserId
                                transfer.transferSource = .transfer_source_user
                            }else if(dist.targetDepartmentId != nil){
                                transfer.title = dist.name
                                transfer.id = dist.targetDepartmentId
                                transfer.transferSource = .transfer_source_depoartment
                            }else if(dist.targetDepartmentGroupId != nil){
                                var departmentGroup = DepartmentGroupItem(fromDictionary: [:])
                                transfer.title = dist.name ?? "Dağıtım Grubu"
                                departmentGroup.departmentId = dist.targetDepartmentGroupId
                                departmentGroup.documentDistributionTypeEnum = dist.documentDistributionTypeEnum
                                departmentGroup.isIncluded = true
                                departmentGroup.name = dist.name
                                transfer.transferSource = .transfer_source_distribution
                            }
                            
                            if self.transfers.contains(where: { (model) -> Bool in
                                return model.id == transfer.id && model.title.elementsEqual(transfer.title)
                            }){
                                doesHaveDuplicate = true;
                            }else{
                                transferList.append(transfer)
                            }
                        }
                        self.transfers.append(contentsOf: transferList)
                        self.tableView?.reloadData()
                        
                        if doesHaveDuplicate{
                            self.showBasicAlert(title: LocalizedStrings.transfer, message: .transfer_template_add_duplicate_error, okTitle: nil, actionHandler: nil)
                        }
                    }
            }
        }
    }
}

//var urgency:DocumentUrgencyEnum?
//var type:DocumentDistrubutionTypeEnum?
//var transferSource:DocumentTransferSource?
//var notes:String?
//var id:Int?
//var title:String
//var departments:[DepartmentGroupItem] = []
