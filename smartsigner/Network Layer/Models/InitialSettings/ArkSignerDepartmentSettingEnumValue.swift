//
//    ArkSignerDepartmentSettingEnumValue.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ArkSignerDepartmentSettingEnumValue{

    var arkSignerAppLicense : String!
    var canUseAndroidArkSignerApp : Bool!
    var canUseIosArkSignerApp : Bool!
    var canUseIosSignCard : Bool!
    var canUseMobileSign : Bool!
    var type : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        arkSignerAppLicense = dictionary["ArkSignerAppLicense"] as? String
        canUseAndroidArkSignerApp = dictionary["CanUseAndroidArkSignerApp"] as? Bool
        canUseIosArkSignerApp = dictionary["CanUseIosArkSignerApp"] as? Bool
        canUseIosSignCard = dictionary["CanUseIosSignCard"] as? Bool
        canUseMobileSign = dictionary["CanUseMobileSign"] as? Bool
        type = dictionary["__type"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if arkSignerAppLicense != nil{
            dictionary["ArkSignerAppLicense"] = arkSignerAppLicense
        }
        if canUseAndroidArkSignerApp != nil{
            dictionary["CanUseAndroidArkSignerApp"] = canUseAndroidArkSignerApp
        }
        if canUseIosArkSignerApp != nil{
            dictionary["CanUseIosArkSignerApp"] = canUseIosArkSignerApp
        }
        if canUseIosSignCard != nil{
            dictionary["CanUseIosSignCard"] = canUseIosSignCard
        }
        if canUseMobileSign != nil{
            dictionary["CanUseMobileSign"] = canUseMobileSign
        }
        if type != nil{
            dictionary["__type"] = type
        }
        return dictionary
    }

}
