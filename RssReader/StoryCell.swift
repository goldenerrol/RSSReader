//
//  StoryCell.swift
//  RssReader
//
//  Created by Libertas Education on 2016-09-29.
//  Copyright © 2016 Daniel Goldberg. All rights reserved.
//

import UIKit

class StoryCell: UITableViewCell {
    
    @IBOutlet var headLineLabel: UILabel!
    @IBOutlet var pubDateLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var storyImage: UIImageView!

    
    var row: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        storyImage.layer.masksToBounds = true
        storyImage.layer.cornerRadius = storyImage.bounds.size.width / 2
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}