//
//  DepartmentSetupTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 26.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class DepartmentSetupTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var collectionView:UICollectionView?
    
    var sizingChip:MDCChipView = MDCChipView()
    
    var typeNameArray:[LocalizedStrings] =
        [LocalizedStrings.distribution_type_geregi,
         LocalizedStrings.distribution_type_information,
         LocalizedStrings.distribution_type_coordinated,
         LocalizedStrings.distribution_type_do_not_use]
    
    var distributionType:DocumentDistrubutionTypeEnum?
    var department:DepartmentGroupItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = MDCChipCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        collectionView?.setCollectionViewLayout(layout, animated: false)
        collectionView?.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .always
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func load(department:DepartmentGroupItem?){
        self.department = department
        self.lblTitle?.text = department?.name
        self.collectionView?.reloadData()
        self.contentView.alpha = (department?.documentDistributionTypeEnum != 3) ? 1 : 0.4
        
    }
    
    func toggleCell(enabled:Bool){
        UIView.animate(withDuration: 0.25) {
            self.contentView.alpha = enabled ? 1 : 0.4
        }
    }
}

extension DepartmentSetupTableViewCell:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typeNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MDCChipCollectionViewCell
        cell.chipView.titleLabel.text = typeNameArray[indexPath.row].localizedString()
        if indexPath.row == self.department?.documentDistributionTypeEnum{
            cell.chipView.imageView.image = UIImage(awesomeType: FontAwesomeType.checkCircle, size: 10, textColor: .darkText)
        }else{
            cell.chipView.imageView.image = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        sizingChip.titleLabel.text = typeNameArray[indexPath.row].localizedString()
        
        var willAddWidth = false
        if indexPath.row == self.department?.documentDistributionTypeEnum{
            sizingChip.imageView.image = UIImage(awesomeType: .check, size: 10, textColor: .darkText)
            willAddWidth = true
        }else{
            sizingChip.imageView.image = nil
        }
        var size = sizingChip.sizeThatFits(collectionView.bounds.size)
        if willAddWidth {
            size.width = size.width + 8
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let previousIndex = self.department?.documentDistributionTypeEnum ?? 0
        
        self.department?.documentDistributionTypeEnum = indexPath.row

        self.collectionView?.reloadData()
        
        self.toggleCell(enabled: indexPath.row != 3)
        if let department = self.department{
            Observers.transfer_department_group_department_type_update.post(userInfo: [Observers.keys.selected_item : department,Observers.keys.transfer_department_distribution_type:DocumentDistrubutionTypeEnum.allItems[indexPath.row]])
        }
    }
}
