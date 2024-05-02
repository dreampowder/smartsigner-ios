//
//  SmartCardController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 11.12.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit

class SmartCardController: NSObject {
    
    static let key_smart_card_list = "Smart Card List"
    
    static func removeAll(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key_smart_card_list)
        defaults.synchronize()
    }
    
    static func saveDeviceList(deviceList:ESignSmartCardList){
        let defaults = UserDefaults.standard
        defaults.set(deviceList.dictionaryRepresantation(), forKey: key_smart_card_list)
        defaults.synchronize()
    }
    
    @objc static func getDeviceList()->ESignSmartCardList?{
        guard let dict = UserDefaults.standard.object(forKey: key_smart_card_list) as? [String:Any] else{
            return nil
        }
        return ESignSmartCardList(fromDictionary: dict)
    }
    
    @objc static func addDevice(deviceId:String, qrCode:String){
        if let deviceList = self.getDeviceList(){
            if let index = deviceList.smartCardDevices.firstIndex(where: { (sd) -> Bool in
                return sd.deviceId == deviceId
            }){
                deviceList.smartCardDevices[index].qrCode = qrCode
            }else{
                let device = SmartCardDevice(fromDictionary: [:])
                device.deviceId = deviceId
                device.qrCode = qrCode
                deviceList.smartCardDevices.append(device)
            }
            self.saveDeviceList(deviceList: deviceList)
        }else{
            let deviceList = ESignSmartCardList(fromDictionary: [:])
            let device = SmartCardDevice(fromDictionary: [:])
            device.deviceId = deviceId
            device.qrCode = qrCode
            deviceList.smartCardDevices = [device]
            self.saveDeviceList(deviceList: deviceList)
        }
    }
    
    @objc static func removeDevice(deviceId:String){
        guard let deviceList = self.getDeviceList() else{
            return
        }
        if let index = deviceList.smartCardDevices.firstIndex(where: { (sd) -> Bool in
            return sd.deviceId == deviceId
        }){
            deviceList.smartCardDevices.remove(at: index);
        }
        self.saveDeviceList(deviceList: deviceList)
    }
    
    @objc static func getDevice(deviceId:String) -> SmartCardDevice?{
        guard let deviceList = self.getDeviceList(),
            let device = deviceList.smartCardDevices.first(where: { (sd) -> Bool in
                return sd.deviceId == deviceId
            }) else{
                return nil
        }
        return device
    }
    
}
