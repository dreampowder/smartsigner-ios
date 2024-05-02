//
//  DistributionDetailViewController.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 7.02.2020.
//  Copyright © 2020 Seneka. All rights reserved.
//

import UIKit



class DistributionDetailViewController: BaseViewController {

    var distributions:[DaDistribution] = []
    var willShowCopyButton = false
    @IBOutlet weak var tableView:UITableView?
    
    convenience init(distributions:[DaDistribution], willShowCopyButton:Bool) {
        self.init(nibName: DistributionDetailViewController.getNibName(), bundle: .main)
        self.distributions = distributions
        self.willShowCopyButton = willShowCopyButton
    }
    
    override func viewDidLayoutSubviews() {
        if !didLayoutSubviews{
            didLayoutSubviews = true
            self.tableView?.backgroundColor = .tableviewBackground
            self.view.backgroundColor = .tableviewBackground
            self.tableView?.separatorStyle = .none
            commonInit(trackingScrollView: self.tableView)
            
            if willShowCopyButton && self.distributions.count > 0{
                let btnShow = UIBarButtonItem(title: LocalizedStrings.da_flow_btn_copy.localizedString(), style: .done, target: self, action: #selector(didTapCopyButton))
                self.navigationItem.rightBarButtonItem = btnShow
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.register(UINib(nibName: "DistributionFlowDetailTableViewCell", bundle: .main), forCellReuseIdentifier: "DistributionCell")
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.reloadData()
    }
    
    @objc func didTapCopyButton(){
        navigationController?.popViewController(animated: true)
        Observers.distribution_flow_copy_action.post(userInfo: [Observers.keys.distribution_items :self.distributions])
    }
    
}

extension DistributionDetailViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return distributions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DistributionCell", for: indexPath) as! DistributionFlowDetailTableViewCell
        cell.load(distribution: self.distributions[indexPath.row])
        return cell
    }
}
