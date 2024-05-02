//
//  DistributionFlowSideMenuViewController.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 11.02.2020.
//  Copyright © 2020 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents


protocol FlowSideMenuDelegate {
    func didTapApply(menuState:[FlowSideMenuItemType:Bool], willFetchDistributions:Bool)
    func didTapcancel()
}

class DistributionFlowSideMenuViewController: UIViewController {

    var menuState:[FlowSideMenuItemType:Bool] = [:]
    
    @IBOutlet weak var constSideMenuLeft:NSLayoutConstraint!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var constTableViewWidth:NSLayoutConstraint!
    @IBOutlet weak var btnCancel:MDCButton!
//    @IBOutlet weak var btnApply:MDCButton!
    @IBOutlet weak var viewContainer:UIView!
    
    
    let widthPercent = 0.80
    var didLayoutSubViews = false
    var delegate:FlowSideMenuDelegate?
    
    convenience init(menuState:[FlowSideMenuItemType:Bool]) {
        self.init(nibName: "DistributionFlowSideMenuViewController", bundle: .main)
        self.menuState = menuState
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.constTableViewWidth.constant = UIScreen.main.bounds.width * CGFloat(widthPercent)
        self.constSideMenuLeft.constant = -1 *  UIScreen.main.bounds.width * CGFloat(widthPercent)
    }
    
    override func viewDidLayoutSubviews() {
        if !didLayoutSubViews{
            didLayoutSubViews = true
            self.tableView.separatorStyle = .none
            self.tableView.backgroundColor = UIColor.tableviewBackground
            self.viewContainer.backgroundColor = .tableviewBackground
            self.btnCancel.setTitle(LocalizedStrings.close.localizedString(), for: .normal)
            ThemeManager.applyButtonColorTheme(button: self.btnCancel)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSideMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "FlowSideMenuTableViewCell", bundle: .main), forCellReuseIdentifier: "Cell")
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOutSide))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapOutSide(){
        hideSideMenu()
    }
    
    func showSideMenu(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.constSideMenuLeft.constant = 0
            self.view.layoutIfNeeded()
        }) { (complete) in
            if complete{

            }
        }
    }
    
    func hideSideMenu(){
        UIView.animate(withDuration: 0.25, animations: {
            self.constSideMenuLeft.constant = -1 *  UIScreen.main.bounds.width * CGFloat(self.widthPercent)
            self.view.backgroundColor = UIColor.clear
            self.view.layoutIfNeeded()
        }) { (complete) in
            if complete{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func didTapCancel(){
        self.delegate?.didTapcancel()
        hideSideMenu()
    }
    
    @IBAction func didTapApply(){
        print("apply")
        self.delegate?.didTapApply(menuState: self.menuState, willFetchDistributions: true)
        hideSideMenu()
    }

}

extension DistributionFlowSideMenuViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FlowSideMenuItemType.getAllItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FlowSideMenuTableViewCell
        let type = FlowSideMenuItemType.getAllItems()[indexPath.row]
        cell.load(title: type.getString().localizedString(), isSelected: self.menuState[type] ?? false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = FlowSideMenuItemType.getAllItems()[indexPath.row]
        if menuState.keys.contains(type){
            menuState[type] = !menuState[type]!
        }else{
            menuState[type] = true
        }
        if let settingEnum = type.getSettingEnum() {
            SessionManager.current.setUserSetting(settingType: settingEnum, value: menuState[type])
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        self.delegate?.didTapApply(menuState: self.menuState, willFetchDistributions: type == .show_connected_departments)
    }
}

extension DistributionFlowSideMenuViewController:UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
