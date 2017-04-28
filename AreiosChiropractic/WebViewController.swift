//
//  WebViewController.swift
//  Chiropractic
//
//  Created by Nicholas Laughter on 1/17/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var homePageWebView: UIWebView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWebsite()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        homePageWebView.goBack()
    }
    
    @IBAction func forwardButtonTapped(_ sender: Any) {
        homePageWebView.goForward()
    }
    
    func loadWebsite() {
        guard let url = URL(string: .homeURLString) else { return }
        let request = URLRequest(url: url)
        homePageWebView.loadRequest(request)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        refreshButtons()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        refreshButtons()
    }
    
    func refreshButtons() {
        backButton.isEnabled = homePageWebView.canGoBack
        forwardButton.isEnabled = homePageWebView.canGoForward
    }
}
