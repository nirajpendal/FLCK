//
//  Movie.swift
//  Flicks
//
//  Created by Niraj Pendal on 3/29/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

let apiKey:String = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
let nowPlayingUrl = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
let imageBaseUrl = "https://image.tmdb.org/t/p/w500"

let topRatedUrl = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)&language=en-US&page=1")!

typealias DictionaryAnyObject = [String: AnyObject]

struct Movie {
    var title:String
    var posterPath: String
    var overview: String
    var releaseDate:String?
    var popularity: String?
}


class Movies {
    
    var nowPlayingMovies: [Movie] = []
    var topRatedMovies: [Movie] = []
    
    func fetchMoviesFromAPI(url:URL, callBack: @escaping (DictionaryAnyObject?, Error?) -> ()) {
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                callBack(nil, error)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? DictionaryAnyObject {
                //print(dataDictionary)
                callBack(dataDictionary, nil)
            }
        }
        task.resume()
    }
    
    func parseMovies(responseDict:DictionaryAnyObject?) -> ([Movie], Error?) {
        
        var movies:[Movie] = []
        
        guard let responseObject = responseDict else {
            return (movies,  NSError(domain:"Unknown Error Occurred..!!", code:1, userInfo:nil))
        }
        
        guard let results = responseObject["results"] as? [DictionaryAnyObject] else {
            return (movies,  NSError(domain:"Unknown Error Occurred..!!", code:1, userInfo:nil))
            
        }
       
        for movieResult:DictionaryAnyObject in results {
            let title = movieResult["title"] as! String
            let overview = movieResult["overview"] as! String
            let posterPath = imageBaseUrl + (movieResult["poster_path"] as! String)
            let releaseDate = movieResult["release_date"] as? String
            let popularity = movieResult["popularity"] as? String
            
            movies.append(Movie(title: title, posterPath: posterPath, overview: overview, releaseDate:releaseDate, popularity:popularity))
        }
        
        return (movies, nil)
        
    }
    
    func getTopRatedMovies(topRatedMoviesCallback:@escaping ([Movie], Error?) -> ()) {
        
        if self.topRatedMovies.count == 0 {
            self.fetchMoviesFromAPI(url: topRatedUrl, callBack: { [weak self] (response, error) in
                
                self?.topRatedMovies = []
                
                guard error == nil else {
                    topRatedMoviesCallback((self?.topRatedMovies)!, error!)
                    return
                }
                
                
                let parsedResponse = self?.parseMovies(responseDict: response)
                
                self?.topRatedMovies = (parsedResponse?.0)!
                
                topRatedMoviesCallback((self?.topRatedMovies)!, parsedResponse?.1)
                return
                
                
            })
        } else {
            print("Giving Cached Value")
            topRatedMoviesCallback((self.topRatedMovies), nil)
        }
        
        
    }
    
    func getNowPlayingMovies(nowPlayingCallback:@escaping ([Movie], Error?) -> ()) {
        
        if self.nowPlayingMovies.count == 0 {
            self.fetchMoviesFromAPI(url: nowPlayingUrl, callBack: { [weak self] (response, error) in
                
                self?.nowPlayingMovies = []
                
                guard error == nil else {
                    nowPlayingCallback((self?.nowPlayingMovies)!, error!)
                    return
                }
                
                
                let parsedResponse = self?.parseMovies(responseDict: response)
                
                self?.nowPlayingMovies = (parsedResponse?.0)!
                
                nowPlayingCallback((self?.nowPlayingMovies)!, parsedResponse?.1)
                return
                
                
            })
        } else {
            print("Giving Cached Value")
            nowPlayingCallback((self.nowPlayingMovies), nil)
        }
        
    }
}
