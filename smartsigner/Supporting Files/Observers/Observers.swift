//
//  Observers.swift
//  smartsigner
//
//  Created by Serdar Coskun on 25.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit

enum Observers: String {
    
    case reload_folder
    case toggle_document_detail
    case progress_update
    case update_tableview
    case action_selected
    case delegate_search_select
    case did_select_attachment
    case did_select_date
    case document_remove
    case transfer_department_select
    case transfer_user_select
    case transfer_department_group_select
    case transfer_remove_item
    case transfer_change_type_and_urgency
    case transfer_change_note
    case transfer_department_group_department_type_update
    case reload_side_menu_folders
    
    case give_delegate_setup_delegate
    case give_delegate_set_date
    case give_delegate_note
    
    case session_ended_alert
    case logout
    
    case e_sign_dismiss
    
    case batch_operation_progress
    case batch_operation_discard_fingerprint_dialog
    
    case task_note_remove_user
    
    case distribution_flow_copy_action
    case push_event_incoming_message
    
    case did_complete_ark_signer_sign
    
    public enum keys: String{
        case none
        case folder_list
        case progress_amount
        case progress_target_id
        case content_height
        case selected_action
        case selected_user
        case search_controller
        case selected_attachment
        case selected_date
        case source_view
        case removed_document
        case selected_departments
        case selected_item
        case transfer_department_distribution_type
        case transfer_change_type_and_urgency_type
        case delegate_model
        case is_delegate_user
        case is_begin_date
        case string_value
        case give_delegate_model
        case operation_id
        case operation_success
        case operation_error_content
        case is_related
        case task_note_user
        case distribution_items
        case push_data
        case sign_queue_guid
        case ark_signer_action
    }
    
    func notficationName() -> NSNotification.Name{
        return  NSNotification.Name.init(self.rawValue)
    }
    
    func post(userInfo:[keys:Any]?) -> Void {
        var dict:[String:Any] = [:]
        if let info = userInfo{
            for key in info.keys{
                dict[key.rawValue] = info[key]
            }
        }
        
        NotificationCenter.default.post(name: self.notficationName(), object:nil, userInfo: dict)
    }
    
    func postNotification(userInfo:[String:Any]?) -> Void {
        NotificationCenter.default.post(name: self.notficationName(), object:nil, userInfo: userInfo)
    }
    
    func postNotification(object:Any?, userInfo:[String:Any]?) -> Void {
        NotificationCenter.default.post(name: self.notficationName(), object:object, userInfo: userInfo)
    }
    
    func addObserver(observer:Any,selector:Selector){
        NotificationCenter.default.addObserver(observer, selector: selector, name: self.notficationName(), object: nil)
    }
    
    func removeObserver(observer:Any){
        NotificationCenter.default.removeObserver(observer, name: self.notficationName(), object: nil)
    }
    

}
