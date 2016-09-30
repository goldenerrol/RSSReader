//
//  StringExtension.swift
//  RssReader
//
//  Created by Libertas Education on 2016-09-29.
//  Copyright © 2016 Daniel Goldberg. All rights reserved.
//

import Foundation

extension String {
    func localized(lang:String)->String {
        
        //Extention for localizable strings
        let path = NSBundle.mainBundle().pathForResource(lang, ofType: "lproj")
        
        let bundle = NSBundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}