//
//  LaureenViewController.swift
//  Bitpanda
//
//  Created by Laureen Schausberger on 27.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit
import WebKit

final class LaureenViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        
        webView?.navigationDelegate = self
        webView?.load(URLRequest(url: URL(string:  "https://github.com/lauli")!))
        webView?.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
    
    @IBAction func goToPrevPage(_ sender: Any) {
        webView?.goBack()
    }
    
    @IBAction func goToNextPage(_ sender: Any) {
        webView?.goForward()
    }
    
}
