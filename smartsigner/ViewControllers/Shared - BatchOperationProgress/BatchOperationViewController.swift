//
//  BatchOperationViewController.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 11.11.2019.
//  Copyright © 2019 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents

protocol BatchOperationDelegate {
    func didFinishAllOperations(viewController:BatchOperationViewController, isAllSuccess:Bool)
    func didTapRetryOperation(viewController:BatchOperationViewController,id:Int)
    func cancelRemainingOperations()
}

struct BathOperationItem {
    let title:String
    let detail:String
    let identifier:Int
    let operationType:BatchOperationType
    var isInProgress:Bool
    var hasError:Bool
    var errorContent:String?
}

class BatchOperationViewController: UITableViewController {

    var parentVC:UIViewController?
    var operations:[BathOperationItem] = []
    var operationType:BatchOperationType?
    var delegate:BatchOperationDelegate?
    
    static let shapeScheme:MDCShapeScheme = MDCShapeScheme()
    
    var progressViewAlert:WFProgressDialogViewController?
    var container:MDCAppBarContainerViewController?
    var isArkSignerOperation:Bool = false
    var willDelayOnSuccess:Bool = false
    
    func dispose(){
        parentVC = nil
        delegate = nil
        container = nil
    }
    
    deinit {
        print("Disposing PARENTVC!")
        dispose()
        Observers.batch_operation_discard_fingerprint_dialog.removeObserver(observer: self)
    }
    
    func dismissAndDispose(completion: (() -> Void)? = nil){
        dispose()
        self.dismiss(animated: true, completion: completion)
    }
    
    @discardableResult
    static func presentFromBotomSheet(parent:UIViewController, documents:[PoolItem], operationType:BatchOperationType, isArkSignerOperation:Bool) -> BatchOperationViewController{
           let vc = BatchOperationViewController(documents: documents, operationType: operationType)
           vc.parentVC = parent
           vc.delegate = parent as? BatchOperationDelegate
           vc.title = LocalizedStrings.batch_ark_signer_peraparing.localizedString()
           vc.isArkSignerOperation = isArkSignerOperation
           return vc.presentFromBottomSheet(completion: nil)
       }
    
    @discardableResult
    static func presentFromBotomSheet(parent:UIViewController, documents:[PoolItem], operationType:BatchOperationType) -> BatchOperationViewController{
        let vc = BatchOperationViewController(documents: documents, operationType: operationType)
        vc.parentVC = parent
        vc.delegate = parent as? BatchOperationDelegate
        vc.title = operationType.getTitle()
        
        return vc.presentFromBottomSheet(completion: nil)
    }
    
    @discardableResult
    func presentFromBottomSheet(completion:(()->Void)?) -> BatchOperationViewController{
        
        if container == nil{
            container = MDCAppBarContainerViewController(contentViewController: self)
            container?.appBarViewController.headerView.trackingScrollView = self.tableView
            container?.isTopLayoutGuideAdjustmentEnabled = true
            ThemeManager.applyAppBarTheme(appBar: container!.appBarViewController)
        }
        
        let bottomSheet = MDCBottomSheetController(contentViewController: container!)
        bottomSheet.trackingScrollView = self.tableView
        MDCBottomSheetControllerShapeThemer.applyShapeScheme(BatchOperationViewController.shapeScheme, to: bottomSheet)
        bottomSheet.dismissOnBackgroundTap = false
        bottomSheet.delegate = self
        parentVC?.present(bottomSheet, animated: true, completion: completion)
        return self
    }
    
    convenience init(documents:[PoolItem], operationType:BatchOperationType) {
        self.init(style:.plain)
        self.operationType = operationType
        documents.forEach { (item) in
            operations.append(BathOperationItem(title: item.subject,detail:item.fromSentence, identifier: item.id, operationType: operationType, isInProgress: true,hasError: false,errorContent: nil))
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        Observers.batch_operation_progress.addObserver(observer: self, selector: #selector(didReceiveBatchOperationUpdate(notification:)))
        if let opType = self.operationType{
            self.title = opType == BatchOperationType.transfer ? LocalizedStrings.batch_transfer.localizedString() : LocalizedStrings.batch_sign.localizedString()
        }
        Observers.batch_operation_discard_fingerprint_dialog.addObserver(observer: self, selector: #selector(didReceiveDiscardFingerPrintAlertNotification(notification:)))
    }
    
    func showFingerPrintAlert(title:String, fingerPrint:String){
        if let progress = self.progressViewAlert{
            progress.setTitle(title: title).setMessage(message: fingerPrint)
        }else{
            self.progressViewAlert = self.showProgressDialog(
                title: title,
                message: LocalizedStrings.alert_mobile_sign_fingerPrint.localizedString(params: [fingerPrint]),
                isIndeterminate:true)
        }
    }
    
    @objc func didReceiveDiscardFingerPrintAlertNotification(notification:Notification){
        self.discardFingerPrintAlert {
            
        }
    }
    
    @objc func discardFingerPrintAlert(completion:@escaping ()->Void){
        self.progressViewAlert?.dismiss(animated: true, completion: {
            self.progressViewAlert = nil
            completion()
        })
    }
    
    
    
    @objc func didReceiveBatchOperationUpdate(notification:Notification) {
        guard
            let operationId = notification.userInfo?[Observers.keys.operation_id.rawValue] as? Int,
            let index = operations.firstIndex(where: {$0.identifier == operationId}),
            let isSuccess = notification.userInfo?[Observers.keys.operation_success.rawValue] as? Bool
        else{return}
        if let errorContent = notification.userInfo?[Observers.keys.operation_error_content.rawValue] as? String{
            operations[index].errorContent = errorContent
        }
        self.discardFingerPrintAlert {
            
        }
        self.operations[index].isInProgress = false
        self.operations[index].hasError = !isSuccess
        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        if self.operations.filter({$0.isInProgress == true}).count == 0 && self.operations.filter({$0.hasError == true}).count == 0{
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            if willDelayOnSuccess{
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.delegate?.didFinishAllOperations(viewController: self,isAllSuccess: true)
                }
            }else{
                self.delegate?.didFinishAllOperations(viewController: self,isAllSuccess: true)
            }
        }
    }
    
    @objc func didTapRetryButton(sender:MDCButton){
        if let errorContent = self.operations[sender.tag].errorContent{
        AlertDialogFactory.showAlertActionDialog(vc: self, title: LocalizedStrings.operation_failed.localizedString(), message: LocalizedStrings.operation_failed_content.localizedString(params: [errorContent]), actions: [
            MDCAlertAction(title: LocalizedStrings.retry.localizedString(), emphasis: .high, handler: { (action) in
                self.retryOperation(sender: sender)
            }),
            MDCAlertAction(title: LocalizedStrings.cancel.localizedString(), emphasis: .low, handler: nil)
            ])
        }else{
            self.retryOperation(sender: sender)
        }
        
    }
    
    //Arksigner için id değerini -1 dönüyoruz. bu şekilde arksigner işlemlerinde tek bir belgeyi retry etmek yerine kalan belgeleri toplu retry etmiş oluyoruz.
    func retryOperation(sender:MDCButton){
        self.operations[sender.tag].isInProgress = true
        self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
        self.delegate?.didTapRetryOperation(viewController: self, id: self.isArkSignerOperation ? -1 : self.operations[sender.tag].identifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Operation Count: \(operations.count)")
        return operations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        let operation = self.operations[indexPath.row]
        cell?.textLabel?.text = operation.title
        cell?.detailTextLabel?.text = operation.detail
        if operation.isInProgress {
            var activityView:MDCActivityIndicator?
            if let activity = cell?.accessoryView as? MDCActivityIndicator{
                activityView = activity
                activity.startAnimating()
            }else{
                activityView = MDCActivityIndicator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                activityView?.indicatorMode = .indeterminate
                cell?.accessoryView = activityView
            }
            activityView?.startAnimating()
        }else{
            if !operation.hasError{
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                imageView.contentMode = .scaleAspectFit
                imageView.image = UIImage(awesomeType: .checkCircle, size: 30, textColor: .primaryColor)
                cell?.accessoryView = imageView
            }else{
//                if !self.isArkSignerOperation { //Arksigner işlemlerinde retry özelliği yok
                    let button = MDCButton()
                    button.setTitle(LocalizedStrings.retry.localizedString(), for: .normal)
                    ThemeManager.applyErrorButtonColorTheme(button: button)
                    button.sizeToFit()
                    button.tag = indexPath.row
                    button.addTarget(self, action: #selector(didTapRetryButton(sender:)), for: .touchUpInside)
                    cell?.accessoryView = button
//                }
            }
        }
        return cell!
    }
}

extension BatchOperationViewController:MDCBottomSheetControllerDelegate{
    func bottomSheetControllerDidDismissBottomSheet(_ controller: MDCBottomSheetController) {
        if self.operations.filter({$0.isInProgress == true}).count > 0 {
            AlertDialogFactory.showAlertActionDialog(vc: self.parentVC!, title: LocalizedStrings.batch_operation_cancel_alert_title.localizedString(), message: LocalizedStrings.batch_operation_cancel_alert_message.localizedString(), actions: [
                MDCAlertAction(title: LocalizedStrings.yes.localizedString(), emphasis: .high, handler: { (_) in
                    self.delegate?.cancelRemainingOperations()
                }),
                MDCAlertAction(title: LocalizedStrings.no.localizedString(), emphasis: .high, handler: { (_) in
                    self.parentVC?.present(controller, animated: true, completion: nil)
                }),
            ])
        }else{
            let operations = self.operations.filter({$0.hasError == false && $0.isInProgress == false})
            self.delegate?.didFinishAllOperations(viewController: self, isAllSuccess: operations.count > 0)
        }
    }
}
