//
//  SessionManager.swift
//  smartsigner
//
//  Created by Serdar Coskun on 23.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit

class SessionManager: NSObject {

    var loginData:LoginResponse?
    var loginPassword:String?
    var loginTCKN:String?
    var serviceData:ServiceData?
    var cookie:String?
    var loginType:LoginType?
    var delegateConfig:DelegateConfigurationResponse?
    var rawpw:Data?
    var transferDepartmentSettings:[DepartmentSetting] = []
    
    var taskNoteAssignmentTypes:[TaskNoteAssignmentType] = []
    
    @objc static let current = SessionManager()
    @objc var lastUsedPin:String?
    
    var folderRefreshTimer:Timer?
    
    var pushMessageQueue:[String:FBPushMessageData] = [:]
    
    var arkSignerSetId:String?
    
    func canLoginWithESign(signType:ESignType) -> Bool{
        guard let arkSignerSettingDict = transferDepartmentSettings.first(where: {$0.departmentSettingNameEnum == DepartmentSettingTypeEnum.ARK_LicenseSettings_String.rawValue})?.value as? [String:Any] else{
            switch signType {
                case .ark_signer_app,.ark_signer_card:
                    return serviceData?.isArkEnabled ?? false
                case .mobile_sign:
                    return serviceData?.canUseMobileSign ?? false
            }
        }
        let setting = ArkSignerDepartmentSettingEnumValue(fromDictionary: arkSignerSettingDict)
        switch signType {
        case .ark_signer_app:
            return setting.canUseIosArkSignerApp
        case .ark_signer_card:
            return setting.canUseIosSignCard
        case .mobile_sign:
            return setting.canUseMobileSign
        }
    }
    
    func canUseESign(signType:ESignType) -> Bool{
        guard let arkSignerSettingDict = transferDepartmentSettings.first(where: {$0.departmentSettingNameEnum == DepartmentSettingTypeEnum.ARK_LicenseSettings_String.rawValue})?.value as? [String:Any] else{
            switch signType {
                case .ark_signer_app,.ark_signer_card:
                    return serviceData?.isArkEnabled ?? false
                case .mobile_sign:
                    return serviceData?.canUseMobileSign ?? false
            }
        }
        let setting = ArkSignerDepartmentSettingEnumValue(fromDictionary: arkSignerSettingDict)
        switch signType {
        case .ark_signer_app:
            return setting.canUseIosArkSignerApp && loginData?.canUseArkSignerApp ?? false
        case .ark_signer_card:
            return setting.canUseIosSignCard && loginData?.canUseIosSignCard ?? false
        case .mobile_sign:
            return setting.canUseMobileSign
        }
    }
    
    func canUseArkSignerApp()->Bool{
        return true
    }
    
    func addPushMessageToQueue(pushMessage:FBPushMessageData){
        pushMessageQueue["\(pushMessage.cN ?? "<null>")-\(pushMessage.userId ?? 0)"] = pushMessage
    }
    
    func getAfterLoginPushMessage()->FBPushMessageData?{
        let cn = SessionManager.current.transferDepartmentSettings.first(where: {$0.departmentSettingNameEnum == DepartmentSettingTypeEnum.SettingCN_String.rawValue})?.value as? String ?? "<none>"
        let key = "\(cn)-\(loginData?.loggedUserId ?? 0)"
        if let msg = pushMessageQueue[key]{
            pushMessageQueue.removeValue(forKey: key)
            return msg
        }else{
            return nil
        }
    }
    
    func getUserSetting(settingType:UserSettingNameEnum) -> UserSettingItem?{
        return self.loginData?.userSettings.first(where: {settingType.rawValue == $0.userSettingNameEnum})
    }
    
    func setUserSetting(settingType:UserSettingNameEnum, value:Any){
        if let index = self.loginData?.userSettings.firstIndex(where: {settingType.rawValue == $0.userSettingNameEnum}){
            self.loginData?.userSettings?[index].value = value
        }else{
            var setting = UserSettingItem(fromDictionary: [:])
            setting.userSettingNameEnum = settingType.rawValue
            setting.value = value
            self.loginData?.userSettings.append(setting)
        }
    }

    
    func getFolderRefreshDuration()->Double{
        guard let timeSetting = getUserSetting(settingType: .FolderRefreshRangeInSeconds_Nullable_Double),
            let durationInSeconds:Int = timeSetting.value as? Int
        else{
            return 120.0
        }
        
        return Double(durationInSeconds)
    }
    
    func startRefreshTimer(){
        if folderRefreshTimer != nil{
            folderRefreshTimer?.invalidate()
            folderRefreshTimer = nil
        }
        folderRefreshTimer = Timer.scheduledTimer(withTimeInterval: getFolderRefreshDuration(), repeats: true, block: { (_) in
            print("Refresh Folders")
            self.refreshFolders()
        })
    }
    
    func refreshFolders(){
        guard self.loginData != nil else{print("user not logged in"); return}
        ApiClient.get_folders
            .execute(responseBlock: { (_ response:FolderListResponse?, error, statusCode) in
                if response != nil && response?.errorContent() == nil && response?.folders != nil{
                    self.setFolders(folders: response?.folders)
                }
            })
    }
    
    @objc func clearLastUsedPin(){
        lastUsedPin = nil
    }
    
    func setFolders(folders:[Folder]?){
        if let f = folders{
            self.loginData?.folders = f
            Observers.reload_side_menu_folders.post(userInfo: [Observers.keys.folder_list:f])
        }
    }
    
    func logout(){
        self.loginData = nil
        self.loginPassword = nil
        self.serviceData = nil
        self.cookie = nil
        self.loginType = nil
        self.delegateConfig = nil
        self.lastUsedPin = nil
        self.folderRefreshTimer?.invalidate()
        self.folderRefreshTimer = nil
        self.taskNoteAssignmentTypes = []
        self.transferDepartmentSettings = []
        self.loginTCKN = nil
    }
    
    func getBaseRequest()->BaseRequest{
        var baseRequest = BaseRequest(fromDictionary: [:])
        baseRequest.clientIPAddress = IPAddressHelper.getIPAddress()
        baseRequest.clientTypeName = "EbysIOSClient"
        
        var delegationIds:[Int] = []
        for delegation:Delegation in loginData?.delegations ?? []{
            delegationIds.append(delegation.id)
        }
        baseRequest.delegationIds = delegationIds
        
        var rightTransterIds:[Int] = []
        for rightTranster:RightTransferId in loginData?.rightTransfers ?? []{
            rightTransterIds.append(rightTranster.id)
        }
        baseRequest.rightTransferIds = rightTransterIds;
        baseRequest.sessionId = loginData?.sessionId ?? 0
        baseRequest.userName = loginData?.loggedUserName ?? ""
        baseRequest.userSurname = loginData?.loggedUserSurname ?? ""
        baseRequest.userId = loginData?.loggedUserId
        baseRequest.departmentsWhichUserIsManagerOfIds = loginData?.departmentsWhichUserIsManagerOfIds
        baseRequest.departmentsWhichUsersDelegationsIsManagerOfIds = loginData?.departmentsWhichUsersDelegationsIsManagerOfIds
        baseRequest.inheritedDepartmentRightIds = loginData?.inheritedDepartmentRightIds
        baseRequest.nonce = loginData?.nonce
        baseRequest.delegations = loginData?.delegations
        baseRequest.rightTransfers = loginData?.rightTransfers
        baseRequest.languageEnum = LocalizedStrings.getCurrentLocale().elementsEqual("tr") ? 2 : 1
        baseRequest.ntUserName = loginData?.ntUserName ?? ""
        
        return baseRequest
    }
    
    enum LoginType{
        case username
        case mobile_sign
        case e_sign_app
    }
}

enum ESignType{
    case ark_signer_app
    case ark_signer_card
    case mobile_sign
}
