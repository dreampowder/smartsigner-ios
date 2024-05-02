//
//  TransferSourceActionViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 21.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class TransferSourceActionViewController: UIViewController {

    @IBOutlet weak var collectionView:UICollectionView?
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var lblMessage:UILabel?
    @IBOutlet weak var shadowView:MDCShadowView?
    
    var parentVC:UIViewController?
    var isShowingForDistributionFlow = false
    
    let imageArray:[FontAwesomeType] = [FontAwesomeType.building,FontAwesomeType.user,FontAwesomeType.expand_arrows]
    let titleArray:[LocalizedStrings] = [.transfer_source_depoartment,.transfer_source_user,.transfer_source_distribution]
    
    var alertTitle = LocalizedStrings.transfer_source_alert_title.localizedString()
    var alertContent = LocalizedStrings.transfer_source_alert_message.localizedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(UINib(nibName: "DepartmentSourceCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "Cell")
        self.lblTitle?.text = alertTitle
        self.lblMessage?.text = alertContent
        self.shadowView?.backgroundColor = .tableviewBackground
        self.collectionView?.backgroundColor = .tableviewBackground
        self.view.backgroundColor = .clear
    }
}

extension TransferSourceActionViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isShowingForDistributionFlow ? 2 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let iconLabel = cell.contentView.viewWithTag(1000) as? UILabel
        iconLabel?.attributedText = Utilities.getIconString(icon: imageArray[indexPath.row], size: 40, color: .primaryTextColor)
        
        let titleLabel = cell.contentView.viewWithTag(2000) as? UILabel
        titleLabel?.text = titleArray[indexPath.row].localizedString()
        
        let card = cell.contentView.viewWithTag(9999) as! MDCCard
        ThemeManager.applyCardTheme(card: card)
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/3, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            switch indexPath.row {
            case 0: //Dpartmenr
                let vc = AddTransferByDepartmentViewController()
                self.parentVC?.present(vc, animated: true, completion: nil)
            case 1: //User
                let vc = AddTransferByUserViewController()
                self.parentVC?.present(vc, animated: true, completion: nil)
            case 2:
                let vc = AddTransfersByDistributionViewController()
                let navCon = UINavigationController(rootViewController: vc)
                navCon.setNavigationBarHidden(true, animated: false)
                self.parentVC?.present(navCon, animated: true, completion: nil)
            default:
                return
            }
        }
    }
}
