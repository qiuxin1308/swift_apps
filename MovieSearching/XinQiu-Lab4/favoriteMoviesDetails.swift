//
//  favoriteMoviesDetails.swift
//  XinQiu-Lab4
//
//  Created by Xin Qiu on 10/20/17.
//  Copyright © 2017 Xin Qiu. All rights reserved.
//

import UIKit
import WebKit

class favoriteMoviesDetails: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var theImageView: UIImageView!
    @IBOutlet weak var theYear: UILabel!
    @IBOutlet weak var theScore: UILabel!
    @IBOutlet weak var theRate: UILabel!
    @IBOutlet weak var theMoviesName: UINavigationItem!
    @IBOutlet weak var clickMore: UIButton!
    
    var theImage: UIImage!
    var moviesInfo: moviesInfo!
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        showFavoriteMoviesDeatils()
        clickMore.isHidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //show the favorite movies details
    func showFavoriteMoviesDeatils() {
        theMoviesName.title = moviesInfo?.name
        theImageView.image = theImage
        theYear.text = "Released: " + (moviesInfo!.year)
        if (moviesInfo?.score != nil) {
            theScore.text = "Score: " + (moviesInfo!.score) + " / 10.0"
        }else {
            theScore.text = "Score: N/A"
        }
        theRate.text = "Rated: " + (moviesInfo!.rate)
    }
    //get more details from the website
    
    @IBAction func moreDetails(_ sender: Any) {
        webView = WKWebView()
        webView.navigationDelegate = self
        let moviesUrl = "https://www.themoviedb.org/movie/" + (moviesInfo?.id)!
        let url = URL(string: moviesUrl)
        let myURLRequest = URLRequest(url: url!)
        webView.load(myURLRequest)
        view = webView
        clickMore.isHidden = true
    }
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        title = webView.title
//    }
}
