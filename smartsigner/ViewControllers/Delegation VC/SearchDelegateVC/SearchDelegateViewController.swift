//
//  SearchDelegateViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 3.12.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class SearchDelegateViewController: BaseViewController {

    @IBOutlet weak var viewSearchContainer:UIView?
    @IBOutlet weak var constSearchheaderTop:NSLayoutConstraint?
    @IBOutlet weak var searchBar:UISearchBar?
    @IBOutlet weak var tableView:UITableView?
    
    var searchResult:SearchUserResponse?
    
    var model:GiveDelegateModel = GiveDelegateModel()
    var isDelegate:Bool = false
    var willShowEmptyData = false
    
    convenience init(model:GiveDelegateModel, isDelegate:Bool) {
        self.init(nibName: "SearchDelegateViewController", bundle: .main)
        self.model = model
        self.isDelegate = isDelegate
        commonInit(trackingScrollView: nil)
        self.subViewLayoutBlock = {
            self.searchBar?.delegate = self
            self.constSearchheaderTop?.constant = self.appBarViewController.view.bounds.height
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSearchContainer?.backgroundColor = UIColor.primaryColor
        self.searchBar?.backgroundColor = UIColor.primaryColor
        
        definesPresentationContext = true
        extendedLayoutIncludesOpaqueBars = true
        self.title = LocalizedStrings.user_search_title.localizedString()
        let barBtnCancel = UIBarButtonItem(title: LocalizedStrings.close.localizedString(), style: .done, target: self, action: #selector(didTapCancelButon))
        self.navigationItem.leftBarButtonItem = barBtnCancel
        self.tableView?.emptyDataSetSource = self
        self.tableView?.emptyDataSetDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchBar?.becomeFirstResponder()
    }
    
    @objc func didTapCancelButon(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchUser(query:String?){
        
            ApiClient.delegate_search_user(searchQuery: query)
                .execute { (_ response:SearchUserResponse?, error, statusCode) in
                    self.willShowEmptyData = true
                    self.searchResult = response
//                    self.tableView?.separatorStyle = self.searchResult?.users.count == 0 ? .none : .singleLine
                    self.tableView?.reloadData()
                    self.tableView?.reloadEmptyDataSet()
            }
    }
}

extension SearchDelegateViewController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3{
            self.searchUser(query: searchText)
        }else{
            self.searchResult = nil
            self.tableView?.separatorStyle = .none
            self.tableView?.reloadData()
        }
    }
    
}

extension SearchDelegateViewController:UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResult?.users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        let user = self.searchResult?.users[indexPath.row]
        cell?.textLabel?.text = "\(user?.name ?? "") \(user?.surname ?? "-")"
        cell?.detailTextLabel?.text = user?.departmentName ?? ""
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        
        guard let user = self.searchResult?.users[indexPath.row]  else{
            return
        }
        if !isDelegate{
            model.mainUser = user
        }else{
            model.delegateUser = user
        }
        Observers.delegate_search_select.post(userInfo: [Observers.keys.give_delegate_model : model])
    }
}

extension SearchDelegateViewController:EmptyDataSetSource,EmptyDataSetDelegate{
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return self.searchBar?.text?.count ?? 0 >= 3 && willShowEmptyData == true && self.searchResult?.users.count == 0
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: String.fa.fontAwesome(FontAwesomeType.user), attributes: [NSAttributedString.Key.font : UIFont.fa?.fontSize(16),NSAttributedString.Key.foregroundColor:UIColor.darkGray])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?{
        return NSAttributedString(string: LocalizedStrings.delegate_search_not_found.localizedString())
    }
}
