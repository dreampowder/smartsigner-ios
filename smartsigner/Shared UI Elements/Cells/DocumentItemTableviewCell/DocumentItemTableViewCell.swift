//
//  DocumentItemTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 23.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class DocumentItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblFrom:UILabel?
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var lblContent:UILabel?
    @IBOutlet weak var lblDate:UILabel?
    @IBOutlet weak var lblType:UILabel?
    @IBOutlet weak var imgRead:UIImageView?
    @IBOutlet weak var collectionView:UICollectionView?
    @IBOutlet weak var collectionViewHeight:NSLayoutConstraint?
    @IBOutlet weak var viewBatchSelectionIndicator:UIView?
    
    var dateFormatter = DateFormatter()
    var dfRead = DateFormatter()
    var imageArray:[UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        dfRead.dateFormat = "dd.MM.yyyy HH:mm"
        
        self.imgRead?.layer.cornerRadius = 6.0
        self.imgRead?.layer.masksToBounds = true
        self.imgRead?.backgroundColor = .primaryColor
        
        self.collectionView?.register(UINib(nibName: "DocumentIconCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "Cell")
        self.viewBatchSelectionIndicator?.backgroundColor = .primaryColor
        self.viewBatchSelectionIndicator?.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func load(documentItem:PoolItem,
              tableViewState:MainTableViewState? = nil,
              isSelectedForBatch:Bool = false){
        
        let fontWeight:UIFont.Weight = documentItem.isRead ? .regular : .semibold
        
        self.lblFrom?.text = documentItem.fromSentence
        self.lblTitle?.text = documentItem.subject
        
        self.lblTitle?.font = UIFont.systemFont(ofSize: self.lblTitle?.font.pointSize ?? 14, weight: fontWeight)
        self.lblFrom?.font = UIFont.systemFont(ofSize: self.lblFrom?.font.pointSize ?? 14, weight: fontWeight)
        
        self.lblContent?.text = documentItem.toSentence
        self.lblType?.text = documentItem.poolTypeEnumString
        self.lblDate?.text = self.dateFormatter.string(from: self.dfRead.date(from: documentItem.sentDateAsString)!)
        self.imgRead?.isHidden = documentItem.isRead
        self.generateImageArray(documentItem:documentItem)
        self.imgRead?.backgroundColor = .primaryColor
        //Batch Operation Update
        self.viewBatchSelectionIndicator?.isHidden = true
        guard let state = tableViewState, !state.isNormal() else{
            self.contentView.alpha = 1.0
            return
        }
        
        let documentBatchType = BatchOperationType.getBatchType(poolTypeEnum: documentItem.poolTypeEnumNameAsString)
        var willDisableCell = false
        switch state {
        case .batch(let batchType):
            willDisableCell = documentBatchType != batchType
        default:
            print("none")
        }
        
        if willDisableCell {
            self.contentView.alpha = 0.30
        }else{
            self.contentView.alpha = 1.0
            self.imgRead?.isHidden = false
            self.viewBatchSelectionIndicator?.isHidden = !isSelectedForBatch
            
            self.imgRead?.backgroundColor = .white
            
        }
    }

    
    func generateImageArray(documentItem:PoolItem?){
        var tempArray:[UIImage] = []
        guard let item = documentItem else{
            return
        }
        let imageSize:CGFloat = CGFloat(24)
        let imageColor:UIColor = .secondaryTextColor
        
        if item.hasAttachment{
            let image = UIImage(awesomeType: .paperclip, size: imageSize, textColor: imageColor)
            tempArray.append(image!)
        }
        
        if item.hasNote{
            let image = UIImage(awesomeType: .stickyNote, size: imageSize, textColor: imageColor)
            tempArray.append(image!)
        }
        
        if item.isTopSecret{
            let image = UIImage(awesomeType: .lock, size: imageSize, textColor: imageColor)
            tempArray.append(image!)
        }
        if item.isSigned{
            let image = UIImage(awesomeType: .pencilSquare, size: imageSize, textColor: imageColor)
            tempArray.append(image!)
        }
        
        
        self.imageArray = tempArray
        
        let attrTest = NSMutableAttributedString(string: "\(documentItem?.poolTypeEnumString ?? "")")
        let attrLineBreak = NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 8)])
        attrTest.append(attrLineBreak)
        for image in self.imageArray{
            let attachment = NSTextAttachment()
            attachment.image = image
            attachment.setImageHeight(height: 14)
            let attrImage = NSAttributedString(attachment: attachment)
            attrTest.append(attrImage)
//            attrTest.addAttribute(NSAttributedString.Key.baselineOffset, value: -1 * (self.lblType?.font.pointSize ?? 12 - 14) / 2.0, range: NSMakeRange(attrTest.length-1, 1))
            attrTest.append(NSAttributedString(string:" "))
            
        }
        self.lblType?.attributedText = attrTest
        
        self.collectionView?.reloadData()
    }

}

extension DocumentItemTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:DocumentIconCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DocumentIconCollectionViewCell

        cell.imageView?.image = self.imageArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewHeight?.constant ?? 30, height: self.collectionViewHeight?.constant ?? 30)
    }
}
