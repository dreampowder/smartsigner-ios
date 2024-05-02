//
//  LocalisedStrings.swift
//  smartsigner
//
//  Created by Serdar Coskun on 20.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import Alamofire

enum LocalizedStrings: String {

    case show_test_servers
    case hide_test_servers
    
    case version_alert_title
    case version_alert_message
    case version_alert_update_button_title
    
    //Generic Strings
    case warning
    case empty_string
    case wildcard_string
    case error
    case ok
    case error_unexpected
    case receiver
    case show_details
    case hide_details
    case number
    case barcode
    case confirm
    case cancel
    case unimplemented
    case yes
    case no
    case close
    case submit
    case begin
    case end
    case sign_mobile
    case attachment
    
    //Login Strings
    case login_button_title
    case login_corporate_code
    case login_username
    case login_password
    case login_type_mobile
    case login_type_username
    case login_national_identity
    case login_error_must_enter_company_code
    case login_error_must_enter_username
    case login_error_must_enter_password
    case login_error_incorrect_username_or_password
    case login_error_turkish_identity_wrong
    case btn_select_service_empty
    case login_mobile_sign_text
    
    
    //Fast Login İçeriği
    case fast_login_sign_description
    case btn_fast_login
    case fast_login_alert_not_set_message
    case fast_login_first_time_setup_message
    case fast_login_confirm_message
    case fast_login_select_action
    case fast_login_remove
    case fasr_login_enable_for_this_account
    case fast_login_enable_success
    case fast_login_clear_success
    
    case fast_login_logine_error_message
    //Döküman İçeriği
    case document_notes
    case document_versions
    case document_history
    
    //Döküman işlemleri
    case sign       //imzala
    case reject     //reddet
    case initials   //paraf
    case transfer   //havale
    case notes      //notlar
    case workflow   //iş akışı
    case remove_document    //dosyayı kaldır
    case take_back  //geri çek
    case give_back  //iade
    case versions   //versiyonlar
    case history    //tarihçe
    case archive    //Arşiv
    
    
    case e_sign
    case version
    case qr_code
    case sign_smart_card_error_no_sign_data
    case sign_smart_cart_certificate_not_found
    case sign_smart_card_please_select_reader
    case sign_smart_card_error_cannot_activate_show_qr_code
    case action_sign_error_mobile_sign_not_found
    case action_sign_message_sign_confirm
    case action_sign_message_paraph_confirm
    
    
    
    case target_department
    case description
    //Main Screen Strings
    case progress_loading_folder_contents
    case progress_loading_attachment
    
    case logout
    case logout_message
    
    case delegate_title
    case delegate_tabbar_title_search
    case delegate_tabbar_title_create

    case delegate_search_delegate_name_placeholder
    case delegate_search_main_name_placeholder
    case delegate_search_prevail
    case delegate_search_forfeit
    case delegate_search_all
    case delegate_search_active
    case delegate_search_passive
    case delegate_search_list
    case delegate_search_begin_date
    case delegate_search_end_date
    case delegated_by
    case delegate_search_not_found
    
    case detailed_search
    case select
    case unselect
    case notes_no_notes_to_show
    
    case begin_date
    case end_date
    case document_number
    case document_barcode_or_subject
    
    case document_paraph
    case success
    case document_takeback_message
    case document_reject_message
    case document_reject_placeholder
    case document_giveback_placeholder
    case document_giveback_message
    
    case depoartment_type_empty
    case depoartment_type_merkez_birim
    case depoartment_type_bagli_kurulus
    case depoartment_type_tasra_birimi
    case depoartment_type_diger_kamu_kurum
    case depoartment_type_sirket
    case depoartment_type_sahis
    
    case distribution_type_geregi
    case distribution_type_information
    case distribution_type_coordinated
    case distribution_type_arz
    case distribution_type_gorus
    case distribution_type_do_not_use
    
    case document_urgency_normal
    case document_urgency_ivedi
    case document_urgency_cok_ivedi
    case document_urgency_gunlu
    
    case transfer_source_depoartment
    case transfer_source_user
    case transfer_source_distribution
    
    case transfer_source_tap_here_to_add
    
    case transfer_source_alert_title
    case transfer_source_alert_message
    
    case transfer_source_error_no_targets_set
    
    case recently_used
    case search_result
    
    case department_type_select_placeholder
    case department_search_placeholder
    case department_search_error_department_empty
    case department_select_button_title
    case department_select_button_title_empty
    
    case remove_transfer_message
    
    case transfer_search_error_query_empty
    
    case user_select_button_title
    case user_select_button_title_empty
    case target_user
    
    case target_department_group
    case department_group_select_button_title
    case department_group_select_button_title_empty
    case department_group_error_you_must_select_at_least_one
    
    case transfer_alert_submit_message_enter_note
    case transfer_alert_submit_success
    
    case transfer_date_header_tap_to_set_date
    case transfer_date_action_title
    case transfer_date_action_remove_date
    case transfer_date_action_pick_new_date
    case transfer_date_header_selected_date
    case transfer_date_header_alert_remove_date
    case transfer_date_header_alert_select_date
    
    case main_user
    case delegate_user
    case give_delegate_tap_here_to_choose
    
    case give_delegation_dont_see_older_items
    case give_delegation_dont_see_older_received_items
    case give_delegation_asil_user_can_operate_read_only_mode
    case give_delegation_show_document_notes
    case give_delegation_dont_see_older_items_for_department
    case give_delegation_dont_see_older_received_items_for_department
    case give_delegation_is_active
    case give_delegation_enter_note_placeholder

    case give_delegation_save_error_must_select_main_user
    case give_delegation_save_error_must_select_delegate_user
    case give_delegation_save_error_must_select_date
    case give_delegation_save_success
    
    case document_action_archive_message

    case user_search_title
    
    case smart_card_status_searching
    case smart_card_status_activating
    case smart_card_status_getting_certificates
    case smart_card_select_a_certificate
    case smart_card_selected_certificate
    case e_sign_creating_package
    case e_sign_signing_document
    case e_sign_alert_register_device_message
    case e_sign_alert_register_device_button_scan_qr_code
    case e_sign_btn_title
    case sign_smart_card_success
    case sign_mobile_success
    case document_action_confirm_alert_message
    case sign_smart_card_error_generic
    
    case session_logout_title
    case session_logout_message
    
    case info
    case deactivate_delegate_success
    
    case give_back_empty_desc_error
    
    
    case alert_message_pick_sign_method
    case alert_message_sign_method_e_sign
    case alert_message_sign_method_mobile_sign
    case alert_message_e_sign_module_not_enabled
    case alert_mobile_sign_fingerPrint
    
    case alert_message_loading_notes
    
    case alert_error_service_selector_ios_not_enabled
    
    case batch_transfer
    case batch_sign
    case retry
    case batch_transfer_success
    case batch_sign_success
    case operation_failed
    case operation_failed_content
    
    case document_related
    case document_attachments
    
    case batch_operation_cancel_alert_title
    case batch_operation_cancel_alert_message
    
    case document_attachment_physical
    
    case date
    case subject
    case file_plan
    
    case batch_confirm
    case batch_confirm_success
    case batch_confirm_question
    
    
    case task_number
    case task_creator
    case task_responsive
    case task_status
    case task_created_at
    case task_end_at
    case task_document
    case task_notes
    case task_users
    case task_operations
    case task_detail_title
    case task_comment_placeholder
    
    case tap_to_select
    case tap_to_enter
    
    case task_status_waiting
    case task_status_finished
    case task_status_draft
    case apply_filter
    
    case task_operation_close
    case task_operatino_reopen
    case task_user_logic_select_action
    case please_wait
    case save
    
    case operation_cancelled
    
    case login_button_title_username
    case login_button_title_mobile
    case login_button_title_e_sign
    case share_document
    case operation_successful
    case transfer_template_add_duplicate_error
    
    case end_delegation
    case login_as_readonly
    
    case document_distribution_flow
    case distribution_flow_segment_flow
    case distribution_flow_segment_distribution
    
    case da_flow_state_normal
    case da_flow_state_waiting
    case da_flow_state_finished
    case da_flow_state_declined

    case da_flow_btn_copy
    case da_flow_please_select_distribution
    
    case da_flow_tap_here_to_add_flow
    case da_flow_tap_here_to_add_distribution
    case da_flow_tap_here_to_add_note
    case da_flow_add_distribution_title
    case da_flow_add_flow_title
    case da_flow_btn_approve_title
    case da_flow_btn_decline_title
    
    case use_last_distribution_automatically
    case show_connected_departments
    case dont_warn_on_success
    case automatically_add_added_department_to_flow
    case dont_show_distribution_note
    case da_action_approve_title
    case da_action_decline_title
    case da_action_input_placeholder
    case da_action_decline_empty_error
    case da_flow_error_approve_empty_distribution
    case apply
    case add_note
    case push_error_document_not_found
    case settings_push_title
    case settings_language_title
    case settings_biometric_title
    case settings_title
    case settings_version
    case alert_message_sign_e_sign_app
    case alert_e_sign_arksigner_success
    case alert_e_sign_arksigner_error
    
    case batch_ark_signer_peraparing
    case batch_ark_signer_complete
    case alert_e_sign_arksigner_app_not_founc
    case alert_e_sign_arksigner_download

    case alert_e_sign_disabled_message
    
    case sign_queue_status_waiting
    case sign_queue_status_processing
    case sign_queue_status_error_occured
    case sign_queue_status_completed
    case sign_queue_status_unknown
    
    case alert_message_sign_method_multi_mobile_sign
    case alert_message_multi_mobile_sim_warning
    case alert_action_multi_mobile_dont_show_again

    
    func localizedString()->String{
        let path = Bundle.main.path(forResource: LocalizedStrings.getCurrentLocale(), ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self.rawValue, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    func localizedString(params:[String])->String{
        let path = Bundle.main.path(forResource: LocalizedStrings.getCurrentLocale(), ofType: "lproj")
        let bundle = Bundle(path: path!)
        var string = NSLocalizedString(self.rawValue, tableName: nil, bundle: bundle!, value: "", comment: "")
        for i in 0..<params.count{
            string = string.replacingOccurrences(of: "::\(i+1)", with: params[i])
        }
        return string
    }
    
    static let supportedLanguages:[String] = ["tr","en"]
    
    static func getCurrentLocale()->String{
        if let lang =  UserDefaultsManager.selected_locale.getDefaultsValue() as? String{
            return lang
        }else{
            let currentLocale = Locale.current.languageCode ?? "en"
            return supportedLanguages.contains(currentLocale) ? currentLocale : "en"
        }
    }
    
    static func setCurrentLocale(locale:String){
        UserDefaultsManager.selected_locale.setDefaultValue(value: locale)
    }
    
    static func clearCurrentLocale(){
        UserDefaultsManager.selected_locale.clearValue()
    }
}
