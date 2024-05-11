//
//  NewsSourceViewController.swift
//  News_App
//
//  Created by Batuhan Berk Ertekin on 10.05.2024.
//

import UIKit
import WebKit

class NewsSourceViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var newsUrl : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        
        if let url = newsUrl {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func setupWebView() {
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
