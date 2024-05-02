//
//  SideMenuViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 23.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
import Kingfisher
import LocalAuthentication

protocol SideMenuDelegate {
    func didTapSettings()
    func didSelectFolder(folder:Folder?)
    func didTapLogout()
    func didTapDelegation()
    func didTapTaskList(initialTaskId:Int?)
}

class SideMenuViewController: UIViewController {

    @IBOutlet weak var tableViewContainer:MDCShadowView?
    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var tableViewWidthConstraint:NSLayoutConstraint?
    @IBOutlet weak var tableViewLeftConstraint:NSLayoutConstraint?
    
    @IBOutlet weak var lblCorporateName:UILabel?
    @IBOutlet weak var imgLogo:UIImageView?
    
    @IBOutlet weak var btnLogout:UIButton?
    @IBOutlet weak var btnProxy:UIButton?
//    @IBOutlet weak var btnFastLogin:UIButton?
    @IBOutlet weak var btnTaskList:UIButton?
    
    @IBOutlet weak var sideMenuHeaderView:UIView?
    
//    @IBOutlet weak var btnLanguage:UIButton?
    @IBOutlet weak var btnSettings:UIButton?
    
    var sideMenuWidth:CGFloat = UIScreen.main.bounds.width
    
    var folderData:[Folder] = []
    var didLayoutSubViews = false
    var sideMenuDelegate:SideMenuDelegate?
    
    var flatFolderList:[Folder] = []
    
    var isSideMenuOpen = false
    
    deinit {
        Observers.reload_side_menu_folders.removeObserver(observer: self)
    }
    
    convenience init(sideMenuWidth:CGFloat) {
        self.init(nibName: SideMenuViewController.getNibName(), bundle: .main)
        self.sideMenuWidth = sideMenuWidth
        
    }
    
    override func viewDidLayoutSubviews() {
        if !didLayoutSubViews{
            didLayoutSubViews = true
            self.sideMenuWidth = self.view.bounds.width * 0.85
            self.tableViewLeftConstraint?.constant = -1 * self.sideMenuWidth
            self.tableViewWidthConstraint?.constant = self.sideMenuWidth
            self.view.backgroundColor = .clear
            self.tableViewContainer?.shadowLayer.elevation = .cardPickedUp
            
            self.imgLogo?.layer.cornerRadius = 8.0
            self.imgLogo?.layer.borderColor = UIColor.primaryColor.cgColor
            self.imgLogo?.layer.borderWidth = 1.0
            self.imgLogo?.backgroundColor = .white
            
            self.sideMenuHeaderView?.backgroundColor = .sideMenuBackground
            self.tableView?.backgroundColor = .sideMenuBackground
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.register(UINib(nibName: "SideMenuTableViewCell", bundle: .main), forCellReuseIdentifier: "Cell")
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.backgroundColor = .tableviewBackground
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOutside))
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        let iconSize:CGFloat = 30.0
        btnProxy?.setAttributedIcon(icon: .userCircle, size: iconSize)
        btnProxy?.tintColor = .secondaryTextColor

        btnLogout?.setAttributedIcon(icon: .powerOff, size: iconSize)
        btnLogout?.tintColor = .secondaryTextColor
        
        btnSettings?.setAttributedIcon(icon: .cogs, size: iconSize)
        btnSettings?.tintColor = .secondaryTextColor
//        btnFastLogin?.setAttributedIcon(icon: .fingerprint, size: iconSize)
//        btnFastLogin?.tintColor = .secondaryTextColor
        
        btnTaskList?.setAttributedIcon(icon: .list, size: iconSize)
        btnTaskList?.tintColor = .secondaryTextColor
        
        self.btnLogout?.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        self.btnProxy?.addTarget(self, action: #selector(didTapDelegateButton), for: .touchUpInside)
//        self.btnFastLogin?.addTarget(self, action: #selector(didTapFastLoginButton), for: .touchUpInside)
        self.btnTaskList?.addTarget(self, action: #selector(didTapTaskListButton(sender:)), for: .touchUpInside)
        
        Observers.reload_side_menu_folders.addObserver(observer: self, selector: #selector(didReceiveFolderUpdateNotification(notification:)))
        
//        let context = LAContext()
//        var authError: NSError?
//        let canShowBiometric = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError)
//        self.btnFastLogin?.isHidden = !canShowBiometric
//
//
//        self.btnLanguage?.addTarget(self, action: #selector(didTapLanguageButton), for: .touchUpInside)
        self.btnSettings?.addTarget(self, action: #selector(didTapSettings), for: .touchUpInside)
        
    }
    
    @objc func didTapSettings(){
        self.sideMenuDelegate?.didTapSettings()
    }
    
//    @objc func didTapLanguageButton(){
//        if LocalizedStrings.getCurrentLocale().elementsEqual("tr") {
//            LocalizedStrings.setCurrentLocale(locale: "en")
//        }else{
//            LocalizedStrings.setCurrentLocale(locale: "tr")
//        }
//        self.btnLanguage?.setTitle(LocalizedStrings.getCurrentLocale().elementsEqual("tr") ? "TR" : "EN", for: .normal)
//        Observers.reload_folder.post(userInfo: nil)
//        SessionManager.current.refreshFolders()
//    }
//    @objc func didTapFastLoginButton(){
//        let context = LAContext()
//        var authError: NSError?
//        let canShowBiometric = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError)
//
//        if canShowBiometric{
//            if UserDefaultsManager.fast_login_data.getDefaultsValue() == nil{
//                AlertDialogFactory.showAlertActionDialog(vc: self, title: LocalizedStrings.btn_fast_login.localizedString(), message: LocalizedStrings.fast_login_confirm_message.localizedString(), actions: [MDCAlertAction(title: LocalizedStrings.yes.localizedString(), handler: { (action) in
//
//                    self.setFastLoginForCurrentUser()
//                }),MDCAlertAction(title: LocalizedStrings.no.localizedString(), handler: { (action) in
//
//                })])
//            }else{
//                let doesAlreadyHaveFastLogin = (UserDefaultsManager.fast_login_data.getDefaultsValue() != nil)
//
//                var actions:[MDCAlertAction] = [MDCAlertAction(title: LocalizedStrings.cancel.localizedString(), handler: { (action) in
//
//                })]
//                if doesAlreadyHaveFastLogin{
//                    actions.append(MDCAlertAction(title: LocalizedStrings.fast_login_remove.localizedString(), handler: { (action) in
//                        UserDefaultsManager.fast_login_data.clearValue()
//                        self.showBasicAlert(title: LocalizedStrings.btn_fast_login, message: LocalizedStrings.fast_login_clear_success, okTitle: .ok, actionHandler: nil)
//                    }))
//                }else{
//                    actions.append(MDCAlertAction(title: LocalizedStrings.fasr_login_enable_for_this_account.localizedString(), handler: { (action) in
//
//                        self.setFastLoginForCurrentUser()
//
//                    }))
//                }
//                AlertDialogFactory.showAlertActionDialog(vc: self, title: LocalizedStrings.btn_fast_login.localizedString(), message: LocalizedStrings.fast_login_select_action.localizedString(), actions: actions)
//            }
//        }else{
//
//        }
//
//    }
//
//    func setFastLoginForCurrentUser(){
//        if
//            let company = SessionManager.current.serviceData,
//            let username = SessionManager.current.loginData?.loggedUserUserName,
//            let rawpw = SessionManager.current.rawpw,
//            let password = String(data: rawpw, encoding: .utf8){
//
//            let dataDict:[String:Any] = ["company":company.toDictionary(),"username":username,"pwd":password]
//            let jsonData = try! JSONSerialization.data(withJSONObject: dataDict, options: [])
//            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8){
//                UserDefaultsManager.fast_login_data.setDefaultValue(value: jsonString)
//            }
//            showBasicAlert(title: LocalizedStrings.btn_fast_login, message: LocalizedStrings.fast_login_enable_success, okTitle: .ok, actionHandler: nil)
//        }
//    }
    
    @objc func didTapDelegateButton(){
        self.hideSideMenu {
            self.sideMenuDelegate?.didTapDelegation()
        }
    }
    
    @objc func didTapLogout(){
        let _ = showAlert(title: LocalizedStrings.logout, message: LocalizedStrings.logout_message, actions: [
            (title: LocalizedStrings.cancel, handler:nil),
            (title: LocalizedStrings.logout, handler:{(action) in
                self.hideSideMenu {
                    self.sideMenuDelegate?.didTapLogout()
                }
            })
            ])
    }
    
    @objc func didTapOutside(){
        selectFolder(selectedFolder: nil)
    }

    @objc func didReceiveFolderUpdateNotification(notification:Notification){
        guard let folderList = notification.userInfo?[Observers.keys.folder_list.rawValue] as? [Folder] else{
            return
        }
        self.reloadWithFolderData(folderData: folderList)
    }
    
    func reloadWithFolderData(folderData:[Folder]){
        self.flatFolderList = []
        for index in 0..<folderData.count{
            let folder = folderData[index]
            self.flatFolderList.append(contentsOf: folder.getFlatList())
        }
        self.tableView?.reloadData()
    }
    
    @objc func didTapTaskListButton(sender:UIButton){
        self.hideSideMenu {
            self.sideMenuDelegate?.didTapTaskList(initialTaskId: nil)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        let attrTitle = NSMutableAttributedString(string: SessionManager.current.serviceData?.projectName ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18,weight:.semibold),NSAttributedString.Key.foregroundColor:UIColor.primaryTextColor])
        attrTitle.append(NSMutableAttributedString(string: "\n\(SessionManager.current.loginData?.loggedUserName ?? "") \(SessionManager.current.loginData?.loggedUserSurname ?? "")", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.primaryTextColor]))
        
        self.lblCorporateName?.attributedText = attrTitle
        if let url = URL(string: SessionManager.current.serviceData?.imageUrl ?? ""){
            self.imgLogo?.kf.setImage(with: url)
        }
        
//
//        self.imgLogo?.kf.setImage(with: URL(string: SessionManager.current.serviceData?.imageUrl ?? ""), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, _, _) in
//            self.imgLogo?.image = image
//        })
//        self.btnLanguage?.setTitle(LocalizedStrings.getCurrentLocale().elementsEqual("tr") ? "TR" : "EN", for: .normal)
    }
    
    func revealSideMenu(){
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }) { (complete) in
            if complete{
                UIView.animate(withDuration: 0.15, animations: {
                    self.tableViewLeftConstraint?.constant = 0
                    self.view.layoutIfNeeded()
                    
                })
            }
        }
    }
    
    func selectFolder(selectedFolder:Folder?){
        self.hideSideMenu {
            self.sideMenuDelegate?.didSelectFolder(folder: selectedFolder)
        }
    }
    
    func hideSideMenu(action:@escaping()->Void){
        UIView.animate(withDuration: 0.25, animations: {
            self.tableViewLeftConstraint?.constant = -1 * self.sideMenuWidth
            self.view.backgroundColor = .clear
            self.view.layoutIfNeeded()
        }) { (complete) in
            if complete{
                self.dismiss(animated: false, completion: {
                    action()
                })
            }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
}

extension SideMenuViewController:UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.flatFolderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SideMenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SideMenuTableViewCell
        cell.loadWithFolder(node: self.flatFolderList[indexPath.row], isExpanded: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folder = self.flatFolderList[indexPath.row]
        if folder.folderLevel > 0{
            self.selectFolder(selectedFolder: folder)
        }
    }
}

extension SideMenuViewController:UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
