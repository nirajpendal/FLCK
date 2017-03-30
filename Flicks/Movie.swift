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

typealias DictionaryAnyObject = [String: AnyObject]

struct Movie {
    var title:String
    var posterPath: String
    var overview: String
}


class Movies {
    
    var nowPlayingMovies: [Movie] = []
    
    func fetchNowPlayingMoviesFromAPI(callBack: @escaping (DictionaryAnyObject?, Error?) -> ()) {
        
        let request = URLRequest(url: nowPlayingUrl, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
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
    
    func getNowPlayingMovies(nowPlayingCallback:@escaping ([Movie], Error?) -> ()) {
        
        if self.nowPlayingMovies.count == 0 {
            self.fetchNowPlayingMoviesFromAPI(callBack: { [weak self] (response, error) in
                
                self?.nowPlayingMovies = []
                
                guard error == nil else {
                    nowPlayingCallback((self?.nowPlayingMovies)!, error!)
                    return
                }
                
                guard let responseObject = response else {
                    nowPlayingCallback((self?.nowPlayingMovies)!,  NSError(domain:"Unknown Error Occurred..!!", code:1, userInfo:nil))
                    return
                }
                
                guard let results = responseObject["results"] as? [DictionaryAnyObject] else {
                    nowPlayingCallback((self?.nowPlayingMovies)!, NSError(domain:"Unknown Error Occurred..!!", code:1, userInfo:nil))
                    return
                    
                }
                
                for movieResult:DictionaryAnyObject in results {
                    let title = movieResult["title"] as! String
                    let overview = movieResult["overview"] as! String
                    let posterPath = imageBaseUrl + (movieResult["poster_path"] as! String)
                    self?.nowPlayingMovies.append(Movie(title: title, posterPath: posterPath, overview: overview))
                }
                
                nowPlayingCallback((self?.nowPlayingMovies)!, nil)
                return
                
                
            })
        } else {
            nowPlayingCallback((self.nowPlayingMovies), nil)
        }
        
    }
}
