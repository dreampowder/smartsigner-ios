//
//  TransferCellTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 21.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class TransferCellTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView:UIImageView?
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var lblNotes:UILabel?
    @IBOutlet weak var collectionView:UICollectionView?
    @IBOutlet weak var btnRemove:UIButton?
    @IBOutlet weak var card:MDCCard!
    
    var sizingChip:MDCChipView = MDCChipView()
    
    let imageArray:[FontAwesomeType] = [FontAwesomeType.building,FontAwesomeType.user,FontAwesomeType.expand_arrows]
    var transfer:TransferDocumentModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeManager.applyCardTheme(card: card)
        self.lblNotes?.layer.cornerRadius = 4.0
        self.lblNotes?.layer.masksToBounds = true
        let layout = MDCChipCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10.0
        layout.scrollDirection = .horizontal
        self.collectionView?.backgroundColor = .clear
        self.collectionView?.setCollectionViewLayout(layout, animated: false)
        self.collectionView?.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        self.btnRemove?.setTitle(nil, for: .normal)
        self.btnRemove?.setImage(UIImage(awesomeType: FontAwesomeType.timesCircle, size: 30, textColor: .secondaryTextColor), for: .normal)
        self.btnRemove?.backgroundColor = UIColor(white: 0.90, alpha: 1)
        self.btnRemove?.layer.cornerRadius = 15.0
        self.btnRemove?.layer.masksToBounds = true
        self.btnRemove?.tintColor = .darkGray
        self.btnRemove?.addTarget(self, action: #selector(didTapRemoveButton), for: .touchUpInside)
        self.contentView.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapNotes))
        self.lblNotes?.addGestureRecognizer(tapGesture)
        self.lblNotes?.isUserInteractionEnabled = true
    }
    
    @objc func didTapNotes(){
        guard let transfer = self.transfer else{
            return
        }
        Observers.transfer_change_note.post(userInfo: [Observers.keys.selected_item : transfer])
    }

    @objc func didTapRemoveButton(){
        guard let transfer = self.transfer else{
            return
        }
        Observers.transfer_remove_item.post(userInfo: [Observers.keys.selected_item : transfer])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func load(transfer:TransferDocumentModel){
        self.transfer = transfer
        var imageIcon:FontAwesomeType?
        switch transfer.transferSource! {
            case .transfer_source_depoartment:
                imageIcon = .building
            case .transfer_source_user:
                imageIcon = .user
            case .transfer_source_distribution:
                imageIcon = .expand_arrows
        }
        if let icon = imageIcon{
            self.imgView?.image = UIImage(awesomeType: icon, size: 30, textColor: .secondaryTextColor)
        }
        lblTitle?.text = transfer.title
        

        let style = NSMutableParagraphStyle()
        style.alignment = .justified
        style.firstLineHeadIndent = 10
        style.tailIndent = -10
        style.headIndent = 10
        lblNotes?.attributedText = NSAttributedString(string: transfer.notes?.count == 0 ? "-" : transfer.notes ?? "-", attributes: [NSAttributedString.Key.paragraphStyle : style])
        self.collectionView?.reloadData()
    }
}

extension TransferCellTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MDCChipCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MDCChipCollectionViewCell
        if indexPath.row == 0 {
            cell.chipView.titleLabel.text = self.transfer?.type?.stringValue().localizedString()
        }else{
            cell.chipView.titleLabel.text = self.transfer?.urgency?.stringValue().localizedString()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            sizingChip.titleLabel.text = self.transfer?.type?.stringValue().localizedString()
        }else{
            sizingChip.titleLabel.text = self.transfer?.urgency?.stringValue().localizedString()
        }
        return sizingChip.sizeThatFits(collectionView.bounds.size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.transfer else{
            return
        }
        Observers.transfer_change_type_and_urgency.post(userInfo: [Observers.keys.selected_item : item,Observers.keys.transfer_change_type_and_urgency_type : (indexPath.row == 0)])
    }
}
