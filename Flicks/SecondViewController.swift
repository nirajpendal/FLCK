//
//  SecondViewController.swift
//  Flicks
//
//  Created by Niraj Pendal on 3/27/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit


class SecondViewController: MovieDisplayViewController {
    
    
    override func getMoviesAndUpdateTable() {
        self.presentIndicator()
        movieHelper.getTopRatedMovies { [weak self] (moviesFromResponse, error) in
            
            if error != nil {
                // Present error dialog here..
                print(error!.localizedDescription)
                let alertView = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let okActionButton: UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertView.addAction(okActionButton)
                
                self?.present(alertView, animated: true, completion: nil)
                
            } else {
                print("Movies returned \(moviesFromResponse.count)")
                self?.movies = moviesFromResponse
                self?.moviesTableView.reloadData()
            }
            
            self?.hideIndicator()
            self?.refreshControl.endRefreshing()
        }
    }


}

