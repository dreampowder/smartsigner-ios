//
//  TaskDetailViewController.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 21.11.2019.
//  Copyright © 2019 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents

enum TaskEditButtonMode{
    case none
    case close
    case reopen
    
}

class TaskDetailViewController: BaseViewController {

    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var commentContainer:UIView?
    @IBOutlet weak var txtComment:UITextView?
    @IBOutlet weak var btnSendComment:UIButton?
    @IBOutlet weak var constTextViewContainer:NSLayoutConstraint?
    
    var dialogTranstitionController = MDCDialogTransitionController()
    var note:TaskNote?
    var taskOperations:[TaskNoteOperation] = []
    let activityIndicator = UIActivityIndicatorView(style: .white)
    let btnActionBar = UIButton(type: .custom)
    let dateFormatter = DateFormatter()
    let dateFormatterCell = DateFormatter()
    
    var buttonMode:TaskEditButtonMode = .none
    
    deinit {
        Observers.did_select_date.removeObserver(observer: self)
    }
    
    convenience init(note:TaskNote) {
        self.init(nibName:"TaskDetailViewController", bundle:.main)
        self.note = note
    }
    
    override func viewDidLayoutSubviews() {
        if !didLayoutSubviews{
            didLayoutSubviews = true
            commonInit(trackingScrollView: self.tableView)
            self.tableView?.backgroundColor = .tableviewBackground
            btnSendComment?.setAttributedTitle(NSAttributedString(string: String.fa.fontAwesome(.paperPlane), attributes: [NSAttributedString.Key.font : UIFont.fa?.fontSize(22), NSAttributedString.Key.foregroundColor:UIColor.secondaryColor]), for: .normal)
            txtComment?.backgroundColor = .serviceItemBackground
            txtComment?.layer.cornerRadius = 4.0
            txtComment?.layer.masksToBounds = true
            txtComment?.textColor = UIColor.primaryTextColor
            txtComment?.tintColor = UIColor.primaryTextColor
            txtComment?.delegate = self
            txtComment?.translatesAutoresizingMaskIntoConstraints = true
            txtComment?.textColor = .secondaryTextColor
            txtComment?.text = LocalizedStrings.task_comment_placeholder.localizedString()
            
            self.btnSendComment?.isEnabled = false
            self.btnSendComment?.addTarget(self, action: #selector(didTapSendCommentButton), for: .touchUpInside)
            
            self.view.backgroundColor = .tableviewBackground
            activityIndicator.tintColor = .primaryTextColor
            
            self.activityIndicator.sizeToFit()
            self.activityIndicator.hidesWhenStopped = true
            let barBtnActivity = UIBarButtonItem(customView: self.activityIndicator)
            
            self.btnActionBar.setTitle("", for: .normal)
            self.btnActionBar.sizeToFit()
            let barBtnAction = UIBarButtonItem(customView: self.btnActionBar)
            
            let viewSpace = UIView(frame: CGRect(x: 0, y: 0, width: 8.0, height: 0))
            viewSpace.backgroundColor = .clear
            let barItemSpace = UIBarButtonItem(customView: viewSpace)
            
            let viewSpace2 = UIView(frame: CGRect(x: 0, y: 0, width: 8.0, height: 0))
            viewSpace2.backgroundColor = .clear
            let barItemSpace2 = UIBarButtonItem(customView: viewSpace)
            
            self.navigationItem.rightBarButtonItems = [barItemSpace2,barBtnActivity,barItemSpace,barBtnAction]
            
            self.tableView?.separatorStyle = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.register(UINib(nibName: "TaskUserListTableViewCell", bundle: .main), forCellReuseIdentifier: "UserCell")
        self.tableView?.register(UINib(nibName: "TaskDueDateTableViewCell", bundle: .main), forCellReuseIdentifier: "DateCell")
        self.tableView?.register(UINib(nibName: "TaskNotesTableViewCell", bundle: .main), forCellReuseIdentifier: "NoteCell")
        self.tableView?.register(UINib(nibName: "TaskOperationTableViewCell", bundle: .main), forCellReuseIdentifier: "OperationCell")
        self.dateFormatter.dateFormat = "d.MM.yyyy HH:mm:ss"
        self.dateFormatterCell.dateFormat = "dd.MM.yyyy"
        fetchData()
        self.title = note?.documentSubject ?? LocalizedStrings.task_detail_title.localizedString()
        Observers.did_select_date.addObserver(observer: self, selector: #selector(didReceiveDateSelect(notification:)))
        self.btnActionBar.addTarget(self, action: #selector(didTapActionBarButton), for: .touchUpInside)
        setupBarbuttonItems()
    }
    
    func setupBarbuttonItems(){
        guard let note = self.note else{return}
        self.buttonMode = .none
        if note.status == "Beklemede" && note.taskNoteUsers.count ?? 0 > 0 && note.taskNoteUsers.filter({ (user) -> Bool in
            return  (user.userId == SessionManager.current.loginData?.loggedUserId ||
                SessionManager.current.loginData?.delegations.filter({$0.passiveUserId == user.userId}).count ?? 0 > 0) &&
                SessionManager.current.taskNoteAssignmentTypes.contains(where: {$0.name == user.assignmentType && $0.canClose})
        }).count > 0{
            self.buttonMode = .close
        }else if note.status == "Bitirildi" && note.createdBy == SessionManager.current.loginData?.loggedUserId ?? 0{
            self.buttonMode = .reopen
        }
        var buttonTitle = "";
        if self.buttonMode == .none{
            self.btnActionBar.setTitle("", for: .normal)
        }else if self.buttonMode == .reopen{
            buttonTitle = LocalizedStrings.task_operatino_reopen.localizedString();
            print("✴️reopen")
        }else if self.buttonMode == .close{
            buttonTitle = LocalizedStrings.task_operation_close.localizedString()
            print("✴️close")
        }
        self.activityIndicator.sizeToFit()
        self.activityIndicator.hidesWhenStopped = true
        let barBtnActivity = UIBarButtonItem(customView: self.activityIndicator)
        
        self.btnActionBar.setTitle(buttonTitle, for: .normal)
        self.btnActionBar.sizeToFit()
        let barBtnAction = UIBarButtonItem(customView: self.btnActionBar)
        
        let viewSpace = UIView(frame: CGRect(x: 0, y: 0, width: 8.0, height: 0))
        viewSpace.backgroundColor = .clear
        let barItemSpace = UIBarButtonItem(customView: viewSpace)
        
        let viewSpace2 = UIView(frame: CGRect(x: 0, y: 0, width: 8.0, height: 0))
        viewSpace2.backgroundColor = .clear
        let barItemSpace2 = UIBarButtonItem(customView: viewSpace)
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItems = [barItemSpace2,barBtnActivity,barItemSpace,barBtnAction]
        }
        
    }
    
    @objc func didTapActionBarButton(){
        guard self.buttonMode != .none else{return}
        
        var request = SaveTaskNoteOperationRequest(fromDictionary: [:])
        request.taskNoteId = note?.id ?? 0
        switch self.buttonMode {
        case .close:
            request.operationType = TaskNoteOperationType.finish_task.rawValue
        case .reopen:
            request.operationType = TaskNoteOperationType.reopen_task.rawValue
        default:
            break
        }
        sendTaskRequest(request: request)
    }
    
    func fetchData(){
        ApiClient.get_task_note(id: note?.id ?? 0).execute { (_ response:GetSingleTaskNoteResponse?, error, statusCode) in
            print("get response: \(response?.taskNote.taskNoteUsers.count ?? 0)")
            Utilities.processApiResponse(parentViewController: self, response: response) {
                self.note = response?.taskNote
                self.tableView?.reloadData()
                self.fetchOperations()
                self.setupBarbuttonItems()
            }
        }
    }
    
    func fetchOperations(){
        ApiClient.get_task_operations(id: note?.id ?? 0)
            .execute { (_ response:GetTaskNoteOperationsResponse?, error, statusCode) in
                print("Got Task List resopnse")
                Utilities.processApiResponse(parentViewController: self, response: response) {
                    self.taskOperations = response?.taskNoteOperations ?? []
                    self.tableView?.reloadSections(IndexSet(integer: 3), with: .automatic)
                }
        }
    }
    
    @objc func didReceiveDateSelect(notification:Notification){
        guard let selectedDate = notification.userInfo?[Observers.keys.selected_date.rawValue] as? Date else{
            return
        }
        var operationRequest = SaveTaskNoteOperationRequest(fromDictionary: [:])
        operationRequest.operationType = TaskNoteOperationType.update_date.rawValue
        operationRequest.taskNoteId = self.note?.id ?? 0
        operationRequest.dueDate = selectedDate.toDotNet()
        operationRequest.uiPayload = dateFormatter.string(from: selectedDate)
        sendTaskRequest(request: operationRequest)
    }
    
    @objc func didTapSendCommentButton(){
        var operationRequest = SaveTaskNoteOperationRequest(fromDictionary: [:])
        operationRequest.operationType = TaskNoteOperationType.add_comment.rawValue
        operationRequest.messageText = txtComment?.text ?? ""
        operationRequest.taskNoteId = self.note?.id ?? 0
        sendTaskRequest(request: operationRequest)
        
    }
    
    func sendTaskRequest(request:SaveTaskNoteOperationRequest){
        self.activityIndicator.startAnimating()
        ApiClient.save_task_note_operation(request: request)
            .execute { (_ response:SaveTaskNoteOperationResponse?, error, statusCode) in
                self.activityIndicator.stopAnimating()
                Utilities.processApiResponse(parentViewController: self, response: response) {
                    guard let operation = response?.taskNoteOperation, let operationType = TaskNoteOperationType.init(rawValue: request.operationType) else{
                        return
                    }
                    self.taskOperations.append(operation)
                    if self.taskOperations.count > 1{
                        self.tableView?.insertRows(at: [IndexPath(row: self.taskOperations.count-1, section: 3)], with: .automatic)
                        self.tableView?.scrollToRow(at: IndexPath(row: self.taskOperations.count-1, section: 3), at: .top, animated: true)
                    }else{
                        self.tableView?.reloadData()
                    }
                    switch operationType{
                    case .add_comment:
                        self.txtComment?.text = LocalizedStrings.task_comment_placeholder.localizedString()
                        self.txtComment?.textColor = .secondaryTextColor
                        self.btnSendComment?.isEnabled = false
                        self.txtComment?.endEditing(true)
                    case .update_date:
                        self.note?.dueDate = request.uiPayload ?? ""
                        self.tableView?.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
                    case .update_note:
                        self.note?.noteText = request.noteText
                        self.tableView?.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
                    case .reopen_task:
                        self.note?.status = "Beklemede"
                        self.setupBarbuttonItems()
                    case .finish_task:
                        if let taskLogic = response?.taskNoteOperation?.taskNoteLogic{
                            self.processTaskNoteLogic(logic: taskLogic)
                        }else{
                            self.note?.status = "Bitirildi"
                            self.setupBarbuttonItems()
                        }
                        
                    default:
                        print("operation done")
                            
                    }
                }
        }
    }
    
    func processTaskNoteLogic(logic:TaskNoteLogic){
        guard
            logic.actionUserId == SessionManager.current.loginData?.loggedUserId,
            let choices = logic.userChoices, choices.count > 0 else{
                return
        }
        
        var actions:[MDCAlertAction] = [MDCAlertAction(title: LocalizedStrings.cancel.localizedString(), handler: nil)]
        actions.append(contentsOf: choices.map({ (userChoice) -> MDCAlertAction in
            return MDCAlertAction(title: userChoice.title) { (_) in
                self.didSelectLogicAction(actionId: userChoice.id, bookmarkUUID: logic.bookmarkId,title:userChoice.title)
            }
        }))
        
        AlertDialogFactory.showAlertActionDialog(vc: self, title:
            LocalizedStrings.task_user_logic_select_action.localizedString(), message: "", actions:actions
        )
    }
    
    func didSelectLogicAction(actionId:Int, bookmarkUUID:String, title:String){
        let dialog = showProgressDialog(title: title, message: LocalizedStrings.please_wait.localizedString(), isIndeterminate: true)
        ApiClient.task_logic_bookmak(taskNoteId: self.note?.id ?? 0, bookMarkGUID: bookmarkUUID, userChoiceId: actionId)
            .execute { (_ response:RunBookmarkResponse?, error, statusCode) in
                dialog?.dismiss(animated: true, completion: {
                    guard let response = response else{
                        AlertDialogFactory.showUnexpectedErrorFromViewController(vc: self, doneButtonAction: nil)
                        return
                    }
                    if let errorContent = response.errorContent(){
                        AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.error.localizedString(), message: errorContent, doneButtonTitle: nil, doneButtonAction: nil)
                    }else{
                        if let result = response.logicResult {
                            if !result.isSuccess {
                                AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.error.localizedString(), message: Utilities.getErrorContent(exceptionMessage: result.details, exceptionCode: result.errorCode) ?? "<undefined>", doneButtonTitle: nil) {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }else{
                                AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.success.localizedString(), message: result.details, doneButtonTitle: LocalizedStrings.ok.localizedString()) {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }else{ //Hata
                            AlertDialogFactory.showUnexpectedErrorFromViewController(vc: self, doneButtonAction: nil)
                        }
                    }
                })
        }
    }
}

extension TaskDetailViewController:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = .primaryTextColor
        if textView.text == LocalizedStrings.task_comment_placeholder.localizedString() {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.text = LocalizedStrings.task_comment_placeholder.localizedString()
            textView.textColor = .secondaryTextColor
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = UIScreen.main.bounds.width - 24 - 30 
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: fixedWidth, height: newSize.height)
        if newFrame.height > 150 {
            newFrame.size.height = 150.0
        }
        textView.frame = newFrame
        self.constTextViewContainer?.constant = newFrame.size.height + 8.0
        self.btnSendComment?.isEnabled = textView.text.count > 0 && textView.text != LocalizedStrings.task_comment_placeholder.localizedString()
        self.view.bringSubviewToFront(self.btnSendComment!)
    }
}

extension TaskDetailViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 || section == 2{
            return 1
        }else if section == 3{
            return self.taskOperations.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: //Task User
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for:indexPath) as! TaskUserListTableViewCell
            cell.load(users: self.note?.taskNoteUsers ?? [])
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! TaskDueDateTableViewCell
            if let dateStr = self.note?.dueDate {
                if let date = dateFormatter.date(from: dateStr){
                    cell.load(date: dateFormatterCell.string(from: date))
                }else{
                    cell.load(date: dateStr)
                }
            }else{
                cell.load(date: "-")
            }
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! TaskNotesTableViewCell
            cell.load(note: self.note?.noteText ?? "-")
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OperationCell", for: indexPath) as! TaskOperationTableViewCell
            cell.load(operation: self.taskOperations[indexPath.row], isFirstCell: indexPath.row == 0)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let date = dateFormatter.date(from: self.note?.dueDate ?? "")
            showDatePicker(sourceView: "DueDate", selectedDate: date)
        }else if indexPath.section == 2{
            let dialog = AlertDialogFactory.showAlertWithTextInputFromViewController(vc: self, placeholder: LocalizedStrings.task_notes.localizedString(), title:LocalizedStrings.task_notes.localizedString() , positiveTitle: LocalizedStrings.save.localizedString(), negativeTitle: LocalizedStrings.cancel.localizedString(), delegate: self)
            dialog.initialValue = self.note?.noteText ?? ""
            dialog.modalPresentationStyle = .custom
            dialog.transitioningDelegate = self.dialogTranstitionController
            dialog.preferredContentSize = CGSize(width: self.view.bounds.width - 32, height: 200)
            present(dialog, animated: true, completion: nil)
        }
    }
}

extension TaskDetailViewController:InputDialogDelegate{
    func didTapPositive(dialog: DialogWithInputFieldViewController, text: String?) {
        if let text = text {
            dialog.dismiss(animated: true) {
                var operationRequest = SaveTaskNoteOperationRequest(fromDictionary: [:])
                operationRequest.operationType = TaskNoteOperationType.update_note.rawValue
                operationRequest.taskNoteId = self.note?.id ?? 0
                operationRequest.noteText = text
                operationRequest.uiPayload = text
                self.sendTaskRequest(request: operationRequest)
            }
        }
    }
    
    func didTapNegative(dialog: DialogWithInputFieldViewController) {
        dialog.dismiss(animated: true) {
            
        }
    }
}
