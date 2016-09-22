//
//  Helpers.swift
//  SpotifyDemo
//
//  Created by inailuy on 9/15/16.
//  Copyright © 2016 yulz. All rights reserved.
//

import UIKit

var imageDictionary = NSMutableDictionary() // cache images during a ongoing session

// ImageView extension methods
extension UIImageView {
    func loadImageFromPath(urlString: String) {
        if let img = imageDictionary[urlString] as? UIImage {
            image = img
        } else {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            activityIndicator.startAnimating()
            addSubview(activityIndicator)
            
            image = UIImage()
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                let url = NSURL(string: urlString)!
                let data = NSData(contentsOfURL: url)!
                dispatch_async(dispatch_get_main_queue(), {
                    if let img = UIImage(data: data) {
                        imageDictionary.setValue(img, forKey: urlString)
                        self.image = img
                        
                        activityIndicator.stopAnimating()
                    }
                })
            }
        }
    }
    
    func makeImageCircular() {
        let imageLayer = layer
        imageLayer.cornerRadius = 1
        imageLayer.borderWidth = 1
        imageLayer.borderColor = UIColor.lightGrayColor().CGColor
        imageLayer.masksToBounds = true
        
        layer.cornerRadius = frame.size.width/2
        layer.masksToBounds = true
    }
    
    func makeCornersRound() {
        layer.cornerRadius = 2.5
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.lightGrayColor().CGColor
        clipsToBounds = true
    }
}

enum Segue : String {
    case SeachVC, ArtistProfileVC, SongTVC, AlbumTVC
}

enum Key :String {
    case Name = "name"
    case ID = "id"
    case Generes = "generes"
    case HREF = "href"
    case Followers = "followers"
    case Total = "total"
    case Images = "images"
    case Height = "height"
    case Width = "width"
    case URL = "url"
    case Duration = "duration_ms"
    case Explicit = "explicit"
    case PreviewURL = "preview_url"
    case Artist = "artists"
    case Items = "items"
    case Tracks = "tracks"
}

let helveticaThinFont = "HelveticaNeue-Thin"
let helveticaLightFont = "HelveticaNeue-Light"
let helveticaFont = "HelveticaNeue"
let helveticaMediumFont = "HelveticaNeue-Medium"
let helveticaUltraLightFont = "HelveticaNeue-UltraLight"