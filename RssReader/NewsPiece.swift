//
//  NewsPiece.swift
//  RssReader
//
//  Created by Daniel Goldberg on 2016-09-29.
//  Copyright © 2016 Daniel Goldberg. All rights reserved.
//

import UIKit

class NewsPiece: NSObject {
    
    // Create newsPiece object for storing appData
    
    var headline: String = ""
    var author: String = ""
    var pubDate: String = ""
    var imageURL: String = ""
    var link: String = ""
    
    override init() {}
    init(headline: String, author: String, pubDate: String, imageURL: String, link: String) {
        self.headline = headline
        self.author = author
        self.pubDate = pubDate
        self.imageURL = imageURL
        self.link = link
    }
}
