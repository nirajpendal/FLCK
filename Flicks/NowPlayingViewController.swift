//
//  FirstViewController.swift
//  Flicks
//
//  Created by Niraj Pendal on 3/27/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class NowPlayingViewController: MovieDisplayViewController {

    override func getMoviesAndUpdateTable() {
        self.presentIndicator()
        movieHelper.getNowPlayingMovies { [weak self] (moviesFromResponse, error) in
            
            self?.resultReturned(movieResults: moviesFromResponse, error: error)
        }
    }
}
