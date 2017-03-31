//
//  FirstViewController.swift
//  Flicks
//
//  Created by Niraj Pendal on 3/27/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import AFNetworking

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var moviesTableView: UITableView!
    var movieHelper = Movies()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        self.moviesTableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(refreshControlEvent), for: UIControlEvents.valueChanged)
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        self.getMoviesAndUpdateTable()
        
        //var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.view.addSubview(self.activityIndicator)
        
    }
    
    func refreshControlEvent()  {
        self.getMoviesAndUpdateTable()
    }
    
    func presentIndicator()  {
        self.activityIndicator.startAnimating()
    }
    
    func hideIndicator()  {
        self.activityIndicator.stopAnimating()
    }
    
    
    func getMoviesAndUpdateTable() {
        self.presentIndicator()
        movieHelper.getNowPlayingMovies { [weak self] (movies, error) in
            
            if error != nil {
                // Present error dialog here..
                print(error!.localizedDescription)
            } else {
                print("Movies returned \(movies.count)")
                self?.moviesTableView.reloadData()
            }
            
            self?.hideIndicator()
            self?.refreshControl.endRefreshing()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? MovieDetailsViewController {
            
            if let cell = sender as? NowPlayingMovieCellTableViewCell {
                destinationViewController.imageViewImage = cell.artWorkImageView.image
                destinationViewController.movie = self.movieHelper.nowPlayingMovies[(self.moviesTableView.indexPath(for: cell)?.row)!]
                
            }   
        }
    }
    
}

extension FirstViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieHelper.nowPlayingMovies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.moviesTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! NowPlayingMovieCellTableViewCell
        cell.titleLabel.text = movieHelper.nowPlayingMovies[indexPath.row].title
        cell.overViewLabel.text = movieHelper.nowPlayingMovies[indexPath.row].overview
        
        let urlString = movieHelper.nowPlayingMovies[indexPath.row].posterPath
        cell.artWorkImageView.setImageWith(URL(string: urlString)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailsViewSegue", sender: tableView.cellForRow(at: indexPath))
    }
    
}

