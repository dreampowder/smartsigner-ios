//
//  BaseNavigationController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 26.05.2019.
//  Copyright © 2019 Seneka. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {


    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
//        print("\(self.visibleViewController) Should orientation: \(self.visibleViewController?.supportedInterfaceOrientations)")
        return self.visibleViewController?.supportedInterfaceOrientations ?? .portrait
//        return .all
    }
    
    override var shouldAutorotate: Bool{
        return true;
        return self.visibleViewController?.shouldAutorotate ?? true
    }
}
