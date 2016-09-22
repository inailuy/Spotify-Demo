//
//  SpotifyAPI.swift
//  SpotifyDemo
//
//  Created by inailuy on 9/8/16.
//  Copyright © 2016 yulz. All rights reserved.
//

import Foundation

let GET = "GET"
let baseURL = "https://api.spotify.com/v1/"

enum EndPoints: String {
    case Artists = "artists"
    case Albums = "albums"
    case Tracks = "tracks"
    case Search = "search"
}

enum NotificationKey:String {
    case ArtistResultsKey = "artistResultsKey"
    case AlbumResultsKey = "albumResultsKey"
    case TrackResultsKey = "trackResultsKey"
}

class SpotifyAPI: NSObject {
    static let sharedInstance = SpotifyAPI()
    
    //MARK: Basics
    private func createRequest(url: NSURL, method: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    private func createTask(request: NSMutableURLRequest, completion: (json: NSDictionary) -> Void) {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        if networkStatus == 0 {
            return
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:[]) as! NSDictionary
                if let error = json["error"] {
                    print(error)
                    return
                }
                completion(json: json)
            }
            catch{
                print("create task error")
                print(error)
            }
        }
        task.resume()
    }
    
    func postNotification(key: String, results:AnyObject) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName(key, object: results)
    }
    
    //MARK: Get Artists
    func getArtists(query: String) {
        let url = SpotifyURL.searchArtist(query)
        let request = createRequest(url!, method:GET)
        createTask(request, completion:{ json in
            let dic = json.valueForKey(Key.Artist.rawValue) as! NSDictionary
            let array = dic.valueForKey(Key.Items.rawValue) as! [NSDictionary]
            var artistArray = [Artist]()
            for obj in array {
                let artist = Artist(json: obj)
                artistArray.append(artist)
            }
            self.postNotification(NotificationKey.ArtistResultsKey.rawValue, results: artistArray)
        })
    }
    
    func getArtists(query: String, withCompletion:(albumArray: [Artist]) -> Void) {
        let formartQuery = query.stringByReplacingOccurrencesOfString(" ", withString: "+", options: .LiteralSearch, range: nil)
        if let url = SpotifyURL.searchArtist(formartQuery + "*") {
            let request = createRequest(url, method:GET)
            createTask(request, completion:{ json in
                let dic = json.valueForKey(Key.Artist.rawValue) as! NSDictionary
                let array = dic.valueForKey(Key.Items.rawValue) as! [NSDictionary]
                var artistArray = [Artist]()
                for obj in array {
                    let artist = Artist(json: obj)
                    artistArray.append(artist)
                }
                withCompletion(albumArray: artistArray)
            })
        }
    }
    
    func getSimilarArtist(id: String, withCompletion:(albumArray: [Artist]) -> Void) {
        let url = SpotifyURL.getArtistRelatedArtist(id)
        let request = createRequest(url, method: GET)
        createTask(request, completion: { json in
            let array = json.valueForKey(Key.Artist.rawValue) as! [NSDictionary]
            var artistArray = [Artist]()
            for obj in array {
                let artist = Artist(json: obj)
                artistArray.append(artist)
            }
            withCompletion(albumArray: artistArray)
        })
    }
    
    //MARK: Get Albums
    func getArtistAlbums(id: String) {
        let url = SpotifyURL.getArtistsAlbums(id)
        let request = createRequest(url, method: GET)
        
        createTask(request, completion: { json in
            let array = json.valueForKey(Key.Items.rawValue) as! [NSDictionary]
            var albumArray = [Album]()
            
            for obj in array {
                let album = Album(json: obj)
                albumArray.append(album)
            }
            self.postNotification(NotificationKey.AlbumResultsKey.rawValue, results: albumArray)
        })
    }
    
    func getArtistAlbums(id: String, withCompletion:(albumArray: [Album]) -> Void) {
        let url = SpotifyURL.getArtistsAlbums(id)
        let request = createRequest(url, method: GET)
        createTask(request, completion: { json in
            let array = json.valueForKey(Key.Items.rawValue) as! [NSDictionary]
            var albumArray = [Album]()
            for obj in array {
                let album = Album(json: obj)
                albumArray.append(album)
            }

            withCompletion(albumArray: albumArray)
        })
    }
    
    //MARK: Get Tracks
    func getAlbumTracks(id: String) {
        let url = SpotifyURL.getAlbumsTracks(id)
        let request = createRequest(url, method: GET)

        createTask(request, completion: { json in
            let array = json.valueForKey(Key.Items.rawValue) as! [NSDictionary]
            var trackArray = [Track]()
            for obj in array {
                let track = Track(json: obj)
                trackArray.append(track)
            }
            self.postNotification(NotificationKey.TrackResultsKey.rawValue, results: trackArray)
        })
    }
    
    func getAlbumTracks(id: String, withCompletion:(albumArray: [Track]) -> Void) {
        let url = SpotifyURL.getAlbumsTracks(id)
        let request = createRequest(url, method: GET)
        createTask(request, completion: { json in
            let array = json.valueForKey(Key.Items.rawValue) as! [NSDictionary]
            var trackArray = [Track]()
            for obj in array {
                let track = Track(json: obj)
                trackArray.append(track)
            }

            withCompletion(albumArray: trackArray)
        })
    }
    
    func getArtistTopTracks(id: String) {
        let url = SpotifyURL.getArtistTopTracks(id)
        let request = createRequest(url, method: GET)
        createTask(request, completion: { json in
            let array = json.valueForKey(Key.Tracks.rawValue) as! [NSDictionary]
            var trackArray = [Track]()
            for obj in array {
                let track = Track(json: obj)
                trackArray.append(track)
            }
            self.postNotification(NotificationKey.TrackResultsKey.rawValue, results: trackArray)
        })
    }
    
    func getArtistTopTracks(id: String, withCompletion:(albumArray: [Track]) -> Void) {
        let url = SpotifyURL.getArtistTopTracks(id)
        let request = createRequest(url, method: GET)
        createTask(request, completion: { json in
            let array = json.valueForKey(Key.Tracks.rawValue) as! [NSDictionary]
            var trackArray = [Track]()
            for obj in array {
                let track = Track(json: obj)
                trackArray.append(track)
            }
            withCompletion(albumArray: trackArray)
        })
    }
}

struct SpotifyURL {
    //MARK: Artists URL
    static func getArtist(id: String) -> NSURL {
        let urlString = baseURL + EndPoints.Artists.rawValue + "/" + id
        return NSURL(string: urlString)!
    }
    
    static func getSeveralArtists(id: String) -> NSURL {
        let urlString = baseURL + EndPoints.Artists.rawValue + "?ids=" + id
        return NSURL(string: urlString)!
    }
    
    static func getArtistsAlbums(id: String) -> NSURL {
        let urlString = baseURL + EndPoints.Artists.rawValue + "/" + id + "/albums?album_type=album&market=ES"
        return NSURL(string: urlString)!
    }
    
    static func getArtistTopTracks(id: String) -> NSURL {
        let urlString = baseURL + EndPoints.Artists.rawValue + "/" + id + "/top-tracks?country=US"
        return NSURL(string: urlString)!
    }
    
    static func getArtistRelatedArtist(id: String) -> NSURL {
        let urlString = baseURL + EndPoints.Artists.rawValue + "/" + id + "/related-artists"
        return NSURL(string: urlString)!
    }
    
    //MARK: Albums URL
    static func getAlbum(id: String) -> NSURL {
        let urlString = baseURL + EndPoints.Albums.rawValue + "/" + id
        return NSURL(string: urlString)!
    }
    
    static func getSeveralAlbums(id: String) -> NSURL {
        let urlString = baseURL + EndPoints.Albums.rawValue + "?ids=" + id
        return NSURL(string: urlString)!
    }
    
    static func getAlbumsTracks(id: String) -> NSURL {
        let urlString = baseURL + EndPoints.Albums.rawValue + "/" + id + "/tracks"
        return NSURL(string: urlString)!
    }
    
    //MARK: Tracks URL
    static func getTrack(id: String) -> NSURL {
        let urlString = baseURL + EndPoints.Tracks.rawValue + "/" + id
        return NSURL(string: urlString)!
    }
    
    static func getSeveralTracks(id: String) -> NSURL {
        let urlString = baseURL + EndPoints.Tracks.rawValue + "?ids=" + id
        return NSURL(string: urlString)!
    }
    
    //MARK: Search URL
    static func searchArtist(query: String) -> NSURL? {
        let q = query.stringByReplacingOccurrencesOfString("\\", withString: "")
        let urlString :String = baseURL + EndPoints.Search.rawValue + "?q=" + q + "&type=artist"
        if let url = NSURL(string: urlString) {
            return url
        }
        return nil
    }
}
