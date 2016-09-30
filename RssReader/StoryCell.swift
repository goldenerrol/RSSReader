//
//  StoryCell.swift
//  RssReader
//
//  Created by Daniel Goldberg on 2016-09-29.
//  Copyright © 2016 Daniel Goldberg. All rights reserved.
//

import UIKit

class StoryCell: UITableViewCell {
    
    // Create custom cell for newsPiece table
    
    @IBOutlet var headLineLabel: UILabel!
    @IBOutlet var pubDateLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var storyImage: UIImageView!

    
    var row: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Curving edge of the images, purely for show
        storyImage.layer.masksToBounds = true
        storyImage.layer.cornerRadius = storyImage.bounds.size.width / 5
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        storyImage.image = nil
    }
    
}