//
//  WiKiPageViewController.swift
//  MoneyTap
//
//  Created by Piyush Gangil on 19/08/18.
//  Copyright © 2018 Altisource. All rights reserved.
//

import UIKit

class WiKiPageViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var webview: UIWebView!
    var webPageTitle:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webview.delegate = self
        let urlStr = wikiPageBaseUrl + String(webPageTitle.replacingOccurrences(of: " ", with: "_"))
        
        if let url = URL(string: urlStr) {
          let request = URLRequest(url: url)
            self.webview.loadRequest(request)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Error:\(error.localizedDescription)")
    }
  
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("WebViewLoaded:\(webView.request?.url?.absoluteString ?? "")")
    }
    
}
