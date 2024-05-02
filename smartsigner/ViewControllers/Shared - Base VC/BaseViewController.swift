//
//  BaseViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 27.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
class BaseViewController: UIViewController {

    var appBarViewController:MDCAppBarViewController = MDCAppBarViewController()
    var didLayoutSubviews = false
    
    var subViewLayoutBlock:(()->Void)?
    
    override func viewDidLayoutSubviews() {
        if !didLayoutSubviews {
            didLayoutSubviews = true
            subViewLayoutBlock?()
        }
    }
    
    func commonInit(trackingScrollView:UIScrollView?){
        appBarViewController.inferTopSafeAreaInsetFromViewController = true
        appBarViewController.headerView.minMaxHeightIncludesSafeArea = false
        appBarViewController.headerView.maximumHeight = 40
        // Step 2: Add the headerViewController as a child.
        self.addChild(appBarViewController)
        // Allows us to avoid forwarding events, but means we can't enable shift behaviors.
        appBarViewController.headerView.observesTrackingScrollViewScrollEvents = true
        
        // Recommended step: Set the tracking scroll view.
        appBarViewController.headerView.trackingScrollView = trackingScrollView
        
        // Step 2: Register the App Bar views.
        var frame = appBarViewController.view.frame
        frame.size.width = self.view.bounds.width
        appBarViewController.view.frame = frame
        view.addSubview(appBarViewController.view)
        appBarViewController.didMove(toParent: self)
        
        ThemeManager.applyAppBarTheme(appBar: self.appBarViewController)
    }
    
    /*
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            print("Collection did change: \(UITraitCollection.current.userInterfaceStyle.rawValue)")
            guard previousTraitCollection?.userInterfaceStyle != UITraitCollection.current.userInterfaceStyle else{
                return
            }
            ThemeManager.applyAppBarTheme(appBar: self.appBarViewController)
            self.appBarViewController.view.setNeedsDisplay()
            self.view.subviews.forEach { (view) in
                if let tableView = view as? UITableView{
                    tableView.reloadData()
                }else if let collectionView = view as? UICollectionView{
                    collectionView.reloadData()
                }
            }
            
        } else {
            // Fallback on earlier versions
        }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
}
