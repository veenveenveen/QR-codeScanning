//
//  QMMainViewController.swift
//  QR-codeScanning
//
//  Created by 黄启明 on 16/8/19.
//  Copyright © 2016年 huatengIOT. All rights reserved.
//

import UIKit

class QMMainViewController: UIViewController, MessageEnabled {

    @IBOutlet weak var messageLable: UILabel!
    
    func returnMessage(textString: String) {
        messageLable.text = textString
        messageLable.sizeToFit()
        //        print("get message")
    }
    
    @IBAction func beginScaning(sender: AnyObject) {
        let cameraViewController = QMCameraViewController(nibName: nil, bundle: nil)
        
        navigationController?.pushViewController(cameraViewController, animated: true)
        cameraViewController.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
