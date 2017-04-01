//
//  SecondViewController.swift
//  Flicks
//
//  Created by Niraj Pendal on 3/27/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit


class TopRatedViewController: MovieDisplayViewController {
    
    override func getMoviesAndUpdateTable() {
        self.presentIndicator()
        movieHelper.getTopRatedMovies { [weak self] (moviesFromResponse, error) in
            self?.resultReturned(movieResults: moviesFromResponse, error: error)
        }
    }


}

