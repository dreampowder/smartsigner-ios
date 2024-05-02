//
//  DocumentVersionsTableViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 14.10.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit

class DocumentVersionsTableViewController: UITableViewController {

    var versions:[DocumentVersion]?
    
    convenience init(versions:[DocumentVersion]) {
        self.init(style: .plain)
        self.versions = versions
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "DocumentVersionTableViewCell", bundle: .main), forCellReuseIdentifier: "Cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.versions?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DocumentVersionTableViewCell
        let version = self.versions?[indexPath.row]
        cell.loadCell(version: version!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
