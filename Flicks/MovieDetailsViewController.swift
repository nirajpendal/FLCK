//
//  MovieDetailsViewController.swift
//  Flicks
//
//  Created by Niraj Pendal on 3/30/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var overViewTextScroll: UIScrollView!
    @IBOutlet weak var detailMovieArtImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var movie : Movie?
    
    let leftPadding:CGFloat = 10
    
    var imageViewImage: UIImage?
    var overViewText:String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.detailMovieArtImageView.image = imageViewImage
        
        let titleLabel = UILabel(frame: CGRect(x: leftPadding, y: 10, width: scrollView.frame.width - 20, height: 20))
        titleLabel.text = self.movie?.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        let releaseDateLabel = UILabel(frame: CGRect(x: leftPadding, y: 35, width: scrollView.frame.width - 20, height: 20))
        releaseDateLabel.text = self.movie?.releaseDate
        
        let popularity = UILabel(frame: CGRect(x: leftPadding, y: 60, width: scrollView.frame.width - 20, height: 25))
        popularity.text = self.movie?.popularity

        let overView = UILabel(frame: CGRect(x: leftPadding, y: 90, width: scrollView.frame.width - 20, height: 0))
        overView.numberOfLines = 0
        overView.text = self.movie?.overview
        overView.sizeToFit()
        

        
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(releaseDateLabel)
        scrollView.addSubview(popularity)
        scrollView.addSubview(overView)
        
        scrollView.alpha = 0.8
        
        scrollView.backgroundColor = UIColor.white
        
        let contentHeight = overView.frame.size.height + overView.frame.origin.y + 20
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentHeight)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
