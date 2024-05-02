//
//  DocumetHistoryTableViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 14.10.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit

class DocumetHistoryTableViewController: UITableViewController {

    var histories:[DocumentHistory]?
    
    convenience init(histories:[DocumentHistory]) {
        self.init(style: .plain)
        self.histories = histories;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "DocumentHistoryTableViewCell", bundle: .main), forCellReuseIdentifier: "Cell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.histories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DocumentHistoryTableViewCell
        let history = self.histories?[indexPath.row]
        cell.loadCell(history: history!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
