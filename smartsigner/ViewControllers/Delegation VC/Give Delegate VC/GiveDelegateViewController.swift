//
//  GiveDelegateViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 18.10.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents


struct GiveDelegateModel {
    var mainUser:User?
    var delegateUser:User?
    var isVirtual:Bool = false
    var isUsingModelForSearch = false
    
}

class GiveDelegateViewController: BaseViewController {

    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var btnGiveDelegate:MDCButton?
    
    var delegationSetup:GiveDelegateModel = GiveDelegateModel(mainUser: nil, delegateUser: nil, isVirtual: false,isUsingModelForSearch: false )
    var virtualDelegates:[GiveDelegateModel] = []
    
    var beginDate:Date?
    var endDate:Date?
    
    var isShowingDatePicker:Bool = false
    var isPickingBeginDate:Bool = true
    var note:String = ""
    
    deinit {
        Observers.give_delegate_setup_delegate.removeObserver(observer: self)
        Observers.give_delegate_set_date.removeObserver(observer: self)
        Observers.give_delegate_note.removeObserver(observer: self)
        Observers.delegate_search_select.removeObserver(observer: self)
    }
    
    var delegationTypes:[GiveDelegationType] = [
        .give_delegation_is_active,
        .give_delegation_dont_see_older_items,
        .give_delegation_dont_see_older_received_items,
        .give_delegation_asil_user_can_operate_read_only_mode,
        .give_delegation_show_document_notes,
        .give_delegation_dont_see_older_items_for_department,
        .give_delegation_dont_see_older_received_items_for_department
    ]
    
    var delegationTypeStates:[GiveDelegationType:Bool] = [
        .give_delegation_is_active:true,
        .give_delegation_dont_see_older_items:false,
        .give_delegation_dont_see_older_received_items:false,
        .give_delegation_asil_user_can_operate_read_only_mode:false,
        .give_delegation_show_document_notes:false,
        .give_delegation_dont_see_older_items_for_department:false,
        .give_delegation_dont_see_older_received_items_for_department:false
        ]
    
    var heightDict:[IndexPath:CGFloat] = [:]
    
    convenience init() {
        self.init(nibName: "GiveDelegateViewController", bundle: .main)
        if  SessionManager.current.delegateConfig?.userHasAllUsersToUpdate ?? false == false {
            var user = User(fromDictionary: [:])
            user.name = SessionManager.current.loginData?.loggedUserName
            user.surname = SessionManager.current.loginData?.loggedUserSurname
            user.id = SessionManager.current.loginData?.loggedUserId
            self.delegationSetup.mainUser = user
        }
        self.subViewLayoutBlock = {
            self.commonInit(trackingScrollView: self.tableView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = LocalizedStrings.delegate_tabbar_title_create.localizedString()
        
        tableView?.register(UINib(nibName: "GiveDelegateDelegateTableViewCell", bundle: .main), forCellReuseIdentifier: "GiveDelegateDelegateTableViewCell")
        tableView?.register(UINib(nibName: "GiveDelegateDateTableViewCell", bundle: .main), forCellReuseIdentifier: "GiveDelegateDateTableViewCell")
        tableView?.register(UINib(nibName: "GiveDelegateDatePickerTableViewCell", bundle: .main), forCellReuseIdentifier: "GiveDelegateDatePickerTableViewCell")
        tableView?.register(UINib(nibName: "GiveDelegateSwitchTableViewCell", bundle: .main), forCellReuseIdentifier: "GiveDelegateSwitchTableViewCell")
        tableView?.register(UINib(nibName: "GiveDelegateNoteTableViewCell", bundle: .main), forCellReuseIdentifier: "GiveDelegateNoteTableViewCell")
        
        Observers.give_delegate_setup_delegate.addObserver(observer: self, selector: #selector(didReceiveSetupDelegateNotification(notification:)))
        Observers.give_delegate_set_date.addObserver(observer: self, selector: #selector(didReceiveDateNotification(notification:)))
        Observers.give_delegate_note.addObserver(observer: self, selector: #selector(didReceiveNoteNotification(notification:)))
        Observers.delegate_search_select.addObserver(observer: self, selector: #selector(didReceiveSelectUserNotification(notification:)))
        
        self.btnGiveDelegate?.setTitle(LocalizedStrings.delegate_tabbar_title_create.localizedString(), for: .normal)
        ThemeManager.applyButtonColorTheme(button: self.btnGiveDelegate ?? MDCButton())
        
        self.btnGiveDelegate?.setElevation(ShadowElevation.cardResting, for: UIControl.State.normal)
        
        let barBtnCancel = UIBarButtonItem(title: LocalizedStrings.close.localizedString(), style: .done, target: self, action: #selector(didTapCancelButton))
        self.navigationItem.leftBarButtonItem = barBtnCancel
        self.tableView?.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 40, right: 0)
        self.tableView?.backgroundColor = .tableviewBackground
        self.view.backgroundColor = .tableviewBackground
    }
    
    @objc func didTapCancelButton(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func clearAllData(){
        self.delegationSetup = GiveDelegateModel(mainUser: nil, delegateUser: nil, isVirtual: false, isUsingModelForSearch:false)
        self.beginDate = nil
        self.endDate = nil
        delegationTypeStates = [
            .give_delegation_is_active:true,
            .give_delegation_dont_see_older_items:false,
            .give_delegation_dont_see_older_received_items:false,
            .give_delegation_asil_user_can_operate_read_only_mode:false,
            .give_delegation_show_document_notes:false,
            .give_delegation_dont_see_older_items_for_department:false,
            .give_delegation_dont_see_older_received_items_for_department:false
        ]
        self.tableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        self.tableView?.reloadData()
    }
    
    @IBAction func didTapGiveDelegateButton(){
        print("give delegate")
        
        var errorString:LocalizedStrings?
        
        if delegationSetup.mainUser == nil {
            errorString = LocalizedStrings.give_delegation_save_error_must_select_main_user
        }else if delegationSetup.delegateUser == nil{
            errorString = LocalizedStrings.give_delegation_save_error_must_select_delegate_user
        }else if beginDate == nil || endDate == nil{
            errorString = LocalizedStrings.give_delegation_save_error_must_select_date
        }else if note.count == 0{
            errorString = LocalizedStrings.give_back_empty_desc_error
        }
        
        if let error = errorString{
            showBasicAlert(title: .delegate_tabbar_title_create, message: error, okTitle: .ok, actionHandler: nil)
        }else{
            let dialog = showProgressDialog(title: LocalizedStrings.delegate_tabbar_title_create, message: LocalizedStrings.empty_string)
            ApiClient.give_delegation(activeUserId: self.delegationSetup.delegateUser?.id ?? 0, passiveUserId: self.delegationSetup.mainUser?.id ?? 0, beginDate: self.beginDate ?? Date(), endDate: self.endDate ?? Date(), typeDict: self.delegationTypeStates, note: self.note)
                .execute { (_ response:ApiResponse?, error, statusCode) in
                    dialog?.dismiss(animated: true, completion: {
                        if response?.errorContent() == nil{
                            self.showBasicAlert(title: LocalizedStrings.delegate_tabbar_title_create, message: LocalizedStrings.give_delegation_save_success, okTitle: .ok, actionHandler: {action in
                                
                                self.dismiss(animated: true, completion: {
                                    Observers.logout.post(userInfo: nil)
                                })
                                
                            })
                        }
                    })
            }
        }
    }
    
    @objc func didReceiveSelectUserNotification(notification:Notification){
        guard let model = notification.userInfo?[Observers.keys.give_delegate_model.rawValue] as? GiveDelegateModel else{
            return
        }
        if !model.isVirtual{
            self.delegationSetup = model
            self.tableView?.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    @objc func didReceiveNoteNotification(notification:Notification){
        guard let note = notification.userInfo?[Observers.keys.string_value.rawValue] as? String else{
            return
        }
        self.note = note
        self.tableView?.beginUpdates()
        self.tableView?.endUpdates()
    }
    
    @objc func didReceiveDateNotification(notification:Notification){
        guard
            let date = notification.userInfo?[Observers.keys.selected_date.rawValue] as? Date,
            let isBeginDate = notification.userInfo?[Observers.keys.is_begin_date.rawValue] as? Bool else{
                return
        }
        if isBeginDate{
            self.beginDate = date
        }else{
            self.endDate = date
        }
    }
    
    @objc func didReceiveSetupDelegateNotification(notification:Notification){
        guard
            let model = notification.userInfo?[Observers.keys.delegate_model.rawValue] as? GiveDelegateModel,
            let isDelegate = notification.userInfo?[Observers.keys.is_delegate_user.rawValue] as? Bool else{
            return
        }
        
        print("\(model), isDelegate:\(isDelegate)")
        let vc = SearchDelegateViewController(model: model, isDelegate: isDelegate)
        let navCon = UINavigationController(rootViewController: vc)
        navCon.isNavigationBarHidden = true
        self.present(navCon, animated: true, completion: nil)
    }
}

extension GiveDelegateViewController:UISearchControllerDelegate{
    
}

extension GiveDelegateViewController:UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: //Ana Vekil Adı / Asil Adı Alanı
            return 1
        case 1: //Sanal Kullanıcı
            return self.virtualDelegates.count
        case 2: // Tarih Ayarları
            return 2
        case 3:
            return self.delegationTypes.count
        case 4:
            return 1
        case 5:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section != 4 && indexPath.section != 2{
            heightDict[indexPath] = cell.frame.size.height
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightDict[indexPath] ?? 76
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightDict[indexPath] ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 || indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GiveDelegateDelegateTableViewCell", for: indexPath) as! GiveDelegateDelegateTableViewCell
            cell.load(model: indexPath.section == 0 ? self.delegationSetup : self.virtualDelegates[indexPath.row])
            return cell
        }else if indexPath.section == 2{
            
            var cellId = "GiveDelegateDateTableViewCell"
            if indexPath.row == 0 && isShowingDatePicker && isPickingBeginDate{
                cellId = "GiveDelegateDatePickerTableViewCell"
            }
            if indexPath.row == 1 && isShowingDatePicker && !isPickingBeginDate{
                cellId = "GiveDelegateDatePickerTableViewCell"
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GiveDelegateDateTableViewCell
            if indexPath.row == 0{
                cell.load(title: LocalizedStrings.begin.localizedString(), date: beginDate, isBeginDate: true)
            }else{
                cell.load(title: LocalizedStrings.end.localizedString(), date: endDate, isBeginDate: false)
            }
            return cell
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GiveDelegateSwitchTableViewCell", for: indexPath) as! GiveDelegateSwitchTableViewCell
            let type = self.delegationTypes[indexPath.row]
            cell.loadCell(type: type, isSelected: self.delegationTypeStates[type] ?? false)
            return cell
        }else if indexPath.section == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GiveDelegateNoteTableViewCell", for: indexPath) as! GiveDelegateNoteTableViewCell
            cell.load(note: self.note)
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            if indexPath.row == 0{
                if isShowingDatePicker{
                    if isPickingBeginDate{
                        isShowingDatePicker = false
                    }else{
                        isPickingBeginDate = true
                    }
                }else{
                    isShowingDatePicker = true
                    isPickingBeginDate = true
                }
            }else{
                if isShowingDatePicker{
                    if isPickingBeginDate{
                        isPickingBeginDate = false
                    }else{
                        isShowingDatePicker = false
                    }
                }else{
                    isShowingDatePicker = true
                    isPickingBeginDate = false
                }
            }
            tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
        }else if indexPath.section == 3{
            let type = self.delegationTypes[indexPath.row]
            if let state = self.delegationTypeStates[type]{
                self.delegationTypeStates[type] = !state
            }else{
                self.delegationTypeStates[type] = true
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
