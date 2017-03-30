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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        self.getMoviesAndUpdateTable()
        
        //var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.view.addSubview(self.activityIndicator)
        
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
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
}

