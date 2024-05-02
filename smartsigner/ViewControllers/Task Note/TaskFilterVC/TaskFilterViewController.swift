//
//  TaskFilterViewController.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 21.11.2019.
//  Copyright © 2019 Seneka. All rights reserved.
//

import UIKit

import MaterialComponents

protocol TaskFilterDelegate {
    func didApplyFilter(filter:FilterModel?)
}

class TaskFilterViewController: UIViewController {

    @IBOutlet weak var viewContainer:UIView?
    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var constContainerLeft:NSLayoutConstraint?
    @IBOutlet weak var btnApply:MDCButton?
    @IBOutlet weak var btnCancel:UIButton?
    
    var didInitialize = false
    var didShow = false
    var filterModel:FilterModel?
    let dfCell:DateFormatter = DateFormatter()
    var delegate:TaskFilterDelegate?
    
    deinit {
        self.delegate = nil
        Observers.delegate_search_select.removeObserver(observer: self)
        Observers.did_select_date.removeObserver(observer: self)
    }
    
    convenience init(filter:FilterModel, delegate:TaskFilterDelegate) {
        self.init(nibName: "TaskFilterViewController", bundle: .main)
        self.filterModel = filter
        self.delegate = delegate
        self.dfCell.dateFormat = "dd.MM.yyyy"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !didInitialize{
            didInitialize = true
            constContainerLeft?.constant = UIScreen.main.bounds.width + 40.0
            ThemeManager.applyButtonColorTheme(button: self.btnApply!)
            
            self.btnApply?.setTitle(LocalizedStrings.apply_filter.localizedString(), for: .normal)
            self.btnCancel?.setTitle(LocalizedStrings.cancel.localizedString().uppercased(with: Locale(identifier: LocalizedStrings.getCurrentLocale())), for: .normal)
            self.btnCancel?.tintColor = .red
            self.viewContainer?.layer.shadowOffset = CGSize(width: -4, height: 0)
            self.viewContainer?.layer.shadowColor = UIColor.black.cgColor
            self.viewContainer?.layer.shadowOpacity = 0.4
            self.viewContainer?.layer.shadowRadius = 3.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !didShow{
            didShow = true
            toggleView(willShow: true)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOutside(sender:)))
            tapGesture.numberOfTapsRequired = 1;
            tapGesture.delegate = self
            self.view.addGestureRecognizer(tapGesture)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.register(UINib(nibName: "TaskFilterInputFieldTableViewCell", bundle: .main), forCellReuseIdentifier: "InputCell")
        self.tableView?.register(UINib(nibName: "TaskFilterDatePickerTableViewCell", bundle: .main), forCellReuseIdentifier: "DateCell")
        
        Observers.delegate_search_select.addObserver(observer: self, selector: #selector(didReceiveUserSelectNotification(notification:)))
        Observers.did_select_date.addObserver(observer: self, selector: #selector(didReceiveSelectDateNotification(notification:)))
        self.btnApply?.addTarget(self, action: #selector(didTapApplyButton), for: .touchUpInside)
        self.btnCancel?.addTarget(self, action: #selector(didTapOutside(sender:)), for: .touchUpInside)
    }

        
    
    @objc func didTapOutside(sender:Any){
        toggleView(willShow: false)
    }

    func toggleView(willShow:Bool){
        if willShow{
            UIView.animate(withDuration: 0.15, animations: {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
            }) { (complete) in
                if complete{
                    UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.50, options: .curveEaseOut, animations: {
                        self.constContainerLeft?.constant = 100.0
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                }
            }
        }else{
            UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.50, options: .curveEaseOut, animations: {
                self.constContainerLeft?.constant = UIScreen.main.bounds.width + 40.0
                self.view.layoutIfNeeded()
            }) { (complete) in
                UIView.animate(withDuration: 0.15, animations: {
                    self.view.backgroundColor = .clear
                }) { (complete) in
                    if complete{
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    func showStatusSelector(){
        showAlert(title: LocalizedStrings.task_status.localizedString(), message: LocalizedStrings.tap_to_select.localizedString(), actions: [
            (title: LocalizedStrings.cancel, handler: {action in

            }),
            (title: LocalizedStrings.task_status_draft, handler: {action in
                self.filterModel?.status = .draft
                self.tableView?.reloadData()
            }),
            (title: LocalizedStrings.task_status_finished, handler: {action in
                self.filterModel?.status = .finished
                self.tableView?.reloadData()
            }),
            (title: LocalizedStrings.task_status_waiting, handler: {action in
                self.filterModel?.status = .waiting
                self.tableView?.reloadData()
            })
        ])
    }
    
    func showUserSelector(dataType:TaskFilterFieldType){
        let vc = SearchDelegateViewController(model: GiveDelegateModel(), isDelegate: dataType == .responsive)
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func didReceiveUserSelectNotification(notification:Notification){
        guard let model = notification.userInfo?[Observers.keys.give_delegate_model.rawValue] as? GiveDelegateModel else{return}
        if let creator = model.mainUser {
            self.filterModel?.creator = creator
        }else if let responsive = model.delegateUser{
            self.filterModel?.responsive = responsive
        }
        self.tableView?.reloadData()
    }
    
    @objc func didReceiveSelectDateNotification(notification:Notification){
        guard let source = notification.userInfo?[Observers.keys.source_view.rawValue] as? String,
            let dataTypeName = source.components(separatedBy: "-").first,
            let dataType = TaskFilterFieldType(rawValue: dataTypeName),
            let selectedDate = notification.userInfo?[Observers.keys.selected_date.rawValue] as? Date else{
            return
        }
        let isBeginDate = source.components(separatedBy: "-").last ?? "" == "begin"
        switch dataType {
        case .created_at:
            if isBeginDate{
                self.filterModel?.createdAtBegin = selectedDate
            }else{
                self.filterModel?.createdAtEnd = selectedDate
            }
        case .due_date:
            if isBeginDate{
                self.filterModel?.dueDateBegin = selectedDate
            }else{
                self.filterModel?.dueDateEnd = selectedDate
            }
        default:
            break
        }
        self.tableView?.reloadData()
    }
    
    @objc func didTapApplyButton(){
        self.delegate?.didApplyFilter(filter: self.filterModel)
        self.toggleView(willShow: false)
    }
}

extension TaskFilterViewController:UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}

extension TaskFilterViewController:InputFieldFilterCellDelegate{
    
    func didTapClearDateButton(dataType: TaskFilterFieldType, isBeginDate: Bool) {
        if dataType == .created_at{
            if isBeginDate {
                self.filterModel?.createdAtBegin = nil
            }else{
                self.filterModel?.createdAtEnd = nil
            }
        }else{
            if isBeginDate {
                self.filterModel?.dueDateBegin = nil
            }else{
                self.filterModel?.dueDateEnd = nil
            }
        }
        self.tableView?.reloadData()
    }
    
    func didTapDateInputField(dataType: TaskFilterFieldType, isBeginDate: Bool) {
        
        var selectedDate:Date?
        if dataType == .created_at {
            selectedDate = isBeginDate ? self.filterModel?.createdAtBegin : self.filterModel?.createdAtEnd
        }else{
            selectedDate = isBeginDate ? self.filterModel?.dueDateBegin : self.filterModel?.dueDateEnd
        }
        
        showDatePicker(sourceView: "\(dataType)-\(isBeginDate ? "begin" : "end")", selectedDate: selectedDate)
    }
    
    func didEnterText(dataType: TaskFilterFieldType, text: String?) {
        print("\(dataType) did enter test: \(text ?? "<none>")")
        switch dataType {
        case .number:
            self.filterModel?.number = Int(text ?? "")
        case .barcode_or_documentNr:
            self.filterModel?.barcodeOrSubject = text
        default:
            break
        }
    }
    
    func didFocusTextInput(dataType: TaskFilterFieldType) {
        print("\(dataType) did focus")
        switch dataType {
        case .creator, .responsive:
            showUserSelector(dataType: dataType)
        case .status:
            showStatusSelector()
        default:
            break
        }
    }
    
    func didTapClearButton(dataType: TaskFilterFieldType) {
        print("\(dataType) did clear")
        switch dataType {
        case .creator:
            self.filterModel?.creator = nil
        case .responsive:
            self.filterModel?.responsive = nil
        case .status:
            self.filterModel?.status = nil
        default:
            break
        }
        self.tableView?.reloadData()
    }
}

extension TaskFilterViewController:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell", for: indexPath) as! TaskFilterInputFieldTableViewCell
            
            var value:String?
            if let user = filterModel?.creator{
                value = "\(user.name ?? "") \(user.surname ?? "")"
            }
            
            cell.load(delegate: self, title: LocalizedStrings.task_creator.localizedString(), placeholder: LocalizedStrings.tap_to_select.localizedString(), dataType: .creator, isEditable: false, value: value)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell", for: indexPath) as! TaskFilterInputFieldTableViewCell
            
            
            var value:String?
            if let user = filterModel?.responsive{
                value = "\(user.name ?? "") \(user.surname ?? "")"
            }
            
            cell.load(delegate: self, title: LocalizedStrings.task_responsive.localizedString(), placeholder: LocalizedStrings.tap_to_select.localizedString(), dataType: .responsive, isEditable: false, value:value)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell", for: indexPath) as! TaskFilterInputFieldTableViewCell
            let value = self.filterModel?.number ?? 0
            cell.load(delegate: self, title: LocalizedStrings.task_number.localizedString(), placeholder: LocalizedStrings.tap_to_enter.localizedString(), dataType: .number, isEditable: true, value: "\(value == 0 ? "" : "\(value)")")
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell", for: indexPath) as! TaskFilterInputFieldTableViewCell
            cell.load(delegate: self, title: LocalizedStrings.document_barcode_or_subject.localizedString(), placeholder: LocalizedStrings.tap_to_enter.localizedString(), dataType: .barcode_or_documentNr, isEditable: true,value: self.filterModel?.barcodeOrSubject)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell", for: indexPath) as! TaskFilterInputFieldTableViewCell
            cell.load(delegate: self, title: LocalizedStrings.task_status.localizedString(), placeholder: LocalizedStrings.tap_to_select.localizedString(), dataType: .status, isEditable: false,value: self.filterModel?.status?.getTile().localizedString())
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! TaskFilterInputFieldTableViewCell
            
            var begin:String?
            if let date = self.filterModel?.createdAtBegin{
                begin = dfCell.string(from: date)
            }
            
            var end:String?
            if let date = self.filterModel?.createdAtEnd{
                end = dfCell.string(from: date)
            }
            
            cell.loadForDate(delegate: self, title: LocalizedStrings.task_created_at.localizedString(), dataType: .created_at, beginVal: begin, endVal: end)
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! TaskFilterInputFieldTableViewCell
            
            var begin:String?
            if let date = self.filterModel?.dueDateBegin{
                begin = dfCell.string(from: date)
            }
            
            var end:String?
            if let date = self.filterModel?.dueDateEnd{
                end = dfCell.string(from: date)
            }
            
            cell.loadForDate(delegate: self, title: LocalizedStrings.task_end_at.localizedString(), dataType: .due_date, beginVal: begin, endVal: end)
            return cell
        default:
            return UITableViewCell()
        }
    }
}
