//
//  ViewController.swift
//  XinQiu-Lab4
//
//  Created by Xin Qiu on 10/17/17.
//  Copyright © 2017 Xin Qiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var searchMovies: UISearchBar!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var isLoading: UIActivityIndicatorView!
    
    var theData:[moviesInfo] = []
    var theImageCache: [UIImage] = []
    var isSearch:Bool = false
    var moviesURL:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupCollectionView()
        setupSearchBar()
        isLoading.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviesCell", for: indexPath) as! moviesViewCell
        if (isSearch) {
            cell.moviesImage?.image = theImageCache[indexPath.row]
            cell.moviesName?.text = theData[indexPath.row].name
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theImageCache.count
    }
    
    private func getJSON(path: String) -> JSON {
        guard let url = URL(string: path) else { return JSON.null }
        do {
            let data = try Data(contentsOf: url)
            let jSon = try JSON(data: data)
            return jSon
        } catch {
            return JSON.null
        }
    }
    
    func setupCollectionView(){
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
    }
    
    func setupSearchBar(){
        searchMovies.delegate = self
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearch = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchName = searchText.replacingOccurrences(of: " ", with: "+")
        moviesURL = "https://api.themoviedb.org/3/search/movie?api_key=5ac88ab37ab257900725e9dda37c35f4&language=en-US&query=\(searchName)&page=1&include_adult=false"
        theData.removeAll()
        theImageCache.removeAll()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isLoading.hidesWhenStopped = true
        isLoading.startAnimating()
        view.addSubview(isLoading)
        
        
        DispatchQueue.global().async {
            self.fetchDataForCollectionView()
            self.cacheImages()
            DispatchQueue.main.async {
               self.isLoading.stopAnimating()
               self.moviesCollectionView.reloadData()
            }
        }
        moviesCollectionView.reloadData()
    }
    
    //show movies details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMoviesDetails" {
            let indexPaths = self.moviesCollectionView!.indexPathsForSelectedItems!
            let indexPath = indexPaths[0] as IndexPath
            let detailedVC = segue.destination as! moviesDetailsView
            detailedVC.moviesInfo = theData[indexPath.row]
            detailedVC.theImage = theImageCache[indexPath.row]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showMoviesDetails", sender: self)
    }
    
    func fetchDataForCollectionView(){
        theData.removeAll()
        let json = getJSON(path: moviesURL)
        let moviesJSON = json.dictionaryValue
        
        for movies in (moviesJSON["results"]?.arrayValue)! {
            let name = movies["title"].stringValue
            let image = "https://image.tmdb.org/t/p/w500" + movies["poster_path"].stringValue
            //print(image)
            let id = movies["id"].stringValue
            let year = movies["release_date"].stringValue
            let score = movies["vote_average"].stringValue
            let rate = movies["popularity"].stringValue
            theData.append(moviesInfo(name:name, year:year, score:score, rate:rate, imageUrl:image, id:id))
        }
    }
    
    func cacheImages(){
        theImageCache.removeAll()
        for item in theData {
            let url = URL(string: item.imageUrl)
            let data = try? Data(contentsOf: url!)
            if data == nil{
                let image = UIImage(named:"nonePoster")
                theImageCache.append(image!)
            } else {
                let image = UIImage(data: data!)
                theImageCache.append(image!)
            }
//            if(item.imageUrl != "https://image.tmdb.org/t/p/w500"){
//                let data = try? Data(contentsOf: url!)
//                let image = UIImage(data: data!)
//                theImageCache.append(image!)
//            }else{
//                let image = UIImage(named: "movies_Item")
//                theImageCache.append(image!)
//            }
            
        }
    }
    
}

