//
//  WebViewController.swift
//  QR-codeScanning
//
//  Created by 黄启明 on 16/8/21.
//  Copyright © 2016年 huatengIOT. All rights reserved.
//

import UIKit

protocol URLGet {
    func transferURL() -> String?
}

class WebViewController: UIViewController {
    
    var delegate: URLGet?
    
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        let webView = UIWebView()
        webView.frame = view.bounds
        webView.scalesPageToFit = true
        view.addSubview(webView)
        toWeb(webView)
    }
    
    func toWeb(webView: UIWebView) {
        guard let transferURL = delegate!.transferURL() else {
            return
        }
        if let url = NSURL(string: transferURL) {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
