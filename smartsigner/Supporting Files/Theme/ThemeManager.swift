//
//  ThemeManager.swift
//  smartsigner
//
//  Created by Serdar Coskun on 20.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
@objc class ThemeManager: NSObject {

    static func applyDefaultTheme(){
        UITabBar.appearance().tintColor = UIColor.primaryDarkColor
        UISegmentedControl.appearance().tintColor = UIColor.white
    }
    
    static func getDefaultSemanticColorScheme()->MDCSemanticColorScheme{
        let colorScheme = MDCSemanticColorScheme(defaults: .material201804)
        colorScheme.primaryColor = .primaryColor
        colorScheme.secondaryColor = .secondaryColor
        colorScheme.primaryColorVariant = .primaryDarkColor
        return colorScheme
    }
    
    @objc static func getDefaultAlertButtonSemanticColorScheme()->MDCSemanticColorScheme{
        let colorScheme = MDCSemanticColorScheme(defaults: .material201804)
        colorScheme.primaryColor = .primaryColor
        colorScheme.secondaryColor = .secondaryColor
        colorScheme.primaryColorVariant = .primaryDarkColor
        return colorScheme
    }

    static func getDefaultSemanticButtonColorScheme()->MDCSemanticColorScheme{
        let colorScheme = MDCSemanticColorScheme(defaults: .material201804)
        colorScheme.primaryColor = .secondaryColor
        colorScheme.secondaryColor = .secondaryDarkColor
        colorScheme.primaryColorVariant = .secondaryLightColor
        colorScheme.onSurfaceColor = .white
        return colorScheme
    }
    
    static func getDefaultSemanticErrorButtonColorScheme()->MDCSemanticColorScheme{
        let colorScheme = MDCSemanticColorScheme(defaults: .material201804)
        colorScheme.primaryColor = .red
        colorScheme.secondaryColor = .red
        colorScheme.primaryColorVariant = .red
        colorScheme.onSurfaceColor = .white
        return colorScheme
    }
    
    
    
    static func getSearchFieldColorScheme()->MDCSemanticColorScheme{
        let colorSheme = MDCSemanticColorScheme(defaults: .material201804)
        return colorSheme
    }
    
    static func applyTabbarColorTheme(tabbar:MDCTabBar){
        print("TABBAR COLOR SCHEME FIX NEEDED!");
        let container = MDCContainerScheme()
        container.colorScheme = getDefaultSemanticColorScheme()
        tabbar.applyPrimaryTheme(withScheme: container)
//        MDCTabBarColorThemer.applySemanticColorScheme(self.getDefaultSemanticColorScheme(), toTabs: tabbar)
    }
    
    static func applyAlertButtonTheme(button:MDCButton){
        let buttonScheme = MDCButtonScheme()
        buttonScheme.colorScheme = getDefaultSemanticButtonColorScheme()
        
        MDCTextButtonThemer.applyScheme(buttonScheme, to: button)
        
        MDCButtonColorThemer.applySemanticColorScheme(self.getDefaultAlertButtonSemanticColorScheme(), to: button)
    }
    
    @objc static func applyButtonColorTheme(button:MDCButton){
        MDCButtonColorThemer.applySemanticColorScheme(self.getDefaultSemanticButtonColorScheme(), to: button)
    }
    
    static func applyErrorButtonColorTheme(button:MDCButton){
        MDCButtonColorThemer.applySemanticColorScheme(self.getDefaultSemanticErrorButtonColorScheme(), to: button)
    }
    
    static func applyNavbarTheme(navBar:MDCNavigationBar){
        MDCNavigationBarColorThemer.applySemanticColorScheme(self.getDefaultSemanticColorScheme(), to: navBar)
    }
    
    static func applyAppBarTheme(appBar:MDCAppBarViewController){
        MDCAppBarColorThemer.applyColorScheme(self.getDefaultSemanticColorScheme(), to: appBar)
        appBar.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)]
    }
    
    static func applySearchTextfieldTheme(textFieldController:MDCTextInputControllerFilled){
        MDCFilledTextFieldColorThemer.applySemanticColorScheme(self.getSearchFieldColorScheme(), to: textFieldController)
    }
    
    
    static func applyCardTheme(card:MDCCard){
        let colorScheme = MDCSemanticColorScheme()
        colorScheme.surfaceColor = .serviceItemBackground
        print("CARD COLOR SCHEME FIX NEEDED!");
        let container = MDCContainerScheme()
        container.colorScheme = colorScheme
        card.applyTheme(withScheme: container)
//        MDCCardsColorThemer.applySemanticColorScheme(colorScheme, to: card)
    }
    
    static func applyTextFieldTheme(textField:MDCTextField){
//        let colorScheme = MDCSemanticColorScheme()
//        colorScheme.secondaryColor = .secondaryTextColor
//        colorScheme.primaryColor = .primaryTextColor
//        MDCTextFieldColorThemer.apply(colorScheme, to: textField)
    }
}

extension UITraitCollection{
    static func isLightTheme() -> Bool{
        /*
        if #available(iOS 12.0, *) {
            if #available(iOS 13.0, *) {
                return self.current.userInterfaceStyle == UIUserInterfaceStyle.light
            } else {
                return true
            }
        } else {
            return true
        }*/
        return true
    }
}

extension UIColor{
    
    static func getNamedColor(colorName:String, fallbackColor:UIColor) -> UIColor{
        if #available(iOS 11.0, *){
            return UIColor(named: colorName) ?? fallbackColor
        }else{
            return fallbackColor
        }
        
    }

    
    static let primaryColor = UIColor.getNamedColor(colorName: "primaryColor", fallbackColor: UIColor(red: 90.0/255.0, green: 108.0/255.0, blue: 206.0/255.0, alpha: 1.0));
    static let primaryLightColor = UIColor.getNamedColor(colorName: "primaryLightColor", fallbackColor: UIColor(red: 0.504, green: 0.572, blue: 0.958, alpha: 1.0))
    static let primaryDarkColor = UIColor.getNamedColor(colorName: "primaryDarkColor", fallbackColor: UIColor(red: 0.254, green: 0.322, blue: 0.708, alpha: 1.0))
    static let primaryTextColor = UIColor.getNamedColor(colorName: "primaryTextColor", fallbackColor: .black)
    static let secondaryColor = UIColor.getNamedColor(colorName: "secondaryColor", fallbackColor: UIColor(red: 0.15, green: 0.78, blue: 0.85, alpha: 1.0))
    static let secondaryLightColor = UIColor.getNamedColor(colorName: "secondaryLightColor", fallbackColor: UIColor(red: 0.44, green: 0.98, blue: 1.00, alpha: 1.0))
    static let secondaryDarkColor = UIColor.getNamedColor(colorName: "secondaryDarkColor", fallbackColor: UIColor(red: 0.00, green: 0.58, blue: 0.66, alpha: 1.0))
    static let secondaryTextColor = UIColor.getNamedColor(colorName: "secondaryTextColor", fallbackColor: UIColor(red: 0.88, green: 0.97, blue: 0.98, alpha: 1.0))

    static let tableviewBackground = UIColor.getNamedColor(colorName: "tableviewBackground", fallbackColor: UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0))
    
    static let serviceSelectorBackground = UIColor.getNamedColor(colorName: "serviceSelectorBackground", fallbackColor: .white)
    static let serviceItemBackground = UIColor.getNamedColor(colorName: "serviceItemBackground", fallbackColor: .white)
    
    static let sideMenuBackground = UIColor.getNamedColor(colorName: "sideMenuBackground", fallbackColor: .white)
}
