//
//  UserSetting.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 12.11.2019.
//  Copyright © 2019 Seneka. All rights reserved.
//

import UIKit

struct UserSettingItem {
    
    var userSettingNameEnum : Int!
    var value : Any!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        userSettingNameEnum = dictionary["UserSettingNameEnum"] as? Int
        value = dictionary["Value"] 
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if userSettingNameEnum != nil{
            dictionary["UserSettingNameEnum"] = userSettingNameEnum
        }
        if value != nil{
            dictionary["Value"] = value
        }
        return dictionary
    }

}


