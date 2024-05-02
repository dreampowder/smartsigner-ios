//
//  ViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 20.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
import QuickLook
enum MainTableViewState{
    case normal
    case batch(batchType:BatchOperationType)
    
    func isNormal()->Bool{
        switch self {
        case .normal:
            return true
        default:
            return false
        }
    }
}

class MainViewController: BaseViewController {
    
    //Interface Element
    @IBOutlet weak var tableView:UITableView?
    
    var sideMenuViewController:SideMenuViewController?
    var loginData:LoginResponse?
    
    var folderContents:[PoolItem] = []
    var selectedFolder:Folder?
    var isFetchingData = false
    var currentPage = 1
    var cellHeightDict:[IndexPath:CGFloat] = [:]
    var isFirstLogin = true
    
    var selectedIndexPathsForBatch:[IndexPath] = []
    var selectedDocumentsForBatchArkSigner:[PoolItem] = []
    
    var tableViewState:MainTableViewState = .normal
    
    var batchOperationQueue:[BathOperationItem] = []
    var isBatchSignTypeIsESign = false
    var batchOperationViewController:BatchOperationViewController?
    var currentSigningDocument:DocumentContent?
    var eSignCreatePackageResponse:ESignPackageResponse?
    var completeSignData:CompleteSignData?
    var batchESignCertSerial:String?
    var batchESignPinCode:String?
    var eSignViewcontroller:ESignViewController?
    var isEsign:Bool = false
    
    deinit {
        Observers.document_remove.removeObserver(observer: self)
        Observers.logout.removeObserver(observer: self)
        Observers.reload_folder.removeObserver(observer: self)
        Observers.push_event_incoming_message.removeObserver(observer: self)
        Observers.did_complete_ark_signer_sign.removeObserver(observer: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.backgroundColor = UIColor.primaryColor
        self.subViewLayoutBlock = {
            self.commonInit(trackingScrollView: self.tableView)
            self.navigationItem.leftBarButtonItem =
                UIBarButtonItem(image: UIImage(awesomeType: .bars, size: 10, textColor: .white), style: .done, target: self, action: #selector(self.revealSideMenu))
            
            self.navigationItem.rightBarButtonItem =
                UIBarButtonItem(image: UIImage(awesomeType: .search, size: 10, textColor: .white), style: .done, target: self, action: #selector(self.showSearchViewController))
            
            self.sideMenuViewController = SideMenuViewController(sideMenuWidth: UIScreen.main.bounds.width*0.7)
            self.sideMenuViewController?.modalPresentationStyle = .overCurrentContext
            self.sideMenuViewController?.sideMenuDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.separatorStyle = .none
        self.tableView?.register(UINib(nibName: "DocumentItemTableViewCell", bundle: .main), forCellReuseIdentifier: "Cell")
        self.tableView?.register(UINib(nibName: "LoadingIndicatorTableViewCell", bundle: .main), forCellReuseIdentifier: "Cell-Loading")
  
        Observers.logout.addObserver(observer: self, selector: #selector(didReceiveLogoutNotification))
        Observers.document_remove.addObserver(observer: self, selector: #selector(didReceiveRemoveDocumentNotification(notification:)))
        Observers.reload_folder.addObserver(observer: self, selector: #selector(didReceiveReloadNotification))
        Observers.push_event_incoming_message.addObserver(observer: self, selector: #selector(didReceiveIncomingMessageNotification(notification:)))
        Observers.did_complete_ark_signer_sign.addObserver(observer: self, selector: #selector(didReceiveBatchArksignerCompleteNotification(notification:)))
        setupForBatchOperations()
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkLogin()
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    @objc func didReceiveIncomingMessageNotification(notification:Notification){
        guard let msg = notification.userInfo?[Observers.keys.push_data.rawValue] as? FBPushMessageData else{
            return
        }
        if self.sideMenuViewController?.isBeingPresented ?? false {
            self.sideMenuViewController?.hideSideMenu(action: {
                self.processPushMessage(msg: msg)
            })
        }else{
            processPushMessage(msg: msg)
        }
        
    }
    
    func processPushMessage(msg:FBPushMessageData){
        guard let pushType = PushMessageType.init(rawValue: msg.type) else{
            print("Unknown push message type: \(msg.type)")
            return;
        }
        switch pushType {
        case .incoming_document:
            let progress = showProgressDialog(title: .please_wait, message: .empty_string)
            ApiClient.get_pool_items_with_id_list(poolIds: [msg.poolId])
                .execute { (_ response:FolderContentResponse?, error, statusCode) in
                    progress?.dismiss(animated: true, completion: {
                        Utilities.processApiResponse(parentViewController: self, response: response) {
                            if let document = response?.poolItems.first {
                                let vc = DocumentViewController(document: document)
                                vc.hidesBottomBarWhenPushed = true
                                if self.navigationController?.viewControllers.last?.isKind(of: QLPreviewController.self) ?? false {
                                    var viewControllers = self.navigationController?.viewControllers ?? []
                                    viewControllers.removeLast()
                                    viewControllers.append(vc)
                                    self.navigationController?.setViewControllers(viewControllers, animated: true)
                                }else{
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                
                            }else{
                                self.showBasicAlert(title: LocalizedStrings.error.localizedString(), message: LocalizedStrings.push_error_document_not_found.localizedString(), okTitle: nil, actionHandler: nil)
                            }
                        }
                    })
            }
        case .task_note:
            let progress = showProgressDialog(title: .please_wait, message: .empty_string)
            let filterModel:FilterModel = FilterModel()
            filterModel.number = msg.targetId
            ApiClient.task_list(filter:filterModel).execute { (_ response:GetTaskNotesResponse?, error, statusCode) in
                progress?.dismiss(animated: true, completion: {
                    Utilities.processApiResponse(parentViewController: self, response: response) {
                       if let task = response?.taskNotes.first{
                           let vc = TaskDetailViewController(note: task)
                           self.navigationController?.pushViewController(vc, animated: true)
                       }
                    }
                })
            }
        }
    }
    
    @objc func didReceiveReloadNotification(){
        if let folder = self.selectedFolder{
            self.resetPage(animated: true)
            self.loadFolderContents(folder: folder)
        }
    }
    
    @objc func didReceiveLogoutNotification(){
        if let presented = self.presentedViewController{
            presented.dismiss(animated: true, completion: nil)
        }
        
        self.navigationController?.setViewControllers([self], animated: true)
        self.resetPage(animated: true)
        didTapLogout()
    }

    @objc func showSearchViewController(){
        let vc = SearchDocumentTableViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func checkLogin(){
        if self.loginData == nil{
            let vc = LoginViewController.init(nibName: LoginViewController.getNibName(),bundle:nil)
            vc.loginDelegate = self
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: isFirstLogin ? false : true, completion: nil);
            isFirstLogin = false
        }
    }
    
    func populateViewWithLoginData(loginData:LoginResponse){
        self.loginData = loginData
        self.appBarViewController.navigationBar.title = "\(loginData.loggedUserName ?? "") \(loginData.loggedUserSurname ?? "")"
        self.reloadSideMenu()
    }
    
    @objc func reloadSideMenu(){
        self.sideMenuViewController?.reloadWithFolderData(folderData: self.loginData?.folders ?? [])
    }
    
    @objc func didReceiveRemoveDocumentNotification(notification:Notification){
        guard let document = notification.userInfo?[Observers.keys.removed_document.rawValue] as? PoolItem else{
            return
        }
        if let index = self.folderContents.firstIndex(where: { (item) -> Bool in
            return document.id == item.id
        }){
            self.selectedIndexPathsForBatch.removeAll(where: {$0.row == index})
            self.folderContents.remove(at: index)
            self.tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            self.updateBatButtonItemsForBatch()
        }
    }
    
    @objc func revealSideMenu(){
        guard self.presentedViewController == nil,let sideMenuController = self.sideMenuViewController else{
            return
        }
        self.present(sideMenuController, animated: false) {
            self.sideMenuViewController?.revealSideMenu()
        }
    }
    
    func resetPage(animated:Bool){
        self.currentPage = 1
        self.cellHeightDict = [:]
        
        if !animated {
            self.folderContents = []
            self.tableView?.reloadData()
        }else{
            var indexPaths:[IndexPath] = []
            for i in 0..<self.folderContents.count{
                indexPaths.append(IndexPath(row: i, section: 0))
            }
            self.folderContents = []
            self.tableView?.deleteRows(at: indexPaths, with: UITableView.RowAnimation.automatic)
        }
        self.switchTableViewState(state: .normal)
    }
    
    func loadFolderContents(folder:Folder){
        isFetchingData = true
        self.title = folder.text
        self.tableView?.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
        self.selectedFolder = folder
        ApiClient.get_pool_items(folderId: Int(folder.id) ?? 0, page: self.currentPage).execute { (_ response:FolderContentResponse?, error, statusCode) in
            Utilities.processApiResponse(parentViewController: self, response: response) {
                var indexPathArray:[IndexPath] = []
                var beginIndex = self.folderContents.count
                for folder in response?.poolItems ?? []{
                    let doesContain = self.folderContents.contains(where: { (item) -> Bool in
                        return item.id == folder.id
                    })
                    
                    if doesContain{
//                        print("already found")
                    }else{
                        self.folderContents.append(folder)
                        indexPathArray.append(IndexPath(row: beginIndex, section: 0))
                        beginIndex  = beginIndex + 1
                    }
                }
                self.isFetchingData = false
                if indexPathArray.count > 0{
                    self.tableView?.insertRows(at: indexPathArray, with: .automatic)
                }
                self.tableView?.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
                if response?.poolItems.count == API_PAGE_SIZE{
                    self.currentPage = self.currentPage + 1
                }
                
                if self.folderContents.count == 0{
                    self.revealSideMenu()
                }
            }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    override var shouldAutorotate: Bool{
        return true
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
}

extension MainViewController:LoginDelegate{
    func userDidLoginWithData(loginData: LoginResponse) {
        self.populateViewWithLoginData(loginData: loginData)
    }
    
    func performPostLoginActions() {
        self.folderContents = []
        self.tableView?.reloadData()
        
        if let msg = SessionManager.current.getAfterLoginPushMessage(){
            if self.sideMenuViewController?.isBeingPresented ?? false {
                self.sideMenuViewController?.hideSideMenu(action: {
                    self.processPushMessage(msg: msg)
                })
            }else{
                processPushMessage(msg: msg)
            }
        }else{
            self.revealSideMenu()
        }
    }
}

extension MainViewController:SideMenuDelegate{
    
    func didTapSettings() {
        let vc = AppSettingsViewController(nibName: "AppSettingsViewController", bundle: .main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectFolder(folder: Folder?) {
        guard let f = folder else{
            return
        }
        self.currentPage = 1
        self.resetPage(animated:false)
        self.loadFolderContents(folder: f)
    }
    
    func didTapLogout() {
        self.loginData = nil
        SessionManager.current.logout()
        checkLogin()
    }
    
    func didTapDelegation() {
//        let vc = DelegationContainerViewController()
        let vc = SearchDelegatesViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapTaskList(initialTaskId:Int?) {
        let vc = TaskListViewController(nibName: "TaskListViewController", bundle: .main)
        vc.initialTaskId = initialTaskId
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return folderContents.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DocumentItemTableViewCell
            let document = folderContents[indexPath.row]
            cell.load(documentItem: document, tableViewState: self.tableViewState,isSelectedForBatch: self.selectedIndexPathsForBatch.contains(indexPath))
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell-Loading", for: indexPath) as! LoadingIndicatorTableViewCell
            if self.isFetchingData{
                cell.activityIndicator?.startAnimating()
            }else{
                cell.activityIndicator?.stopAnimating()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeightDict[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return cellHeightDict[indexPath] ??  UITableView.automaticDimension
        }else{
            return 60.0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return cellHeightDict[indexPath] ??  150
        }else{
            return 60.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if self.tableViewState.isNormal(){
                var document = folderContents[indexPath.row]
                folderContents[indexPath.row].isRead = true
                tableView.reloadRows(at: [indexPath], with: .automatic)
                let vc = DocumentViewController(document: document)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.didSelectDocumentAtIndexPathForBatchOperation(indexPath: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
}

extension MainViewController:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let insets = scrollView.contentInset
        let y:CGFloat = offset.y + bounds.height - insets.bottom
        let h:CGFloat = size.height
        let reload_distance:CGFloat = 100
        if (y > h - reload_distance){
            if !isFetchingData{
                print("Fetching timeline")
                if let folder = self.selectedFolder{
                    self.loadFolderContents(folder: folder)
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let minRefreshHeight:CGFloat = 180.0
        if scrollView.contentOffset.y <= -minRefreshHeight{
            if let folder = self.selectedFolder{
                if !isFetchingData{
                    self.resetPage(animated: true)
                    self.loadFolderContents(folder: folder)
                }
            }
        }
    }
}
