//
//  TaskUserListTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 21.11.2019.
//  Copyright © 2019 Seneka. All rights reserved.
//

import UIKit

class TaskUserListTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var lblTitle:UILabel!
    
    var users:[TaskNoteUser] = []
    var widthMap:[String:CGFloat] = [:]
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "TaskUserCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "Cell")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8.0, bottom: 0, right: 8.0)
        let attrTitle = NSMutableAttributedString(string: String.fa.fontAwesome(.user), attributes: [NSAttributedString.Key.font:UIFont.fa?.fontSize(14), NSAttributedString.Key.foregroundColor : UIColor.primaryTextColor])
        attrTitle.append(NSAttributedString(string: " \(LocalizedStrings.task_users.localizedString())"))
        lblTitle.attributedText = attrTitle
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func load(users:[TaskNoteUser]){
        self.users = users
        self.collectionView.reloadData()
    }
    
}

extension TaskUserListTableViewCell:UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TaskUserCollectionViewCell
        cell.load(user: users[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let user = users[indexPath.row]
        var width:CGFloat = widthMap[user.userFullName ?? ""] ?? CGFloat(0.0);
        if width == CGFloat(0.0) {
            let userStr = NSString(string: user.userFullName ?? "")
            width = userStr.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17.0)]).width * 1.25
            widthMap[user.userFullName ?? ""] = width + 30 + 16
        }
        return CGSize(width: widthMap[user.userFullName ?? ""] ?? 100, height: 44.0)
    }
}
