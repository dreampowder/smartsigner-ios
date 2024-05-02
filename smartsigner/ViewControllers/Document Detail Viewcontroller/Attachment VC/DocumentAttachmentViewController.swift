//
//  DocumentAttachmentViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 5.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import WebKit
import QuickLook
class DocumentAttachmentViewController: BaseViewController {

    var attachment:DocumentAttachment?
    var poolId:Int!
    var webView:WKWebView = WKWebView(frame: UIScreen.main.bounds)
    
    var previewItem:URL?;
    
    convenience init(attachment:DocumentAttachment, poolId:Int) {
        self.init(nibName: "DocumentAttachmentViewController", bundle: .main)
        self.poolId = poolId
        self.attachment = attachment
        self.subViewLayoutBlock = {
            self.view.addSubview(self.webView)
            self.commonInit(trackingScrollView: self.webView.scrollView)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.attachment?.name
        loadData()
    }
    
    func loadData(){
        let progress = self.showProgressDialog(title: LocalizedStrings.progress_loading_attachment , message:LocalizedStrings.empty_string)
        ApiClient.document_attachment(attachmentId: (self.attachment?.id)!, poolId: poolId)
            .execute { (content:AttachmentContent?, error, statusCode) in
                Utilities.delay(1, closure: {
                    progress?.dismiss(animated: true, completion: nil)
                    if let c = content{
                        let data = Data(base64Encoded: c.data ?? "")
                        let mimeType = Utilities.getMimeTypeForExtension(fileExtension: self.attachment?.fileExtension)
                        self.webView.load(data!, mimeType: mimeType, characterEncodingName: "UTF-8", baseURL: URL.init(string: "https://www.google.com")!)
                    }
                })
        }
    }
}
