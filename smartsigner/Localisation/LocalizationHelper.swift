//
//  LocalizationHelper.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 10.04.2020.
//  Copyright © 2020 Seneka. All rights reserved.
//

import UIKit

@objc class LocalizationHelper:NSObject{
    @objc static func getLocalizedString(key:String,comment:String) -> String{
        let path = Bundle.main.path(forResource: LocalizedStrings.getCurrentLocale(), ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(key, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

