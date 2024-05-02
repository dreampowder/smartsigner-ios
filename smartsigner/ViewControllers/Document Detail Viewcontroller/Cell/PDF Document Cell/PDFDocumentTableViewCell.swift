//
//  PDFDocumentTableViewCell.swift
//  smartsigner
//
//  Created by Serdar Coskun on 25.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import MaterialComponents
import WebKit
class PDFDocumentTableViewCell: UITableViewCell {

    @IBOutlet weak var viewPdfContainer:UIView?
    @IBOutlet weak var progressView:MDCActivityIndicator?
    @IBOutlet weak var heightConstraint:NSLayoutConstraint?
    
    var webView:WKWebView?
    var documentId:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progressView?.radius = 26
        progressView?.strokeWidth = 4
        progressView?.backgroundColor = .clear
        progressView?.setIndicatorMode(.indeterminate, animated: false)
        progressView?.cycleColors  = [.primaryColor,.secondaryColor]
        progressView?.startAnimating()
        Observers.progress_update.addObserver(observer: self, selector: #selector(didReceiveProgressNotification(notification:)))
        
        self.webView = WKWebView(frame: self.viewPdfContainer?.bounds ?? CGRect.zero)
        self.webView?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.webView?.backgroundColor = .lightGray
        self.webView?.navigationDelegate = self
        self.viewPdfContainer?.addSubview(self.webView!)
        self.viewPdfContainer?.bringSubviewToFront(progressView!)
        self.webView?.scrollView.isScrollEnabled = false
        self.webView?.backgroundColor = .clear
        self.webView?.isOpaque = false
        self.webView?.scrollView.backgroundColor = .clear
        self.selectionStyle = .none
//        self.webView?.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadPdfAtUrl(url:URL?, documentId:Int){
        self.documentId = documentId
        
        guard let fileUrl = url else{
            return
        }
        self.progressView?.isHidden = true
        self.webView?.loadFileURL(fileUrl, allowingReadAccessTo: fileUrl)
    }
    @objc func didReceiveProgressNotification(notification:Notification){
        guard   let userInfo = notification.userInfo as? [String:Any],
                let progress = userInfo[Observers.keys.progress_amount.rawValue] as? Progress,
                let documentId = userInfo[Observers.keys.progress_target_id.rawValue] as? Int
                else{
                return
        }
        if self.progressView?.indicatorMode == .indeterminate{
            progressView?.setIndicatorMode(.indeterminate, animated: true)
        }
        if documentId == self.documentId {
            self.progressView?.setProgress(Float(progress.fractionCompleted), animated: false)
        }
    }
}

extension PDFDocumentTableViewCell:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("fail: \(error)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
     print("prodivisonal fail: \(error)")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let webViewSubviews = self.getSubviewsOfView(v: webView)
        for v in webViewSubviews {
            if v.description.range(of:"WKPDFPageNumberIndicator") != nil {
                v.isHidden = true // hide page indicator in upper left
            }
        }
    }
    
    func getSubviewsOfView(v:UIView) -> [UIView] {
        var viewArray = [UIView]()
        for subview in v.subviews {
            viewArray += getSubviewsOfView(v: subview)
            viewArray.append(subview)
        }
        return viewArray
    }
}
