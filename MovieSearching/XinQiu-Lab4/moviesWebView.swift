//
//  moviesWebView.swift
//  XinQiu-Lab4
//
//  Created by Xin Qiu on 10/20/17.
//  Copyright © 2017 Xin Qiu. All rights reserved.
//

import UIKit
import WebKit

class moviesWebView: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    @IBOutlet weak var otherTheatres: UIBarButtonItem!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebsite()
        //otherTheatres = UIBarButtonItem(title: "Others", style: .plain, target: self, action: #selector(openTapped))
        //isLoadingPage.hidesWhenStopped = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //to get the url of the requested website
    func loadWebsite() {
        //isLoadingPage.hidesWhenStopped = true
        //view.addSubview(isLoadingPage)
        //isLoadingPage.startAnimating()
        let url = URL(string: "https://www.amctheatres.com/movies")
        let myURLRequest = URLRequest(url: url!)
        webView.load(myURLRequest)
        //isLoadingPage.stopAnimating()
        
    }
    @IBAction func openOthersTheatres(_ sender: Any) {
        openTapped()
    }
    
    //the prefix of the website
    func openPage(action: UIAlertAction!) {
        let url = URL(string: "http://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    //the website you want to open in the tap
    func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "marcustheatres.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "stlouiscinemas.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "landmarktheatres.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }

}
