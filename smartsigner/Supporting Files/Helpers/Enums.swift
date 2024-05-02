enum RightTransferTypeEnum : Int
{
    case normal = 1
    case readOnlyForIncomingFolder = 2
    case canSeeSecretDocuments = 4
    case canSeeTopSecretDocuments = 8
    case canSeeOutgoingFolder = 16
    case readOnlyForOutgoingFolder = 32
}

enum DelegationTypeEnum : Int
{
    case normal = 1
    case dontSeeOlderSentItems = 2
    case parentOfVirtualDelegations = 4
    case dontSeeOlderReceivedItems = 8
    case asilUserCanOperateInReadOnlyMode = 16
    case showDocumentNotes = 32
}

enum AttachmentTypeEnum : Int
{
    case digitalFile = 0
    case otherDocument = 1
    case physicalAttachment = 2
    case physicalDocument = 3
    case attachmentNote01 = 4
}

enum RelatedDocumentTypeEnum : Int
{
    case otherDocument = 0
    case physicalDocument = 1
    case attachment = 2
}

public enum DocumentDataTypeEnum : Int
{
    case docxCreatedInSystem = 0
    case importedPdf = 1
    case rtf = 2
    case importedFile = 3
    case xaml = 4
    case eyp = 5
    case pdf = 6
    case xlsx = 7
    case pdfWithHavingNumberOnIt = 8
    case pdfWithHavingNumberOnItAsLayer = 9
    case docxOld = 10
    case xamlOld = 11
    case ckysPdf = 12
    case pdfWithCombinedSignatureOld = 13
    case pdfOld = 14
    case informationAcquistionPdf = 15
    case ckysNoContentnPdf = 16
    case cancelledForDeclinedPdfWithHavingNumberOnItAsLayer = 17
    case cancelledForDeclinedEyp = 18
    case html = 19
    case pdfCreatedInWeb = 20
}

enum DepoartmentTypeEnum:Int{
    case depoartment_type_empty = 0
    case depoartment_type_merkez_birim = 1
    case depoartment_type_bagli_kurulus = 2
    case depoartment_type_tasra_birimi = 4
    case depoartment_type_diger_kamu_kurum = 16384
    case depoartment_type_sirket = 32768
    case depoartment_type_sahis = 65536

    static var allItems:[DepoartmentTypeEnum] = [
        .depoartment_type_empty,
        .depoartment_type_merkez_birim,
        .depoartment_type_bagli_kurulus,
        .depoartment_type_tasra_birimi,
        .depoartment_type_diger_kamu_kurum,
        .depoartment_type_sirket,
        .depoartment_type_sahis
    ]
    
    func stringValue()->LocalizedStrings{
        return [
            .depoartment_type_empty : .depoartment_type_empty,
            .depoartment_type_merkez_birim : .depoartment_type_merkez_birim,
            .depoartment_type_bagli_kurulus : .depoartment_type_bagli_kurulus,
            .depoartment_type_tasra_birimi : .depoartment_type_tasra_birimi,
            .depoartment_type_diger_kamu_kurum : .depoartment_type_diger_kamu_kurum,
            .depoartment_type_sirket : .depoartment_type_sirket,
            .depoartment_type_sahis : .depoartment_type_sahis
        ][self]!
    }
}

enum DocumentDistrubutionTypeEnum:Int{
    case distribution_type_do_not_use = -1
    case distribution_type_geregi = 0
    case distribution_type_information = 1
    case distribution_type_coordinated = 2
    case distribution_type_gorus = 3
    case distribution_type_arz = 4

    static var allItems:[DocumentDistrubutionTypeEnum] = [
        .distribution_type_geregi,
        .distribution_type_information,
        .distribution_type_coordinated,
        .distribution_type_do_not_use,
        .distribution_type_arz,
        .distribution_type_gorus
    ]
    
    func stringValue()->LocalizedStrings{
        return [
            .distribution_type_geregi : .distribution_type_geregi,
            .distribution_type_information : .distribution_type_information,
            .distribution_type_coordinated : .distribution_type_coordinated,
            .distribution_type_do_not_use : .distribution_type_do_not_use,
            .distribution_type_arz : .distribution_type_arz,
            .distribution_type_gorus : .distribution_type_gorus
            ][self]!
    }
    
    static func getDepartmentsFromBitFlag(value:Int) -> [DocumentDistrubutionTypeEnum]{
        var masks = [Int]()
        var mask = 1
        var n = value
        while n > 0 {
            if n & mask > 0 {
                masks.append(mask)
                n -= mask
            }
            mask <<= 1
        }
        var list:[DocumentDistrubutionTypeEnum] = [.distribution_type_geregi,.distribution_type_information]
        if masks.contains(1) {
            list.append(.distribution_type_coordinated)
        }
        if masks.contains(2) {
            list.append(.distribution_type_gorus)
        }
        if masks.contains(4) {
            list.append(.distribution_type_arz)
        }
        return list
    }
}

enum DocumentUrgencyEnum:Int{
    case document_urgency_normal = 0
    case document_urgency_ivedi = 1
    case document_urgency_cok_ivedi = 2
    case document_urgency_gunlu = 3
    
    func stringValue()->LocalizedStrings{
        return [
            .document_urgency_normal : .document_urgency_normal,
            .document_urgency_ivedi : .document_urgency_ivedi,
            .document_urgency_cok_ivedi : .document_urgency_cok_ivedi,
            .document_urgency_gunlu : .document_urgency_gunlu
            ][self]!
    }
}

enum DocumentTransferSource{
    case transfer_source_depoartment
    case transfer_source_user
    case transfer_source_distribution
}

public enum FunctionNameEnum : Int
{
    case viewAllDocuments = 50
    case searchAllDocuments = 84
    case systemAdmin = 1000
}

enum GiveDelegationType:String{
    case give_delegation_is_active = "IsActive"
    case give_delegation_dont_see_older_items = "ChkDontSeeOlderSentItems"
    case give_delegation_dont_see_older_received_items = "ChkDontSeeOlderReceivedItems"
    case give_delegation_asil_user_can_operate_read_only_mode = "ChkAsilUserCanOperateInReadOnlyMode"
    case give_delegation_show_document_notes = "ChkShowDocumentNotes"
    case give_delegation_dont_see_older_items_for_department = "ChkDontSeeOlderSentItemsForDepartment"
    case give_delegation_dont_see_older_received_items_for_department = "ChkDontSeeOlderReceivedItemsForDepartment"
    
    func getLocalisedString() -> String{
        switch self {
        case .give_delegation_dont_see_older_items:
            return LocalizedStrings.give_delegation_dont_see_older_items.localizedString()
        case .give_delegation_dont_see_older_received_items:
            return LocalizedStrings.give_delegation_dont_see_older_received_items.localizedString()
        case .give_delegation_asil_user_can_operate_read_only_mode:
            return LocalizedStrings.give_delegation_asil_user_can_operate_read_only_mode.localizedString()
        case .give_delegation_show_document_notes:
            return LocalizedStrings.give_delegation_show_document_notes.localizedString()
        case .give_delegation_dont_see_older_items_for_department:
            return LocalizedStrings.give_delegation_dont_see_older_items_for_department.localizedString()
        case .give_delegation_dont_see_older_received_items_for_department:
            return LocalizedStrings.give_delegation_dont_see_older_received_items_for_department.localizedString()
        case .give_delegation_is_active:
            return LocalizedStrings.give_delegation_is_active.localizedString()
        }
    }
    
    func getIntValue()->Int{
        switch self {
        case .give_delegation_dont_see_older_items:
            return 2
        case .give_delegation_dont_see_older_received_items:
            return 8
        case .give_delegation_asil_user_can_operate_read_only_mode:
            return 16
        case .give_delegation_show_document_notes:
            return 32
        case .give_delegation_dont_see_older_items_for_department:
            return 64
        case .give_delegation_dont_see_older_received_items_for_department:
            return 128
        default:
            return 0
        }
    }
}

enum WorkFlowActionType:String{
    case workflow_action_type_sign_package = "Paket İmzala"
    case workflow_action_type_add_note = "Not Ekle"
}

enum UserSettingNameEnum:Int{
    case MobileTel_String = 1
    case SelectUserControlLastUsedTabItemName_String = 15
    case SelectDepartmentControlLastUsedTabItemName_String = 16
    case SelectDepartmentControlLastUsedDepartmentTypeEnum_Nullable_DepartmentTypeEnum = 17
    case FolderRefreshRangeInSeconds_Nullable_Double = 23
    case RecentDepartmentIds2ForForwarding_List_RecentDepartment = 37
    case DontShowMessageOnSuccessForDistributionApprovalControl_Nullable_Bool = 40
    case UseLastDistributionForDistributionApprovalControl_Nullable_Bool = 41
    case AddAdministrativeDepartmentForDistributionApprovalControl_Nullable_Bool = 42
    case MyDepartmentAndUserList_List_MyDepartmentAndUserList = 49
    case TransferDepartmentSchemes_String_Array = 9
    case DontShowNoteForDistributionApprovalControl_Nullable_Bool = 44
}

enum DepartmentSettingTypeEnum:Int{
    case SettingCN_String = 545
    case SettingCutomerNameLong_String = 546
    case SettingApplicationName_String = 547
    case SettingApplicationNameLong_String = 550
    case CooredineDistForwardType_Nullable_Int = 115
    case ForwardMode_Nullable_Int = 152
    case BatchForwardMode_Nullable_Int = 165
    case UseDomainPasswordForAuthenctication_Nullable_Bool = 60
    case UseDomainUsernameInsteadOfUsernameForUsernamePasswordAuthentication_Nullable_Bool = 139
    
    case OnlyForServiceDocumentMode_Nullable_Int = 636
    case DocumentRightModeWhileForwarding_Nullable_Int = 127
    case ARK_LicenseSettings_String = 640
}

/* Operation Type İşlemleri
"Tarih Güncelleme": Due Date Verilecek
"Not Güncelleme": Note text verilecek
"Yorum Ekleme": Message Text Eklenecek
"Bitirme": Tasknote Id, Delegation UserIDS
"Tekrar Açma": "Task Note ID verilecek"
*/
enum TaskNoteOperationType:String{
    case update_date = "Tarih Güncelleme"
    case update_note = "Not Güncelleme"
    case add_comment = "Yorum Ekleme"
    case finish_task = "Bitirme"
    case reopen_task = "Tekrar Açma"
}

enum TaskFilterFieldType:String{
    case none
    case creator
    case responsive
    case number
    case barcode_or_documentNr
    case status
    case created_at
    case due_date
    case quick_search
}

enum TaskStatusType:String{
    case waiting = "Beklemede"
    case finished = "Bitirildi"
    case draft = "Taslak"
    
    func getTile()->LocalizedStrings{
        switch self {
        case .waiting:
            return LocalizedStrings.task_status_waiting
        case .finished:
            return LocalizedStrings.task_status_finished
        case .draft:
            return LocalizedStrings.task_status_draft
        }
    }
}

enum DocumentOperationType:Int{
    case share_in_mobile_app = 43
    case screen_capture = 44
}


enum DaFlowStateEnum:Int{
    case normal = 0
    case waiting = 1
    case finished = 2
    case declined = 3
    
    func getTitle()->LocalizedStrings{
        switch self {
        case .normal:
            return LocalizedStrings.da_flow_state_normal
        case .waiting:
            return LocalizedStrings.da_flow_state_waiting
        case .finished:
            return LocalizedStrings.da_flow_state_finished
        case .declined:
            return LocalizedStrings.da_flow_state_declined
        @unknown default:
            return LocalizedStrings.error
        }
    }
    
    func getIcon()->FontAwesomeType{
        switch self {
        case .normal:
            return FontAwesomeType.arrowRight
        case .waiting:
            return FontAwesomeType.clockO
        case .finished:
            return FontAwesomeType.check
        case .declined:
            return FontAwesomeType.close
        @unknown default:
            return FontAwesomeType.question
        }
    }
}

enum FlowSideMenuItemType{
    case use_last_distribution_automatically
    case show_connected_departments
    case dont_warn_on_success
    case automatically_add_added_department_to_flow
    case dont_show_distribution_note
    
    func getString() -> LocalizedStrings{
        switch self {
        case .use_last_distribution_automatically:
            return .use_last_distribution_automatically
        case .show_connected_departments:
            return .show_connected_departments
        case .dont_warn_on_success:
            return .dont_warn_on_success
        case .automatically_add_added_department_to_flow:
            return .automatically_add_added_department_to_flow
        case .dont_show_distribution_note:
            return .dont_show_distribution_note
        }
    }
    
    func getSettingEnum()->UserSettingNameEnum?{
        switch self {
        case .use_last_distribution_automatically:
            return .UseLastDistributionForDistributionApprovalControl_Nullable_Bool
        case .show_connected_departments:
            return nil
        case .dont_warn_on_success:
            return .DontShowMessageOnSuccessForDistributionApprovalControl_Nullable_Bool
        case .automatically_add_added_department_to_flow:
            return .AddAdministrativeDepartmentForDistributionApprovalControl_Nullable_Bool
        case .dont_show_distribution_note:
            return .DontShowNoteForDistributionApprovalControl_Nullable_Bool
        }
    }
    
    static func getAllItems()->[FlowSideMenuItemType]{
        return [
        .use_last_distribution_automatically,
        .show_connected_departments,
        .dont_warn_on_success,
        .automatically_add_added_department_to_flow,
        .dont_show_distribution_note
        ]
    }
}

enum PushMessageType:String{
    case incoming_document = "IncomingDocument"
    case task_note = "TaskNote"
}


enum DigitalSignQueueStatusEnum:Int{
    case unknown = 0
    case waiting = 1
    case processing = 2
    case completed = 3
    case error_occured = 4
    
    func getMessage()->String{
        switch self {
        case .unknown:
            return LocalizedStrings.sign_queue_status_unknown.localizedString()
        case .waiting:
            return LocalizedStrings.sign_queue_status_waiting.localizedString()
        case .processing:
            return LocalizedStrings.sign_queue_status_processing.localizedString()
        case .completed:
            return LocalizedStrings.sign_queue_status_completed.localizedString()
        case .error_occured:
            return LocalizedStrings.sign_queue_status_error_occured.localizedString()
        }
    }
}
