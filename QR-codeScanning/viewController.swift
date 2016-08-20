//
//  viewController.swift
//  QR-codeScanning
//
//  Created by 黄启明 on 16/8/20.
//  Copyright © 2016年 huatengIOT. All rights reserved.
//

import UIKit

class viewController: UIViewController {
    var scanView: QMScanRectView?
    
    override func viewDidLoad() {
        scanView = QMScanRectView()
        scanView?.frame = view.bounds
        view.addSubview(scanView!)
        view.bringSubviewToFront(scanView!)
        scanView?.setupScanImgUI()
        scanView?.beginAnimation()
    }
}
