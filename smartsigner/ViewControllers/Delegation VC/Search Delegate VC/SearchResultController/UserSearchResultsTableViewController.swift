//
//  UserSearchResultsTableViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 18.10.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import Alamofire
class UserSearchResultsTableViewController: UITableViewController {

    var searchResult:SearchUserResponse?
    var searchController:UISearchController?
    
    convenience init() {
        self.init(style: .plain)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func searchUserForSearchbar(query:String, searchController:UISearchController?){
//        ApiClient.cancelAllRequests { () -> Void? in
            ApiClient.delegate_search_user(searchQuery: query)
                .execute { (_ response:SearchUserResponse?, error, statusCode) in
                    Utilities.processApiResponse(parentViewController: self, response: response) {
                        self.searchResult = response
                        self.tableView.reloadData()
                    }
            }
//        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResult?.users.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        let user = self.searchResult?.users[indexPath.row]
        cell?.textLabel?.text = "\(user?.name ?? "") \(user?.surname ?? "-")"
        cell?.detailTextLabel?.text = user?.departmentName ?? ""
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        
        guard let searchCon = self.searchController, let user = self.searchResult?.users[indexPath.row]  else{
            return
        }
        Observers.delegate_search_select.post(userInfo: [Observers.keys.selected_user :user,Observers.keys.search_controller:searchCon])
    }
}

extension UserSearchResultsTableViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if self.searchController == nil {
            self.searchController = searchController
        }
        let searchString = searchController.searchBar.text ?? ""
        if searchString.count >= 3 {
            self.searchUserForSearchbar(query: searchString, searchController: searchController)
        }else{
            self.searchResult = nil
            self.tableView.reloadData()
        }
    }
}
