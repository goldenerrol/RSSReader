//
//  ViewController.swift
//  RssReader
//
//  Created by Daniel Goldberg on 2016-09-29.
//  Copyright © 2016 Daniel Goldberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, NSXMLParserDelegate {
    
    var cell: StoryCell!
    var newsPieceArray = [NewsPiece]()
    var newsPiece = NewsPiece()
    
    var language: String?
    
    var eName = String()
    var headline = String()
    var author = String()
    var pubDate = String()
    var imageURL = String()
    var link = String()
    
    // Create XML parser
    var parser: NSXMLParser!
    
    let rssFeed = NSURL(string: "http://www.cbc.ca/cmlink/rss-topstories")!
    
    // Webview Controls
    @IBOutlet var viewWebViewContainer: UIView!
    @IBOutlet var viewWebView: UIWebView!
    
    @IBOutlet var lblWebview: UINavigationItem!
    // Hide webview
    @IBAction func btnExitWebview(sender: AnyObject) {
        viewWebViewContainer.hidden = true
    }
    // End Webview Controls
    
    @IBOutlet var storyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set default language
        self.language = "en"
        // fetch string from localizable.strings
        // futureproofing for multiple languages
        lblWebview.title = "WEBVIEW_HEADER".localized(self.language!)
        
        //fetch RSS data
        fetchData()
    }
    
    func fetchData() {
        // Load RSS feed/data into parser
        parser = NSXMLParser(contentsOfURL:(rssFeed))!
        self.parser.delegate = self
        self.parser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        eName = elementName
        
        if elementName == "item" {
            headline = String()
            author = String()
            pubDate = String()
            imageURL = String()
            link = String()
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        // Trimming characters and adding field specific data to the title, author, date, imageURL and link fields
        
        if (!data.isEmpty) {
            if eName == "title" {
                headline += data
            } else if eName == "author" {
                author += data
            } else if eName == "pubDate" {
                pubDate += data
            } else if eName == "description" {
                imageURL += data
            } else if eName == "link" {
                link += data
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        // Checking for when each element ends to append the XML data to the newsPiece array
        
        if elementName == "item" {
            let newsPiece = NewsPiece()
            newsPiece.headline = headline
            newsPiece.author = author
            newsPiece.pubDate = pubDate
            newsPiece.imageURL = imageURL
            newsPiece.link = link
            
            newsPieceArray.append(newsPiece)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Count and return total stories from news feed
        return newsPieceArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Define stroyboard cell as my custom StoryCell
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! StoryCell
        
        // Fetch data for the specific row
        
        let newsPiece = newsPieceArray[indexPath.row]
        
        // Populate the headline, auther and date fields
        
        cell.headLineLabel?.text = newsPiece.headline
        cell.authorLabel?.text = newsPiece.author
        cell.pubDateLabel?.text = newsPiece.pubDate
        
        // Run custom function to parse the imageURL from the description field
        
        let parsedImageURL = getImageURL(newsPiece.imageURL)
        
        // Fetch image from URL and populate imageView
        
        if let imagePathUrl = NSURL(string: parsedImageURL) {
            
            cell.storyImage?.image = nil
            

            let dataTask = NSURLSession.sharedSession().dataTaskWithURL(imagePathUrl, completionHandler: {
                (data: NSData?, response: NSURLResponse?, error: NSError?) in
                
                if let image = UIImage(data: data!) {
                    
                    // background thread: decompress image data in background before displaying in the TableView
                    UIGraphicsBeginImageContext(image.size)
                    image.drawAtPoint(CGPointZero)
                    UIGraphicsEndImageContext()
                    
                    // main thread: update image
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        // get the current cell
                        if let cell = self.storyTableView.cellForRowAtIndexPath(indexPath) as? StoryCell {
                            // update the image
                            cell.storyImage?.image = image
                        }
                    })
                }
            })
            dataTask.resume()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Build new story url from saved newsPiece.link data
        let newsPiece = newsPieceArray[indexPath.row]
        let storyURL = newsPiece.link
        
        // Show webView container and load the story URL
        
        viewWebViewContainer.hidden = false
        UIWebView.loadRequest(viewWebView)(NSURLRequest(URL: NSURL(string:storyURL)!))
    }
    
    func getImageURL(description: String) -> String{
        let imagePath = description
        
        // Search for link type in text
        
        let types: NSTextCheckingType = .Link
        
        let detector = try? NSDataDetector(types: types.rawValue)
        
        guard let detect = detector else {
            return ""
        }
        
        let matches = detect.matchesInString(imagePath, options: .ReportCompletion, range: NSMakeRange(0, imagePath.characters.count))
        
        var url = String(matches[0].URL!)
        
        // Remove trailing ' from string
        
        url.removeAtIndex(url.endIndex.predecessor())
        
        return url
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

