//
//  ActionMenuViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 5.10.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit

class ActionMenuViewController: UIViewController {

    @IBOutlet weak var viewContainer:MDCShadowView?
    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var containerTopConstraint:NSLayoutConstraint?
    @IBOutlet weak var containerHeightConstraint:NSLayoutConstraint?
    
    
    var didLayoutSubviews = false
    
    var documentContent:DocumentContent?
    var menuItems:[MenuItem] = []
    
    var parentVCNavbarHeight:CGFloat = 56;
    convenience init() {
        self.init(nibName: "ActionMenuViewController", bundle: .main)
    }
    
    convenience init(documentContent:DocumentContent, containerNavbarHeight:CGFloat) {
        self.init()
        self.documentContent = documentContent;
        self.parentVCNavbarHeight = containerNavbarHeight
        self.populateMenu()
        
    }
    
    override func viewDidLayoutSubviews() {
        if !didLayoutSubviews{
            didLayoutSubviews = true
            self.containerTopConstraint?.constant = -1 * (containerHeightConstraint?.constant)!
            self.containerHeightConstraint?.constant = CGFloat(menuItems.count * 44)
            let maskview = UIView(frame: CGRect(x: 0, y: self.parentVCNavbarHeight, width: self.view.bounds.width, height: self.view.bounds.height - self.parentVCNavbarHeight))
            maskview.backgroundColor = .red
            self.view?.mask = maskview
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animatePresentation(isDismissing: false) {
            
        };
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOutside(gesture:)))
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        self.tableView?.register(UINib(nibName: "ActionMenuTableViewCell", bundle: .main), forCellReuseIdentifier: "Cell")
        
    }
    
    @objc func didTapOutside(gesture:UITapGestureRecognizer){
        self.animatePresentation(isDismissing: true) {
            
        }
    }
    
    func populateMenu(){
        guard let document = self.documentContent else{
            return
        }
        
        if document.btnDocumentSignVisibility ?? false{
            if self.documentContent?.useDigitalSignatureForSigns == true || self.documentContent?.useDigitalSignatureForSigns == nil{
                menuItems.append(ActionMenuViewController.MenuItem(fontAwesome: FontAwesomeType.pencil, title: .sign, itemType: .sign))
                if SessionManager.current.loginType == SessionManager.LoginType.mobile_sign{
                    menuItems.append(ActionMenuViewController.MenuItem(fontAwesome: FontAwesomeType.pencil, title: .sign_mobile, itemType: .sign_mobile))
                }
            }else{
                menuItems.append(ActionMenuViewController.MenuItem(fontAwesome: FontAwesomeType.pencil, title: .confirm, itemType: .confirm))
            }
            
        }
        
        if document.btnDocumentDeclineVisibility ?? false{
            menuItems.append(ActionMenuViewController.MenuItem(fontAwesome: FontAwesomeType.minusCircle, title: .reject, itemType: .reject))
        }
        
        if document.btnDocumentParaphVisibility ?? false{
            menuItems.append(ActionMenuViewController.MenuItem(fontAwesome: FontAwesomeType.pencilSquare, title: .initials, itemType: .initials))
        }
        
        if document.btnDocumentForwardVisibility ?? false{
            menuItems.append(ActionMenuViewController.MenuItem(fontAwesome: FontAwesomeType.forward, title: .transfer, itemType: .transfer))
        }
        
//        if document.pool.hasNote {
            menuItems.append(ActionMenuViewController.MenuItem(fontAwesome: FontAwesomeType.stickyNote, title: .notes, itemType: .notes))
//        }
        
        if document.btnDocumentWorkflowVisibility ?? false{
            menuItems.append(ActionMenuViewController.MenuItem(fontAwesome: FontAwesomeType.tasks, title: .workflow, itemType: .workflow))
        }
        
        if document.btnDocumentSendToArchiveVisibility ?? false{
            menuItems.append(ActionMenuViewController.MenuItem(fontAwesome: FontAwesomeType.archive, title: .archive, itemType: .archive))
        }
        
        if document.btnDocumentPullBackVisibility ?? false{
            menuItems.append(ActionMenuViewController.MenuItem(fontAwesome: FontAwesomeType.backward, title: .take_back, itemType: .take_back))
        }
        
        if document.btnDocumentSendBackVisibility ?? false{
            menuItems.append(ActionMenuViewController.MenuItem(fontAwesome: FontAwesomeType.exchange, title: .give_back, itemType: .give_back))
        }
        
        if document.btnDocumentDistributionApprovalVisibility ?? false{
            menuItems.append(ActionMenuViewController.MenuItem(fontAwesome: .arrowsAlt, title: .document_distribution_flow, itemType: .distribution_flow))
        }
        
        menuItems.append(ActionMenuViewController.MenuItem(fontAwesome: FontAwesomeType.archive, title: .versions, itemType: .versions))
        
        menuItems.append(ActionMenuViewController.MenuItem(fontAwesome: FontAwesomeType.history, title: .history, itemType: .history))
        
        if document.btnDocumentExportVisibility ?? false{
            menuItems.append(ActionMenuViewController.MenuItem(fontAwesome: .shareAlt, title: .share_document, itemType: .share))
        }
        
    }

    
    func animatePresentation(isDismissing:Bool, completion:@escaping()->()){
        if !isDismissing {
            UIView.animate(withDuration: 0.25, animations: {
//                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                self.containerTopConstraint?.constant = self.parentVCNavbarHeight
                self.view.layoutIfNeeded()
                
            }) { (complete) in
                
            }
        }else{
            UIView.animate(withDuration: 0.25, animations: {
                self.view.backgroundColor = UIColor.clear
                self.containerTopConstraint?.constant = -1 * (self.containerHeightConstraint?.constant)!
                self.view.layoutIfNeeded()
                
            }) { (complete) in
                self.dismiss(animated: false, completion: {
                    completion()
                })
            }
        }
    }
}

extension ActionMenuViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ActionMenuTableViewCell
        cell.lblTitle?.text = menuItems[indexPath.row].title.localizedString()
        cell.lblTitle?.font = UIFont.systemFont(ofSize: 12)
        cell.lblIcon?.attributedText = Utilities.getIconString(icon: menuItems[indexPath.row].icon, size: 20)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        animatePresentation(isDismissing: true) {
            let selectedItemType = self.menuItems[indexPath.row].itemType
            Observers.action_selected.post(userInfo: [Observers.keys.selected_action : selectedItemType])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}


extension ActionMenuViewController{
    struct MenuItem {
        var image:UIImage?
        var title:LocalizedStrings
        var itemType:ActionType
        var icon:FontAwesomeType
        
        init(fontAwesome:FontAwesomeType, title:LocalizedStrings,itemType:ActionType) {
            self.image = UIImage(awesomeType: fontAwesome, size: 8, textColor: .darkGray) ?? nil
            self.title = title
            self.itemType = itemType
            self.icon = fontAwesome
        }
        
        enum ActionType{
            case confirm    //Onayla
            case sign       //imzala
            case reject     //reddet
            case initials   //paraf
            case transfer   //havale
            case notes      //notlar
            case workflow   //iş akışı
            case remove_document    //dosyayı kaldır
            case take_back  //geri çek
            case give_back  //iade
            case versions   //versiyonlar
            case history    //tarihçe
            case archive    //Arşiv
            case sign_mobile //Mobil imzala
            case share //belgeyi paylaş
            case distribution_flow //Dağıtım onay
        }
    }
}

extension ActionMenuViewController:UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
