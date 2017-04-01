//
//  MovieDisplayViewController.swift
//  Flicks
//
//  Created by Niraj Pendal on 3/30/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDisplayViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var moviesTableView: UITableView!
    var movieHelper = Movies()
    var movies:[Movie] = []
    var movieCopy:[Movie] = []
    let activityIndicator = ActivityIndicator()
    let refreshControl = UIRefreshControl()
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createSearchBar()
        
        self.moviesTableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(refreshControlEvent), for: UIControlEvents.valueChanged)
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.backgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        
        self.getMoviesAndUpdateTable()
        
    }
    
    func createSearchBar()  {
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search Movie"
        self.searchBar.showsCancelButton = false
        self.navigationItem.titleView = self.searchBar
    }
    
    func refreshControlEvent()  {
        self.getMoviesAndUpdateTable()
    }
    
    func presentIndicator()  {
        self.activityIndicator.showActivityIndicator(uiView: (self.tabBarController?.view)!)
        //self.activityIndicator.startAnimating()
    }
    
    func hideIndicator()  {
        self.activityIndicator.hideActivityIndicator(view: (self.tabBarController?.view)!)
    }
    
    func getMoviesAndUpdateTable() {
       // Will be impleteemented by sub-classes
    }
    
    func resultReturned(movieResults:[Movie], error:Error?)  {
        if error != nil {
            // Present error dialog here..
            print(error!.localizedDescription)
            let alertView = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            
            let okActionButton: UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertView.addAction(okActionButton)
            
            self.present(alertView, animated: true, completion: nil)
            
        } else {
            print("Movies returned \(movieResults.count)")
            self.movies = movieResults
            self.movieCopy = self.movies
            self.moviesTableView.reloadData()
        }
        
        self.hideIndicator()
        self.refreshControl.endRefreshing()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? MovieDetailsViewController {
            
            if let cell = sender as? NowPlayingMovieCellTableViewCell {
                destinationViewController.imageViewImage = cell.artWorkImageView.image
                destinationViewController.movie = self.movies[(self.moviesTableView.indexPath(for: cell)?.row)!]
                
            }
        }
    }
    
    func filterMovies(queryText:String) {
        
        var filteredMovies = self.movieCopy
        
        if queryText != "" {
             filteredMovies = self.movieCopy.filter { $0.title.lowercased().contains(queryText.lowercased())}
        }
        
        self.movies = filteredMovies
        self.moviesTableView.reloadData()
    }
    
}

extension MovieDisplayViewController {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        filterMovies(queryText: searchText)
    }
    
}

extension MovieDisplayViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.moviesTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! NowPlayingMovieCellTableViewCell
        
        let movie = self.movies[indexPath.row]
        
        cell.titleLabel.text = movie.title
        cell.overViewLabel.text = movie.overview
        
        let urlString = movie.posterPath
        cell.artWorkImageView.setImageWith(URL(string: urlString)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailsViewSegue", sender: tableView.cellForRow(at: indexPath))
    }
    
}


