//
//  CorpSelectorViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 1.10.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit

import MaterialComponents
protocol ServiceSelectorDelegate {
    func didSelectService(service:ServiceData);
}

class ServiceSelectorViewController: BaseViewController {

    @IBOutlet weak var collectionView:UICollectionView?;
    @IBOutlet weak var menuAnchor:UIView!
    
    var services:[ServiceData]?
    var delegate:ServiceSelectorDelegate?
    var startingRect:CGRect?
    
    var isTest = false
    
    var testServices:[ServiceData]?
    
    convenience init(services:[ServiceData]) {
        self.init(nibName: ServiceSelectorViewController.getNibName(), bundle: .main)
        
        self.subViewLayoutBlock = {
            self.commonInit(trackingScrollView: self.collectionView)
        }
        self.services = services.filter({ (service) -> Bool in
            return !service.isTestService
        })
        
        self.testServices = services.filter({ (service) -> Bool in
            return service.isTestService
        })
        
        self.services?.sort(by: { (s1, s2) -> Bool in
            if s1.orderNumber == nil || s2.orderNumber == nil{
                return false
            }
            return s1.orderNumber <= s2.orderNumber
        })
        
        self.testServices?.sort(by: { (s1, s2) -> Bool in
            if s1.orderNumber == nil || s2.orderNumber == nil{
                return false
            }
            return s1.orderNumber <= s2.orderNumber
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(UINib(nibName: "ServiceCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "Cell")
        self.title = LocalizedStrings.btn_select_service_empty.localizedString()
        let barBtnCancel = UIBarButtonItem(title: LocalizedStrings.cancel.localizedString(), style: .done, target: self, action: #selector(didTapCancel))
        self.navigationItem.leftBarButtonItem = barBtnCancel
        
        let barBtnTest =  UIBarButtonItem(image: UIImage(awesomeType: .ellipsisV, size: 14.0, textColor: .white), style: UIBarButtonItem.Style.done, target: self, action: #selector(didTapTestButton))
        self.navigationItem.rightBarButtonItem = barBtnTest
        self.collectionView?.backgroundColor = .tableviewBackground
    }
    
    @objc func didTapTestButton(){
        let selectionMenu =  RSSelectionMenu(dataSource: [self.isTest ?  LocalizedStrings.hide_test_servers.localizedString() :  LocalizedStrings.show_test_servers.localizedString()]) { (cell, object, indexPath) in
            cell.textLabel?.text = object
            cell.tintColor = .clear
            cell.selectionStyle = .none
            cell.accessoryType = .none
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.textAlignment = .center
        }
        selectionMenu.tableView?.isScrollEnabled = false
        
        
        let widthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
        widthLabel.font = UIFont.systemFont(ofSize: 14)
        widthLabel.text = LocalizedStrings.show_test_servers.localizedString()
        widthLabel.sizeToFit()
        
        selectionMenu.show(style: .Popover(sourceView: self.menuAnchor, size: CGSize(width: widthLabel.bounds.width + 60, height: 44)), from: self)
        
//        selectionMenu.show(style: .Actionsheet(title: nil, action: nil, height: 100), from: self)
        
        
        
        selectionMenu.onDismiss = {items in
            self.isTest = !self.isTest
            self.collectionView?.reloadSections(IndexSet(integer: 0))
            
        }
    }
    
    
    @objc func didTapCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ServiceSelectorViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isTest ? testServices?.count ?? 0 :  services?.count ?? 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ServiceCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ServiceCollectionViewCell
        let service = isTest ? testServices?[indexPath.row] : services?[indexPath.row]
        cell.loadWithService(service: service)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let width = collectionView.bounds.width / 3.0 - 12.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let delegate = self.delegate, let service = isTest ? testServices?[indexPath.row] : services?[indexPath.row] else{
            return
        }
        
        if service.isIOSEnabled ?? true == false{
            AlertDialogFactory.showBasicAlertFromViewController(vc: self, title: LocalizedStrings.btn_select_service_empty.localizedString(), message: LocalizedStrings.alert_error_service_selector_ios_not_enabled.localizedString(), doneButtonTitle: LocalizedStrings.ok.localizedString(), doneButtonAction: nil)
        }else{
            self.dismiss(animated: true) {
                delegate.didSelectService(service: service)
            }
        }
        
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
}
