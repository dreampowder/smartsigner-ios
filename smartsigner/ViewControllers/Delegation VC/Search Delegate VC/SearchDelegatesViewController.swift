//
//  SearchDelegatesViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 18.10.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents

class SearchDelegatesViewController: BaseViewController {

    @IBOutlet weak var tableView:UITableView?

    var searchHeaderView:DelegateSearchHeaderView?
    
    var delegations:[DelegationItem] = []
    
    deinit {
        Observers.delegate_search_select.removeObserver(observer: self)
    }
    
    convenience init() {
        self.init(nibName: "SearchDelegatesViewController", bundle: .main)
        self.subViewLayoutBlock = {
            self.commonInit(trackingScrollView: self.tableView)
            if self.searchHeaderView == nil{
                self.searchHeaderView = DelegateSearchHeaderView.instantinateView(parentVC: self)
                self.searchHeaderView?.delegate = self
                self.tableView?.tableHeaderView = self.searchHeaderView
                self.tableView?.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 180)
                self.tableView?.layoutIfNeeded()
                self.tableView?.separatorStyle = .none
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        extendedLayoutIncludesOpaqueBars = true
        
        
        self.tableView?.backgroundColor = .white
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        
        self.title = LocalizedStrings.delegate_tabbar_title_search.localizedString()
        
        self.tableView?.register(UINib(nibName: "DelegateTableViewCell", bundle: .main), forCellReuseIdentifier: "Cell")
        
        let barBtnAdd = UIBarButtonItem(image: UIImage(awesomeType: .plusCircle, size: 10, textColor: .white), style: .done, target: self, action: #selector(self.didTapAddButton))
        self.navigationItem.rightBarButtonItem = barBtnAdd
        
        self.tableView?.backgroundColor = UIColor.tableviewBackground
    }
    
    @objc func didTapAddButton(){
        let vc = GiveDelegateViewController()
        let navCon = UINavigationController(rootViewController: vc)
        navCon.navigationBar.isHidden = true
        self.present(navCon, animated: true, completion: nil)
    }
}

extension SearchDelegatesViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.delegations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DelegateTableViewCell
        let delegation = self.delegations[indexPath.row]
        cell.load(delegateItem: delegation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
}

extension SearchDelegatesViewController:UISearchControllerDelegate{
    func willPresentSearchController(_ searchController: UISearchController) {
        var searchString = searchController.searchBar.text ?? ""
        var willReplaceText = false
        if searchString.hasPrefix("\(LocalizedStrings.delegate_search_delegate_name_placeholder.localizedString()):") {
            searchString =  searchString.replacingOccurrences(of: "\(LocalizedStrings.delegate_search_delegate_name_placeholder.localizedString()):", with: "")
            willReplaceText = true
        }
        
        if searchString.hasPrefix("\(LocalizedStrings.delegate_search_main_name_placeholder.localizedString()):") {
            searchString = searchString.replacingOccurrences(of: "\(LocalizedStrings.delegate_search_main_name_placeholder.localizedString()):", with: "")
            willReplaceText = true
        }
        
        if willReplaceText {
            searchController.searchBar.text = searchString
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        let searchString = searchController.searchBar.text ?? ""
        if searchString.count == 0 { //Cancel etmişiz
            if searchController == self.searchHeaderView?.searchControllerDelegate{
                self.searchHeaderView?.selectedDelegate = nil
            }else if searchController == self.searchHeaderView?.searchControllerMainUser{
                self.searchHeaderView?.selectedMainUser = nil
            }
        }
    }
}

extension SearchDelegatesViewController:SearchHeaderDelegate{
    func didTapShowDatePicker(selectedDate: Date?) {
        self.showDatePicker(sourceView: "DelegateSearchHeaderView", selectedDate: selectedDate)
    }
    
    func didTapSearch(searchRequest: ListDelegateRequest) {
        let dialog = showProgressDialog(title: LocalizedStrings.delegate_tabbar_title_search, message: .empty_string)
        ApiClient.delegate_list(request: searchRequest)
            .execute { (_ response:ListDelegateResponse?, error, statusCode) in
                dialog?.dismiss(animated: true, completion: {
                    Utilities.processApiResponse(parentViewController: self, response: response) {
                        self.delegations = response?.delegationItems ?? []
                        self.tableView?.reloadData()
                    }
                })
                
        }
    }
}


