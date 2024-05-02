//
//  DocumentAttachmentTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 25.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class DocumentAttachmentTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var collectionView:UICollectionView?
    @IBOutlet weak var heightConstraint:NSLayoutConstraint?
    
    var attachments:[DocumentAttachment]?
    var isRelated = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView?.register(UINib(nibName: "AttachmentItemCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "Cell")
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        self.collectionView?.backgroundColor = .clear
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadWithAttachments(attachments:[DocumentAttachment]?){
        isRelated = false
        self.lblTitle?.text = LocalizedStrings.document_attachments.localizedString()
        self.attachments = attachments
        self.collectionView?.reloadData()
        self.lblTitle?.isHidden = attachments?.count ?? 0 == 0
    }
    
    func loadWithRelateds(relatedItems:[DocumentRelated]?){
        isRelated = true
        self.lblTitle?.text = LocalizedStrings.document_related.localizedString()
        attachments = relatedItems?.map({$0.getAttachmentItem()}) ?? []
        self.lblTitle?.isHidden = attachments?.count ?? 0 == 0
        self.collectionView?.reloadData()
    }
}

extension DocumentAttachmentTableViewCell:UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.attachments?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let attachment = self.attachments?[indexPath.row]
        let cell:AttachmentItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AttachmentItemCollectionViewCell
        
        cell.lblTitle?.text = attachment?.name
        cell.lblSubtitle?.text = attachment?.fileExtension
        cell.imgAttachment?.image = UIImage(awesomeType: Utilities.getAttachmentType(filename: attachment?.name ?? ""), size: 30, textColor: .darkGray)?.withRenderingMode(.alwaysTemplate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let attachment = self.attachments?[indexPath.row]
        let height:CGFloat = CGFloat(collectionView.bounds.height)
        let labelWidth = attachment?.name.width(withConstrainedHeight: height, font: UIFont.systemFont(ofSize: 14)) ?? 100
        let totalWidth:CGFloat = (height - 8.0) + labelWidth + 28
        return CGSize(width: totalWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let attachment = self.attachments?[indexPath.row]{
            Observers.did_select_attachment.post(userInfo: [Observers.keys.selected_attachment : attachment, Observers.keys.is_related:isRelated])
        }
    }
}
