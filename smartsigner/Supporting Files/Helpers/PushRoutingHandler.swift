//
//  PushRoutingHandler.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 26.02.2020.
//  Copyright © 2020 Seneka. All rights reserved.
//

import UIKit

class PushRoutingHandler: NSObject {

    static func handlePushMessage(userInfo:[AnyHashable : Any]){
        let pushItem = FBPushMessageData(fromDictionary: userInfo as! [String : Any])
        guard let pushType = PushMessageType.init(rawValue: pushItem.type) else{
            print("Unknown Type: \(pushItem.type)")
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() +  .milliseconds(500)) {
            PushRoutingHandler.processIncomingMessage(pushData: pushItem)
        }
    }
    
    static func processIncomingMessage(pushData:FBPushMessageData){
        let isLoggedIn = SessionManager.current.loginData != nil
        if isLoggedIn{
            guard let setting = SessionManager.current.transferDepartmentSettings.first(where: {$0.departmentSettingNameEnum == DepartmentSettingTypeEnum.SettingCN_String.rawValue}), let value = setting.value as? String else {
                SessionManager.current.addPushMessageToQueue(pushMessage: pushData)
                return
            }
            let isRightTarget = SessionManager.current.loginData?.loggedUserId ?? 0 == pushData.userId
            print("Logged user Id: \(SessionManager.current.loginData?.loggedUserId ?? 0)")
            if isRightTarget {
                if value == pushData.cN && SessionManager.current.loginData?.loggedUserId == pushData.userId{
                    Observers.push_event_incoming_message.post(userInfo: [Observers.keys.push_data :pushData])
                }else{
                    SessionManager.current.addPushMessageToQueue(pushMessage: pushData)
                }
            }else{
                SessionManager.current.addPushMessageToQueue(pushMessage: pushData)
            }
        }else{
            SessionManager.current.addPushMessageToQueue(pushMessage: pushData)
        }
    }
}
