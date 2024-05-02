//
//  GiveDelegateDelegateTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 28.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class GiveDelegateDelegateTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMainVal:UILabel?
    @IBOutlet weak var lblMainTitle:UILabel?
    
    @IBOutlet weak var lblSubVal:UILabel?
    @IBOutlet weak var lblSubTitle:UILabel?
    @IBOutlet weak var cardContainer:MDCCard!
    
    var delegateModel:GiveDelegateModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblMainTitle?.text = "\(LocalizedStrings.main_user.localizedString())"
        self.lblSubTitle?.text = "\(LocalizedStrings.delegate_user.localizedString())"
        self.setTextValue(value: LocalizedStrings.give_delegate_tap_here_to_choose.localizedString(), isMain: true,isPlaceHolder: true)
        self.setTextValue(value: LocalizedStrings.give_delegate_tap_here_to_choose.localizedString(), isMain: false,isPlaceHolder: true)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(didTapDelegateLabel(tapGesture:)))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(didTapDelegateLabel(tapGesture:)))
        
        if (SessionManager.current.delegateConfig?.userHasAllUsersToUpdate ?? false){
            self.lblMainVal?.isUserInteractionEnabled = true
            self.lblMainVal?.addGestureRecognizer(tapGesture1)
        }
        
        
        self.lblSubVal?.isUserInteractionEnabled = true
        self.lblSubVal?.addGestureRecognizer(tapGesture2)
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        ThemeManager.applyCardTheme(card: cardContainer)
        lblMainTitle?.textColor = .secondaryTextColor
        lblSubTitle?.textColor = .secondaryTextColor
        lblMainVal?.textColor = .primaryTextColor
        lblSubVal?.textColor = .primaryTextColor
    }
    
    func setTextValue(value:String, isMain:Bool,isPlaceHolder:Bool){
        var attrText = NSMutableAttributedString(string: "\(value)\n\n", attributes:
            [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.patternDash.union(.single).rawValue,
             NSAttributedString.Key.underlineColor : UIColor.primaryTextColor])
        
        if isPlaceHolder{
            let plusIcon = NSAttributedString(string: String.fa.fontAwesome(.plusCircle), attributes: [NSAttributedString.Key.font : UIFont.fa?.fontSize(20),NSAttributedString.Key.foregroundColor:UIColor.primaryTextColor])
            attrText.append(plusIcon)
        }

        if isMain{
            self.lblMainVal?.attributedText = attrText
        }else{
            self.lblSubVal?.attributedText = attrText
        }
    }
    
    func load(model:GiveDelegateModel?){
        self.delegateModel = model
        guard let setup = model else{
            self.setTextValue(value: LocalizedStrings.give_delegate_tap_here_to_choose.localizedString(), isMain: true,isPlaceHolder: true)
            self.setTextValue(value: LocalizedStrings.give_delegate_tap_here_to_choose.localizedString(), isMain: false,isPlaceHolder: true)
            return
        }
        if let mainUser = setup.mainUser{
            setTextValue(value: "\(mainUser.name ?? "") \(mainUser.surname ?? "")\n\(mainUser.departmentName ?? "")", isMain: true,isPlaceHolder: false)
        }else{
            self.setTextValue(value: LocalizedStrings.give_delegate_tap_here_to_choose.localizedString(), isMain: true,isPlaceHolder: true)
        }
        
        if let delegateUser = setup.delegateUser{
            setTextValue(value: "\(delegateUser.name ?? "") \(delegateUser.surname ?? "")\n\(delegateUser.departmentName ?? "")", isMain: false,isPlaceHolder: false)
        }else{
            self.setTextValue(value: LocalizedStrings.give_delegate_tap_here_to_choose.localizedString(), isMain: false,isPlaceHolder: true)
        }
    }
    
    @objc func didTapDelegateLabel(tapGesture:UITapGestureRecognizer){
        
        print("label tap")
        
        guard let model = self.delegateModel else{
            return
        }
        Observers.give_delegate_setup_delegate.post(userInfo: [Observers.keys.delegate_model : model,Observers.keys.is_delegate_user:(tapGesture.view?.isEqual(self.lblSubVal)) ?? true])
    }
}
