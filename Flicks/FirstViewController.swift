//
//  FirstViewController.swift
//  Flicks
//
//  Created by Niraj Pendal on 3/27/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class FirstViewController: MovieDisplayViewController {

    override func getMoviesAndUpdateTable() {
        self.presentIndicator()
        movieHelper.getNowPlayingMovies { [weak self] (moviesFromResponse, error) in
            
            guard let strongSelf = self else {
                return
            }
            
            if error != nil {
                // Present error dialog here..
                print(error!.localizedDescription)
                let alertView = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let okActionButton: UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertView.addAction(okActionButton)
                
                strongSelf.present(alertView, animated: true, completion: nil)
                
            } else {
                print("Movies returned \(moviesFromResponse.count)")
                strongSelf.movies = moviesFromResponse
                strongSelf.movieCopy = strongSelf.movies
                strongSelf.moviesTableView.reloadData()
            }
            
            strongSelf.hideIndicator()
            strongSelf.refreshControl.endRefreshing()
        }
    }
    
}
