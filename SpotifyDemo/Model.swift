//
//  Model.swift
//  SpotifyDemo
//
//  Created by inailuy on 9/9/16.
//  Copyright © 2016 yulz. All rights reserved.
//

import Foundation

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
}

struct Artist {
    var name :String!
    var id :String!
    var followers :NSNumber!
    var images = [Image]()
    var link :String!
    var genres :NSArray!
    
    var albums :[Album]?
    
    init(json:NSDictionary) {
        name = json.valueForKey(Key.Name.rawValue) as! String
        id = json.valueForKey(Key.ID.rawValue) as! String
        genres = json.valueForKey(Key.Generes.rawValue) as? NSArray
        link = json.valueForKey(Key.HREF.rawValue) as! String
        
        let followerDictionary = json.valueForKey(Key.Followers.rawValue)
        followers = followerDictionary?.valueForKey(Key.Total.rawValue) as! NSNumber
        
        let imageArray = json.valueForKey(Key.Images.rawValue) as! [NSDictionary]
        for obj in imageArray {
            let image = Image(json: obj)
            images.append(image)
        }
    }
}

struct Album {
    var name :String!
    var id :String!
    var artist :String?
    var genres :NSArray?
    var explicit :Bool?
    
    var images = [Image]()
    
    init(json: NSDictionary) {
        name = json.valueForKey(Key.Name.rawValue) as! String
        id = json.valueForKey(Key.ID.rawValue) as! String

        let imageArray = json.valueForKey(Key.Images.rawValue) as! [NSDictionary]
        for obj in imageArray {
            let image = Image(json: obj)
            images.append(image)
        }
    }
}

struct Track {
    var name :String!
    var duration :NSNumber!
    var id :String!
    var explicit :NSNumber
    var previewURL :String
    
    init(json: NSDictionary) {
        name = json.valueForKey(Key.Name.rawValue) as! String
        id = json.valueForKey(Key.ID.rawValue) as! String
        duration = json.valueForKey(Key.Duration.rawValue) as! NSNumber
        explicit = json.valueForKey(Key.Explicit.rawValue) as! NSNumber
        previewURL = json.valueForKey(Key.PreviewURL.rawValue) as! String
    }
    
    func length() -> String {
        let minutes = duration.integerValue / 60
        let seconds = duration.integerValue % 60
        return String(minutes) + ":" + String(seconds)
    }
}

struct Image {
    var hieght :NSNumber!
    var width :NSNumber!
    var url :String!
    
    init(json: NSDictionary) {
        hieght = json.valueForKey(Key.Height.rawValue) as! NSNumber
        width = json.valueForKey(Key.Width.rawValue) as! NSNumber
        url = json.valueForKey(Key.URL.rawValue) as! String
    }
}
