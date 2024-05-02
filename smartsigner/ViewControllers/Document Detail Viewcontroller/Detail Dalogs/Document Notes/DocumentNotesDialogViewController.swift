//
//  DocumentNotesDialogViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 25.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class DocumentNotesDialogViewController: UITableViewController {

    var notes:[DocumentNote]?
    var appBarViewController:MDCAppBarViewController = MDCAppBarViewController()
    var didLayoutSubviews = false
    convenience init(notes:[DocumentNote]) {
        self.init(style: .plain)
        self.notes = notes
    }
    
    
    func commonInit(){
        appBarViewController.inferTopSafeAreaInsetFromViewController = true
        appBarViewController.headerView.minMaxHeightIncludesSafeArea = false
        
        // Step 2: Add the headerViewController as a child.
        self.addChild(appBarViewController)
        // Allows us to avoid forwarding events, but means we can't enable shift behaviors.
        appBarViewController.headerView.observesTrackingScrollViewScrollEvents = true
        
        // Recommended step: Set the tracking scroll view.
        appBarViewController.headerView.trackingScrollView = self.tableView
        
        // Step 2: Register the App Bar views.
        view.addSubview(appBarViewController.view)
        appBarViewController.didMove(toParent: self)
        
        ThemeManager.applyAppBarTheme(appBar: self.appBarViewController)
    }
    
    override func viewDidLayoutSubviews() {
        if !didLayoutSubviews {
//            self.navigationController?.setNavigationBarHidden(true, animated: false)
            didLayoutSubviews = true
//            let screenSize = UIScreen.main.bounds.size
//            self.preferredContentSize = CGSize(width: screenSize.width * 0.8 , height: screenSize.height*0.7)
            //commonInit()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "DocumentNoteTableViewCell", bundle: .main), forCellReuseIdentifier: "Cell")
        self.view.layer.cornerRadius = 4.0
        self.view.clipsToBounds = true
        self.appBarViewController.navigationBar.title = "Notlar"
        let barBtnClose = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        self.navigationController?.navigationItem.rightBarButtonItem = barBtnClose
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DocumentNoteTableViewCell
        let note = self.notes?[indexPath.row]
        
        cell.loadWithNote(note: note!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
