//
//  QMMainViewController.swift
//  QR-codeScanning
//
//  Created by 黄启明 on 16/8/19.
//  Copyright © 2016年 huatengIOT. All rights reserved.
//

import UIKit

class QMMainViewController: UIViewController, MessageEnabled, backEnabled, URLGet {
    
    func transferURL() -> String? {
        return messageLable.text
    }
    
    @IBOutlet weak var messageLable: UILabel!
    
    @IBOutlet weak var clickEnabledLable: UILabel!
    func returnMessage(textString: String) {
        
        navigationController?.navigationBar.hidden = false
        
        messageLable.text = textString
        messageLable.sizeToFit()
        
        guard let message = messageLable.text else {
            return
        }
        if message.hasPrefix("http://") || message.hasPrefix("https://") {
            clickEnabledLable.hidden = false
        }
        else {
            clickEnabledLable.hidden = true
        }
        
        messageLable.userInteractionEnabled = true
        
    }
    
    func backToFront() {
        navigationController?.navigationBar.hidden = false
//        navigationController?.navigationBar.hidden = false
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let message = messageLable.text else {
            return
        }
        if message.hasPrefix("http://") || message.hasPrefix("https://") {
            clickEnabledLable.hidden = false
            let touch = touches.first
            guard let points = touch?.locationInView(view) else {
                return
            }
            if (points.x >= messageLable.frame.origin.x && points.y >= messageLable.frame.origin.y && points.x <= messageLable.frame.size.width + messageLable.frame.origin.x && points.y <= messageLable.frame.size.height + messageLable.frame.origin.y) {
//                print("I'm here")
                let webViewController = WebViewController()
                webViewController.delegate = self
                navigationController?.pushViewController(webViewController, animated: true)
            }
        }
        
    }
    @IBAction func beginScaning(sender: AnyObject) {
        let cameraViewController = QMCameraViewController(nibName: nil, bundle: nil)
        navigationController?.pushViewController(cameraViewController, animated: true)
        cameraViewController.delegate = self
        cameraViewController.backDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        clickEnabledLable.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
