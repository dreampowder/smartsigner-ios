//
//  UserDefaultsManager.swift
//  smartsigner
//
//  Created by Serdar Coskun on 20.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit

enum UserDefaultsManager: String {

    case session_cookie
    case login_data
    case api_service
    case base_url
    case fast_login_data
    case last_selected_company
    case file_cache_dictionary
    case last_login_username
    case selected_locale
    case push_block_list
    case should_skip_multi_sign_push_warning
    
    func getDefaultsValue()->Any?{
        let defaults = UserDefaults.standard
        return defaults.object(forKey: self.rawValue)
    }
    
    func setDefaultValue(value:Any){
        let defaults = UserDefaults.standard
        if let dict = value as? [String:Any]{ //Check if there is a null value
            var newDict:[String:Any]  = [:]
            for key in dict.keys{
                if dict[key] is NSNull{
                    //newDict[key] = "" //dont save the value
                }else{
                    newDict[key] = dict[key]
                }
            }
            defaults.set(newDict, forKey: self.rawValue)
        }else{
            defaults.set(value, forKey: self.rawValue)
        }
        
        defaults.synchronize()
    }
    
    func clearValue(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: self.rawValue)
        defaults.synchronize()
    }
    
}
