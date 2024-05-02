//
//  SearchDocumentTableViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 27.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit

class SearchDocumentTableViewController: BaseViewController {

    let minimisedHeight:CGFloat = 48
    let maximisedHeight:CGFloat = 220
    var searchHeader :SearchHeader? = Bundle.main.loadNibNamed("SearchHeader", owner: nil, options: nil)?.first as? SearchHeader
    
    @IBOutlet weak var tableView:UITableView?
    
    var isAdvancedSearchOpen = false
    var currentPage = 1
    var isFetchingData = false
    var documents:[PoolItem] = []
    var currentSearchObject:SearchObject?
    
    deinit {
        Observers.document_remove.removeObserver(observer: self)
    }
    
    convenience init() {
     self.init(nibName: "SearchDocumentTableViewController", bundle: .main)
     self.commonInit(trackingScrollView: self.tableView)
        self.subViewLayoutBlock = {
            let headerView = self.appBarViewController.headerView
            headerView.trackingScrollView = self.tableView
            headerView.maximumHeight = self.minimisedHeight
            headerView.minimumHeight = self.minimisedHeight
            headerView.backgroundColor = .primaryColor
            if let searchHeader = self.searchHeader{
                searchHeader.backgroundColor = .primaryColor
                searchHeader.frame = headerView.bounds
                searchHeader.autoresizingMask = [.flexibleWidth,.flexibleHeight]
                headerView.addSubview(searchHeader)
                searchHeader.btnToggleSearch?.addTarget(self, action: #selector(self.didTapAdvancedSearch), for: .touchUpInside)
                searchHeader.delegate = self
            }
            self.navigationItem.hidesBackButton = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.register(UINib(nibName: "DocumentItemTableViewCell", bundle: .main), forCellReuseIdentifier: "Cell")
        self.tableView?.register(UINib(nibName: "LoadingIndicatorTableViewCell", bundle: .main), forCellReuseIdentifier: "Cell-Loading")
        Observers.document_remove.addObserver(observer: self, selector: #selector(didReceiveRemoveDocumentNotification(notification:)))
    }

    @objc func didTapAdvancedSearch(){
        let targetHeight:CGFloat = isAdvancedSearchOpen ? minimisedHeight : maximisedHeight
        isAdvancedSearchOpen = !isAdvancedSearchOpen;
        UIView.animate(withDuration: 0.25, animations: {
            self.appBarViewController.headerView.minimumHeight = self.minimisedHeight
            self.appBarViewController.headerView.maximumHeight = targetHeight
            self.view.layoutIfNeeded()
            self.searchHeader?.toggleAdvancedSearch(isOpen: self.isAdvancedSearchOpen)
        }) { (complete) in
            if complete{
                if self.isAdvancedSearchOpen{
                    self.tableView?.setContentOffset(CGPoint(x:0,y:-1.2*targetHeight), animated: true)
                }
            }
        }
    }
    
    func fetchSearchResults(searchObject:SearchObject, willReset:Bool){
        if willReset{
            self.documents = []
            self.currentPage = 1
        }
        
        isFetchingData = true
        self.tableView?.reloadData()
        ApiClient.search(searchObject: searchObject, page: currentPage)
            .execute { (_ response:FolderContentResponse?, error, statusCode) in
                Utilities.processApiResponse(parentViewController: self, response: response) {
                    var indexPaths:[IndexPath] = []
                    var initialIndex = self.documents.count
                    for document in response?.poolItems ?? []{
                        let doesContain = self.documents.contains(where: { (item) -> Bool in
                            return item.id == document.id
                        })
                        if !doesContain{
                            self.documents.append(document)
                            indexPaths.append(IndexPath(row: initialIndex, section: 0))
                            initialIndex = initialIndex + 1;
                        }
                    }
                    if indexPaths.count > 0{
                        self.tableView?.insertRows(at: indexPaths, with: .automatic)
                    }
                    if response?.poolItems.count ?? 0 == API_PAGE_SIZE{
                        self.currentPage = self.currentPage + 1
                    }
                    self.isFetchingData = false
                    self.tableView?.separatorStyle = .none
                    self.tableView?.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
                }
        }
    }
    
    @objc func didReceiveRemoveDocumentNotification(notification:Notification){
        guard let document = notification.userInfo?[Observers.keys.removed_document.rawValue] as? PoolItem else{
            return
        }
        if let index = self.documents.firstIndex(where: { (item) -> Bool in
            return document.id == item.id
        }){
            self.documents.remove(at: index)
            self.tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
}

extension SearchDocumentTableViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.documents.count
        }else{
            return 1;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DocumentItemTableViewCell
            let document = self.documents[indexPath.row]
            cell.load(documentItem: document)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell-Loading", for: indexPath) as! LoadingIndicatorTableViewCell
            if isFetchingData{
                cell.activityIndicator?.startAnimating()
            }else{
                cell.activityIndicator?.stopAnimating()
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let document = self.documents[indexPath.row]
            let vc = DocumentViewController(document: document)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchDocumentTableViewController:SearchHeaderProtocol{
    func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func didTapDateField(date: Date?, isBeginDate: Bool) {
        showDatePicker(sourceView: "SearchHeader-\(isBeginDate ? "begin" : "end")", selectedDate: date)
    }
    
    
    func didTapSearchButton(searchObject: SearchObject) {
        self.currentSearchObject = searchObject
        self.fetchSearchResults(searchObject: searchObject,willReset: true)
    }
    
    func didTapCancelButton() {
        
    }
}

extension SearchDocumentTableViewController:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let insets = scrollView.contentInset
        let y:CGFloat = offset.y + bounds.height - insets.bottom
        let h:CGFloat = size.height
        let reload_distance:CGFloat = 100
        if (y > h - reload_distance && self.documents.count >= API_PAGE_SIZE){
            if !isFetchingData{
                print("Fetching timeline")
                if let search = self.currentSearchObject{
                    self.fetchSearchResults(searchObject: search, willReset: false)
                }
            }
        }
    }
}
