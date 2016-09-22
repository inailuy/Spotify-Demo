//
//  Model.swift
//  SpotifyDemo
//
//  Created by inailuy on 9/9/16.
//  Copyright © 2016 yulz. All rights reserved.
//

import Foundation
import UIKit

class Artist:NSObject {
    var name :String!
    var id :String!
    var followers :NSNumber!
    var images = [Image]()
    var link :String!
    var genres :NSArray!
    
    var albums = [Album]()
    var topSongs = [Track]()
    var similarArtists = [Artist]()
    
    override init() {
        //
    }
    
    init(json:NSDictionary) {
        super.init()
        
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
    
    func loadAdditionalResources() {
        loadAlbums()
        loadTracks()
        loadSimilarArtist()
    }
    
    func loadAlbums() {
        SpotifyAPI.sharedInstance.getArtistAlbums(id, withCompletion:{ albumArray in
            self.albums = albumArray
            //check for duplicates
            for x in 0...albumArray.count {
                var y = x+1
                while self.albums.count > y {
                    if self.albums[x].name == self.albums[y].name {
                        self.albums.removeAtIndex(y)
                        break
                    }
                    y += 1
                }
            }
            
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(NotificationKey.ArtistResultsKey.rawValue, object: nil)
        })
    }
    
    func loadTracks() {
        SpotifyAPI.sharedInstance.getArtistTopTracks(id, withCompletion:{ trackArray in
            self.topSongs = trackArray
            
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(NotificationKey.TrackResultsKey.rawValue, object: nil)
        })
    }
    
    func loadSimilarArtist() {
        SpotifyAPI.sharedInstance.getSimilarArtist(id, withCompletion:{ artistArray in
            self.similarArtists = artistArray
            
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(NotificationKey.TrackResultsKey.rawValue, object: nil)
        })
    }
    
    func portraitImage() -> Image? {
        for i in images {
            if i.width.floatValue / i.hieght.floatValue > 0.9 &&
                i.width.floatValue / i.hieght.floatValue < 1.1 {
                return i
            }
        }
        if images.count > 0 {
            return images.last
        }
        
        return nil
    }
    
    func followerString() -> String {
        switch followers.integerValue {
        case 0...999:
            return String(followers.integerValue) + " Followers"
        case 1000...999999:
            let thousand = followers.intValue / 1000
            return String(thousand) + "k Followers"
        case 1000000...999999999:
            let million = followers.intValue / 1000000
            return String(million) + "m Followers"
        default:
            return ""
        }
    }
}

class Album:NSObject {
    var name :String!
    var id :String!
    var artist :String?
    var genres :NSArray?
    var explicit :Bool?
    
    var images = [Image]()
    var tracks = [Track]()
    
    override init() {
        //
    }
    
    init(json: NSDictionary) {
        super.init()
        name = json.valueForKey(Key.Name.rawValue) as! String
        id = json.valueForKey(Key.ID.rawValue) as! String

        let imageArray = json.valueForKey(Key.Images.rawValue) as! [NSDictionary]
        for obj in imageArray {
            let image = Image(json: obj)
            images.append(image)
        }
        
        SpotifyAPI.sharedInstance.getAlbumTracks(id, withCompletion:{ trackArray in
            self.tracks = trackArray 
            for track in trackArray {
                if track.explicit.boolValue == true {
                    self.explicit = true
                    break
                }
            }
            
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(NotificationKey.TrackResultsKey.rawValue, object: nil)
        })
    }
    
    func portraitImage() -> Image? {
        for i in images {
            if i.width.floatValue / i.hieght.floatValue > 0.75 &&
                i.width.floatValue / i.hieght.floatValue < 1.2 {
                return i
            }
        }
        return images.first
    }
    
    func backgroundImage() -> Image? {
        for i in images {
            if i.width.floatValue / i.hieght.floatValue > 1.25 {
                return i
            }
        }
        return nil
    }
}

class Track:NSObject {
    var name :String!
    var duration :NSNumber!
    var id :String!
    var explicit :NSNumber
    var previewURL :String?
    
    init(json: NSDictionary) {
        
        name = json.valueForKey(Key.Name.rawValue) as! String
        id = json.valueForKey(Key.ID.rawValue) as! String
        duration = json.valueForKey(Key.Duration.rawValue) as! NSNumber
        explicit = json.valueForKey(Key.Explicit.rawValue) as! NSNumber
        previewURL = json.valueForKey(Key.PreviewURL.rawValue) as? String
    }
    
    func length() -> String {
        let sec = duration.integerValue % 60
        let minutes = duration.integerValue / 60000
        return String(format: "%02d:%02d", minutes, sec)
    }
}

class Image:NSObject {
    var hieght :NSNumber!
    var width :NSNumber!
    var url :String!
    
    override init() {
        //
    }
    
    init(json: NSDictionary) {
        hieght = json.valueForKey(Key.Height.rawValue) as! NSNumber
        width = json.valueForKey(Key.Width.rawValue) as! NSNumber
        url = json.valueForKey(Key.URL.rawValue) as! String
    }
}
