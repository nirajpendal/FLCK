//
//  MovieDisplayViewController.swift
//  Flicks
//
//  Created by Niraj Pendal on 3/30/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var moviesTableView: UITableView!
    var movieHelper = Movies()
    var movies:[Movie] = []
    let activityIndicator = ActivityIndicator()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.moviesTableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(refreshControlEvent), for: UIControlEvents.valueChanged)
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.backgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        
        self.getMoviesAndUpdateTable()
        
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
       // self.presentIndicator()
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


