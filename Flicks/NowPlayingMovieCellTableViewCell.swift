//
//  NowPlayingMovieCellTableViewCell.swift
//  Flicks
//
//  Created by Niraj Pendal on 3/30/17.
//  Copyright © 2017 Proteus. All rights reserved.
//

import UIKit

class NowPlayingMovieCellTableViewCell: UITableViewCell {

    @IBOutlet weak var artWorkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
