//
//  DocumentViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 23.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
import WebKit
import QuickLook
class DocumentViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView?
    
    var documentActionBL:DocumentActionBusinessLogic?
    
    var appBarViewController:MDCAppBarViewController = MDCAppBarViewController()
    

    var document:PoolItem?
    var didLayoutSubviews = false
    var isDetailExpanded = false
    var documentContent:DocumentContent?
    var documentUrl:URL?
    var documentHeight:CGFloat?
    var dialogTranstitionController = MDCDialogTransitionController()

    var initialIndexPath:IndexPath?
    
    var eSignCreatePackageResponse:ESignPackageResponse?
    var completeSignData:CompleteSignData?
    
    var attachmentFileUrl:URL?
    
    var workFlowsignData:(documentId:Int, workFlowActionId:Int, workFlowInstanceId:Int,poolId:Int, operationGuid:String,isMobileSign:Bool)?
    
    var isDismissing = false
    var shareVC:UIActivityViewController!
    
    convenience init(document:PoolItem) {
        self.init(nibName: DocumentViewController.getNibName(), bundle: .main)
        self.document = document
    }
    
    override func viewDidLayoutSubviews() {
        if !didLayoutSubviews{
            didLayoutSubviews = true
            commonInit()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIViewController.attemptRotationToDeviceOrientation()
        if self.isMovingFromParent{
            self.removeObservers()
            isDismissing = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    func removeObservers(){
        print("removing observers")
        self.documentActionBL = nil;
        Observers.toggle_document_detail.removeObserver(observer: self)
        Observers.action_selected.removeObserver(observer: self)
        Observers.update_tableview.removeObserver(observer: self)
        Observers.did_select_attachment.removeObserver(observer: self)
        Observers.did_complete_ark_signer_sign.removeObserver(observer: self)
        NotificationCenter.default.removeObserver(self, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    
    deinit {
        print("deinit")
        SessionManager.current.refreshFolders()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.register(UINib(nibName: "DocumentDetailsMiniTableViewCell", bundle: .main), forCellReuseIdentifier: "CellDetailsMini")
        self.tableView?.register(UINib(nibName: "DocumentDetailsExpandedTableViewCell", bundle: .main), forCellReuseIdentifier: "CellDetailsExpanded")
        self.tableView?.register(UINib(nibName: "PDFDocumentTableViewCell", bundle: .main), forCellReuseIdentifier: "DocumentCell")
        self.tableView?.register(UINib(nibName: "DocumentAttachmentTableViewCell", bundle: .main), forCellReuseIdentifier: "AttachmentCell")
        
        Observers.toggle_document_detail.addObserver(observer: self, selector: #selector(didReceiveExpandDetailNotification))
        Observers.update_tableview.addObserver(observer: self, selector: #selector(didreceiveUpdateNotification))
        Observers.action_selected.addObserver(observer: self, selector: #selector(didReceiveSelectActionNotification(notification:)))
        Observers.did_select_attachment.addObserver(observer: self, selector: #selector(didReceiveAttachmentNotification(notification:)))
        Observers.did_complete_ark_signer_sign.addObserver(observer: self, selector: #selector(didReceiveArkSignerCompleteNotification(notification:)))
        self.title = self.document?.subject ?? ""
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDidTakeScreenShotNotification(notification:)), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        loadDocument()
    }
    
    @objc func userDidTakeScreenShotNotification(notification:Notification){
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let message = "\(df.string(from: Date())) tarihinde mobil ios uygulaması üzerinden \(document?.documentId) id'li belge için ekran görüntüsü alındı"
        ApiClient.save_document_operation(id: self.document?.documentId ?? 0, operationType: .screen_capture, description: message).execute { (_ response:FolderListResponse?, error, statusCode) in
            print("did sent response for screenshot")
        }
    }
    
    @objc func didReceiveAttachmentNotification(notification:Notification){
        guard  let attachment = notification.userInfo?[Observers.keys.selected_attachment.rawValue] as? DocumentAttachment,
               let isRelated = notification.userInfo?[Observers.keys.is_related.rawValue] as? Bool
            else{
            return
        }
        if attachment.attachmentTypeEnum == AttachmentTypeEnum.physicalAttachment.rawValue || attachment.attachmentTypeEnum == AttachmentTypeEnum.physicalDocument.rawValue{ //Fiziksel Attachment
            AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.attachment.localizedString(), message: "\(attachment.name ?? "")\n\(attachment.descriptionField ?? "")", doneButtonTitle: nil, doneButtonAction: nil);
        }else{
            self.loadAttachment(attachment: attachment, isRelated:isRelated)
        }
    }
    
    @objc func didReceiveSelectActionNotification(notification:Notification){
        guard let selectedItem:ActionMenuViewController.MenuItem.ActionType = notification.userInfo?[Observers.keys.selected_action.rawValue] as? ActionMenuViewController.MenuItem.ActionType else{
            return
        }
        print("did receive action: \(selectedItem)")
        self.documentActionBL?.performAction(action: selectedItem)
    }
    
    @objc func didTapShowActionMenuButton(){
        guard let content = self.documentContent else{
            return
        }
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        let statusHeight =  min(statusBarSize.width, statusBarSize.height)
        let vc = ActionMenuViewController(documentContent: content, containerNavbarHeight: self.appBarViewController.navigationBar.bounds.height + statusHeight)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
        
    @objc func didreceiveUpdateNotification(){
        self.tableView?.beginUpdates()
        self.tableView?.endUpdates()
    }
    
    func commonInit(){
        appBarViewController.inferTopSafeAreaInsetFromViewController = true
        appBarViewController.headerView.minMaxHeightIncludesSafeArea = false
        self.addChild(appBarViewController)
        appBarViewController.headerView.observesTrackingScrollViewScrollEvents = true
        appBarViewController.headerView.trackingScrollView = self.tableView
        view.addSubview(appBarViewController.view)
        appBarViewController.didMove(toParent: self)
        ThemeManager.applyAppBarTheme(appBar: self.appBarViewController)
        self.tableView?.backgroundColor = .tableviewBackground
        self.view.backgroundColor = .tableviewBackground
    }
    
    func getPdfHeight() -> CGFloat?{
        guard
            let dUrl = self.documentUrl,
            let pdfFile:CGPDFDocument = CGPDFDocument(dUrl as CFURL) else{
            return UIScreen.main.bounds.height
        }
        var totalHeight:CGFloat = 0.0
        var maxWidth:CGFloat = 0.0;
        let numberOfPages = pdfFile.numberOfPages
        for  i in 0...numberOfPages {
            totalHeight += pdfFile.page(at: i)?.getBoxRect(.mediaBox).height ?? 0.0
            if let width = pdfFile.page(at: i)?.getBoxRect(.mediaBox).width{
                if width > maxWidth{
                    maxWidth = width;
                }
            }
        }
        var scale:CGFloat = 1.0;
        if maxWidth > 0{
            scale = self.view.bounds.width / maxWidth
        }
        totalHeight = totalHeight*scale + 40.0;
        return totalHeight;
    }
    
    func loadDocument(){
        ApiClient.document_details(document: self.document!).execute(responseBlock: { (_ response:DocumentContent?, error, statusCode) in
            Utilities.processApiResponse(parentViewController: self, response: response) {
                let fileName = LocalFileManager.getFileName(document: self.document!)
                            self.documentContent = response
                            if self.documentContent?.clientHasSameDataWithServer ?? false{
                                self.documentUrl = LocalFileManager.getFileUrlIfAvailable(userId: SessionManager.current.loginData?.loggedUserId ?? 0, fileName: fileName)
                            }else{
                                if let data = Data(base64Encoded: response?.documentData ?? ""){
                                    if  let localUrl = LocalFileManager.saveFile(userId: SessionManager.current.loginData?.loggedUserId ?? 0, fileName: fileName, data:data)
                                    {
                                        self.documentUrl = localUrl
                                    }
                                }
                            }
                            self.documentHeight =  self.getPdfHeight()
                            self.documentContent?.documentData = nil
                            self.tableView?.reloadData()
                            if let content = response{
                                self.documentActionBL = DocumentActionBusinessLogic(parentViewController: self, document: self.document, documentContent: content)
                                let barItems:[UIBarButtonItem] = [
                                    UIBarButtonItem(image: UIImage(awesomeType: .ellipsisV, size: 14.0, textColor: .white), style: UIBarButtonItem.Style.done, target: self, action: #selector(self.didTapShowActionMenuButton)),
                                    ]
                                self.navigationItem.rightBarButtonItems = barItems
                            }
            }
            
        }) { (progress) in
            Observers.progress_update.post(userInfo: [Observers.keys.progress_amount : progress,Observers.keys.progress_target_id:self.document?.id ?? 0])
        }
    }
    
    @objc func didReceiveExpandDetailNotification(notification:Notification){
        self.isDetailExpanded = !self.isDetailExpanded
        self.tableView?.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.automatic)
    }
    
    func loadAttachment(attachment:DocumentAttachment, isRelated:Bool){
        
        if !isRelated {
            if let localUrl = LocalFileManager.getFileUrlIfAvailable(userId: SessionManager.current.loginData?.loggedUserId ?? 0, fileName: LocalFileManager.getAttachmentFilename(attachment: attachment)){
                self.attachmentFileUrl = localUrl
                self.showQuickLook()
                return
            }
        }
        
        
        let progress = self.showProgressDialog(title: LocalizedStrings.progress_loading_attachment , message:LocalizedStrings.empty_string)
        let request = isRelated ? ApiClient.document_related(relatedId: attachment.id, poolId:documentContent?.pool.id ?? 0) : ApiClient.document_attachment(attachmentId: attachment.id, poolId: documentContent?.pool.id ?? 0)
        request.execute { (content:AttachmentContent?, error, statusCode) in
                Utilities.delay(1, closure: {
                    progress?.dismiss(animated: true, completion: {
                        if let c = content{
                            
                            if let errorContent = c.errorContent(){
                                AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.error.localizedString(), message: errorContent, doneButtonTitle: nil) {
                                    
                                }
                            }else{
                                let data = Data(base64Encoded: c.data ?? "")
                                
                                if (!isRelated && c.isPhysicalAttachment ?? false) || (isRelated && c.isPhysicalRelatedDocument ?? false){
                                    var message = attachment.name ?? "-"
                                    if isRelated{
                                        message = "\(LocalizedStrings.number.localizedString()):\(c.documentNumberNumber ?? "-")\n\(LocalizedStrings.date.localizedString()):\(c.documentDate ?? "-")\n\(LocalizedStrings.subject.localizedString()):\(c.documentSubject ?? "-")\nKKK:\(c.documentNumberBYK ?? "-")\n\(LocalizedStrings.file_plan.localizedString()):\(c.documentNumberSdp ?? "-")\n\(LocalizedStrings.description.localizedString()):\(c.documentDescription ?? "-")"
                                    }
                                    AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.document_attachment_physical.localizedString(), message: message, doneButtonTitle: nil, doneButtonAction: nil)
                                }else{
                                    if isRelated {
                                        var relatedatt = attachment
                                        relatedatt.fileExtension = content?.fileExtension ?? ""
                                        self.attachmentFileUrl = LocalFileManager.saveFile(userId: SessionManager.current.loginData?.loggedUserId ?? 0, fileName: LocalFileManager.getAttachmentFilename(attachment: relatedatt), data: data!)
                                    }else{
                                        self.attachmentFileUrl = LocalFileManager.saveFile(userId: SessionManager.current.loginData?.loggedUserId ?? 0, fileName: LocalFileManager.getAttachmentFilename(attachment: attachment), data: data!)
                                    }
                                    
                                    self.showQuickLook()
                                }
                            }
                        }
                    })
                })
        }
    }
    
    func showQuickLook(){
        guard let _ = self.attachmentFileUrl as NSURL? else{
            print("Incorrect Attachment URL")
            return
        }
        let quickLook = QLPreviewController()
        quickLook.delegate = self
        quickLook.dataSource = self
        quickLook.currentPreviewItemIndex = 0;
        self.navigationController?.pushViewController(quickLook, animated: true)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return isDismissing ? .portrait : [.portrait,.landscape]
    }
    
    override var shouldAutorotate: Bool{
        return true
    }
    
    public func showShareDocument(){
        guard let url = self.documentUrl else{return}
        shareVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        shareVC.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
            if completed {
                let message = "\(self.document?.documentId ?? 0) id'li belge, mobil ios uygulması kullanılarak \(activityType?.rawValue ?? "<bilinmeyen>") üzerinden paylaşıldı."
                ApiClient.save_document_operation(id: self.document?.documentId ?? 0, operationType: .share_in_mobile_app, description: message)
                    .execute { (_ response:FolderListResponse?, error, statusCode) in
                        print("Did save documentAction")
                }
            }
        }
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            shareVC.popoverPresentationController?.sourceView = self.view
            shareVC.popoverPresentationController?.permittedArrowDirections = []
        }
        self.present(shareVC, animated: true) {
            
        }
    }
}

extension DocumentViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.isDetailExpanded ? "CellDetailsExpanded" : "CellDetailsMini", for: indexPath) as! DocumentDetailsTableViewCell
            cell.loadWithDocument(document: self.document, isExpanded: self.isDetailExpanded)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentCell") as! DocumentAttachmentTableViewCell
            cell.loadWithAttachments(attachments: self.documentContent?.attachments ?? nil)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentCell") as! DocumentAttachmentTableViewCell
            cell.loadWithRelateds(relatedItems: self.documentContent?.related ?? nil)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell") as! PDFDocumentTableViewCell
            cell.loadPdfAtUrl(url: self.documentUrl, documentId: self.document?.id ?? 0)
            cell.webView?.scrollView.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row==3{
            return self.documentHeight ?? UITableView.automaticDimension
        }else if indexPath.row == 1{
            return self.document?.hasAttachment ?? false ? UITableView.automaticDimension : 0
        }else if indexPath.row == 2{
            return self.documentContent?.related.count ?? 0 > 0 ? UITableView.automaticDimension : 0
        }
        else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DocumentViewController:UIScrollViewDelegate{
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.tableView?.scrollToRow(at: IndexPath(row: 3, section: 0), at: .top, animated: true)
        self.tableView?.isScrollEnabled = false
        scrollView.isScrollEnabled = true
        if self.initialIndexPath == nil{
            self.initialIndexPath = self.tableView?.indexPathsForVisibleRows?.first
        }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scale <= scrollView.minimumZoomScale {
            self.tableView?.isScrollEnabled = true
            scrollView.isScrollEnabled = false
            if let indexPath = self.initialIndexPath{
                self.tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
                self.initialIndexPath = nil
            }
        }
    }
}

extension DocumentViewController:QLPreviewControllerDelegate,QLPreviewControllerDataSource{
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return  1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.attachmentFileUrl! as NSURL
    }
    
}
