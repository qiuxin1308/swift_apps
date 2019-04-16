//
//  FavoriteMovies.swift
//  XinQiu-Lab4
//
//  Created by Xin Qiu on 10/19/17.
//  Copyright © 2017 Xin Qiu. All rights reserved.
//

import UIKit

class FavoriteMovies: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var theData:[String] = []
    var moviesId:[String] = []
    var theMoviesData:[moviesInfo] = []
    var theImageCache:[UIImage] = []
    var deleteIndexPath: IndexPath? = nil
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editMovies: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: .reload, object: nil)
        theData = UserDefaults.standard.array(forKey: "data") as! [String]
        moviesId = UserDefaults.standard.array(forKey: "id") as! [String]
        setupTableView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    //reload the table data
    func reloadData(notification: Notification){
        theData = UserDefaults.standard.array(forKey: "data") as! [String]
        moviesId = UserDefaults.standard.array(forKey: "id") as! [String]
        fetchDataForTableView()
        cacheImages()
        tableView.reloadData()
    }
    
    //set up the table view
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        fetchDataForTableView()
        cacheImages()
    }
    
    //fetch the data for the table view
    func fetchDataForTableView(){
        theMoviesData.removeAll()
        
        var i = 0
        while (i < theData.count) {
            let moviesUrl = "https://api.themoviedb.org/3/movie/\(moviesId[i])?api_key=5ac88ab37ab257900725e9dda37c35f4&language=en-US"
            let json = getJSON(path: moviesUrl)
            let moviesJSON = json.dictionaryValue
            let name = moviesJSON["title"]?.stringValue
            let image = "https://image.tmdb.org/t/p/w500" + (moviesJSON["poster_path"]?.stringValue)!
            let year = moviesJSON["release_date"]?.stringValue
            let score = moviesJSON["vote_average"]?.stringValue
            let rate = moviesJSON["popularity"]?.stringValue
            theMoviesData.append(moviesInfo(name: name!, year: year!, score: score!, rate: rate!, imageUrl: image, id: moviesId[i]))
            i = i + 1
        }
    }
    
    func cacheImages(){
        theImageCache.removeAll()
        for item in theMoviesData {
            let url = URL(string: item.imageUrl)
            let data = try? Data(contentsOf: url!)
            if data == nil{
                let image = UIImage(named:"nonePoster")
                theImageCache.append(image!)
            } else {
                let image = UIImage(data: data!)
                theImageCache.append(image!)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = theData[indexPath.row]
        cell.imageView?.image = theImageCache[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UserDefaults.standard.array(forKey: "data")?.count)!
    }
    
    // to edit if you want to delete the movie from the favorite list
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteIndexPath = indexPath as IndexPath?
            let theDeleteMovie = theData[indexPath.row]
            let alertDeleting = UIAlertController(title: "movie deleting", message: "Do you want to delete \(theDeleteMovie) from your favorite list?", preferredStyle: .actionSheet)
            self.present(alertDeleting, animated: true, completion: nil)
            let deleteMovies = UIAlertAction(title: "delete", style: .destructive, handler: confirmDeleteMovies)
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: confirmCancel)
            alertDeleting.addAction(deleteMovies)
            alertDeleting.addAction(cancel)
        }
    }
    
    //if you choose to delete the movie
    func confirmDeleteMovies(alert: UIAlertAction!) -> Void {
        if let indexPath = deleteIndexPath {
            //update the table view from the beginning to the end
            tableView.beginUpdates()
            
            theData.remove(at: indexPath.row)
            UserDefaults.standard.set(theData, forKey: "data") //update the database
            moviesId.remove(at: indexPath.row)
            UserDefaults.standard.set(moviesId, forKey: "id")
            
            fetchDataForTableView()
            cacheImages()
            
            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            deleteIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    //if you choose to cancel
    func confirmCancel(alert: UIAlertAction!){
        deleteIndexPath = nil
    }
    
    //show the favorite movies details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showFavoritesDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showFavoritesDetails") {
            let indexPaths = self.tableView.indexPathsForSelectedRows!
            let indexPath = indexPaths[0] as IndexPath
            let detailedVC = segue.destination as! favoriteMoviesDetails
            detailedVC.moviesInfo = theMoviesData[indexPath.row]
            detailedVC.theImage = theImageCache[indexPath.row]
        }
    }
    
    //change the order of cells
    @IBAction func editMoviesCell(_ sender: Any) {
        tableView.isEditing = true
        editMovies.setTitle("Done", for: .normal)
            if (editMovies.titleLabel?.text == "Done") {
                editMovies.setTitle("Edit", for: .normal)
                tableView.isEditing = false
            }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let cellToMove = theData[sourceIndexPath.row]
        theData.remove(at: sourceIndexPath.row)
        theData.insert(cellToMove, at: destinationIndexPath.row)
        UserDefaults.standard.set(theData, forKey: "data")
        
        let cellToMoveId = moviesId[sourceIndexPath.row]
        moviesId.remove(at: sourceIndexPath.row)
        moviesId.insert(cellToMoveId, at: destinationIndexPath.row)
        UserDefaults.standard.set(moviesId, forKey: "id")
        
        fetchDataForTableView()
        cacheImages()
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .none
//    }
    
}
