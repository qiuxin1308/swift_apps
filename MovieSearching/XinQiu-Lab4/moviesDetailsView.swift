//
//  moviesDetailsView.swift
//  XinQiu-Lab4
//
//  Created by Xin Qiu on 10/18/17.
//  Copyright © 2017 Xin Qiu. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let reload = Notification.Name("reload")
}

//var favoriteMovies:[String] = []
//var favoriteMoviesId:[String] = []



class moviesDetailsView: UIViewController {
    @IBOutlet weak var moviesImage: UIImageView!
    @IBOutlet weak var moviesName: UINavigationItem!
    @IBOutlet weak var theRate: UILabel!
    @IBOutlet weak var theYear: UILabel!
    @IBOutlet weak var theScore: UILabel!

    var theImage: UIImage!
    var moviesInfo: moviesInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMoviesDetail()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMoviesDetail() {
        moviesName.title = moviesInfo?.name
        moviesImage.image = theImage
        theYear.text = "Released: " + (moviesInfo!.year)
        if (moviesInfo?.score != nil) {
            theScore.text = "Score: " + (moviesInfo?.score)! + " / 10.0"
        }else {
            theScore.text = "Score: N/A"
                }
        theRate.text = "Rated: " + (moviesInfo!.rate)
    }
    
//when click the add to favorite button
    
    @IBAction func addFavoriteMovies(_ sender: Any) {
        var favoriteMovies = UserDefaults.standard.array(forKey: "data")
        var favoriteMoviesId = UserDefaults.standard.array(forKey: "id")
        if (favoriteMovies != nil) {
            favoriteMovies?.append(moviesInfo.name)
            favoriteMoviesId?.append(moviesInfo.id)
            UserDefaults.standard.set(favoriteMovies, forKey: "data")
            UserDefaults.standard.set(favoriteMoviesId, forKey: "id")
        }else{
            favoriteMovies = [moviesInfo.name]
            favoriteMoviesId = [moviesInfo.id]
            //print([moviesInfo.name].count)
            UserDefaults.standard.set(favoriteMovies, forKey: "data")
            UserDefaults.standard.set(favoriteMoviesId, forKey: "id")
        }
        
        NotificationCenter.default.post(name: .reload, object: nil)
    }
}
