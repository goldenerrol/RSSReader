//
//  ViewController.swift
//  RssReader
//
//  Created by Libertas Education on 2016-09-29.
//  Copyright © 2016 Daniel Goldberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSXMLParserDelegate {
    
    var cell: StoryCell!
    
    var parser = NSXMLParser()
    var stories = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var headline = NSMutableString()
    var pubDate = NSMutableString()
    var author = NSMutableString()
    var imageURL = NSMutableString()
    
    let rssFeed = NSURL(string: "http://www.cbc.ca/cmlink/rss-topstories")!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fetchData()
        
    }
    
    func fetchData() {
        stories = []
        parser = NSXMLParser(contentsOfURL: rssFeed)!
        parser.delegate = self
        parser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        element = elementName
        
        if (elementName as NSString).isEqualToString("item") {

            elements = [:]
            headline = ""
            pubDate = ""
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString("title") {
            headline.appendString(string)
        }
        if element.isEqualToString("pubDate") {
            pubDate.appendString(string)
        }
        if element.isEqualToString("author") {
            author.appendString(string)
        }
        if element.isEqualToString("description") {
            imageURL.appendString(string)
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if (elementName as NSString).isEqualToString("item") {
            if !headline.isEqual(nil) {
                elements.setObject(headline, forKey: "headline")
            }
            if !pubDate.isEqual(nil) {
                elements.setObject(pubDate, forKey: "pubDate")
            }
            if !author.isEqual(nil) {
                elements.setObject(author, forKey: "author")
            }
            if !imageURL.isEqual(nil) {
                elements.setObject(imageURL, forKey: "imageURL")
            }
            
            stories.addObject(elements)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Count and return total stories from news feed
        return stories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        cell.headLineLabel?.text = stories.objectAtIndex(indexPath.row).valueForKey("headline") as? String
        cell.pubDateLabel?.text = stories.objectAtIndex(indexPath.row).valueForKey("pubDate") as? String
        cell.authorLabel?.text = stories.objectAtIndex(indexPath.row).valueForKey("author") as? String
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

