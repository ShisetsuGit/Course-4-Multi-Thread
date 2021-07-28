//
//  WebViewController.swift
//  UI_Project
//
//  Created by  Shisetsu on 18.06.2021.
//

import UIKit
import WebKit
import Alamofire

class WebAuthController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet{
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VKAuth()
    }
    
    func VKAuth() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7767306"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "friends,photos,groups,wall"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.131"),
            URLQueryItem(name: "state", value: "Your_TOKEN_is_MINE!!!"),
            URLQueryItem(name: "revoke", value: "1") // принудительный запрос прав на доступ, даже если уже выданы. Для отладки, что страница загружается.
        ]
        let request = URLRequest(url: urlComponents.url!)
        webView.load(request)
        print("REQUEST_API")
        print(request)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        let token = params["access_token"]
        let userID = params["user_id"]
        VKSession.currentSession.token = token!
        VKSession.currentSession.userId = userID!
        showMainScreen()
        
        decisionHandler(.cancel)
    }
    
    func showMainScreen() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "mainScreenSegue", sender: nil)
        }
//        DispatchQueue.main.async {
//            self.performSegue(withIdentifier: "TestVC", sender: nil)
//        }
    }
}
