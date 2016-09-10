//
//  SpotifyAPI.swift
//  SpotifyDemo
//
//  Created by inailuy on 9/8/16.
//  Copyright © 2016 yulz. All rights reserved.
//

import Foundation

let baseURL = "https://api.spotify.com"
enum EndPoints: String {
    case Artists = "/v1/artists"
    case Albums = "/v1/albums"
    case Tracks = "/v1/tracks"
    case Search = "/v1/search"
}

class SpotifyAPI {
    static let sharedInstance = SpotifyAPI()
    weak var delegate:SpotifyAPIDelegate?
    
    //MARK: Basics
    func createRequest(url: NSURL, method: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func createTask(request: NSMutableURLRequest, completion: (json: NSDictionary) -> Void) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            do {
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options:[]) as! NSDictionary
                completion(json: jsonDictionary)
            }
            catch{}
        }
        task.resume()
    }
    
    //MARK: Get Artists
    func getArtists(query: String) {
        let url = SpotifyURL.searchArtist(query)
        let request = createRequest(url, method:"GET")
        createTask(request, completion:{ json in
            let dic = json.valueForKey("artists") as! NSDictionary
            let array = dic.valueForKey("items") as! [NSDictionary]
            var artistArray = [Artist]()
            for obj in array {
                let artist = Artist(json: obj)
                artistArray.append(artist)
            }
            self.delegate?.artistResults(artistArray)
        })
    }
    
    func getSimilarArtist(id: String) {
        let url = SpotifyURL.getArtistRelatedArtist(id)
        let request = createRequest(url, method: "GET")
        createTask(request, completion: { json in
            let array = json.valueForKey("artists") as! [NSDictionary]
            var artistArray = [Artist]()
            for obj in array {
                let artist = Artist(json: obj)
                artistArray.append(artist)
            }
            self.delegate?.artistResults(artistArray)
        })
    }
    
    //MARK: Get Albums
    func getArtistAlbums(artist: String) {
        let url = SpotifyURL.getArtistsAlbums(artist)
        let request = createRequest(url, method: "GET")
        createTask(request, completion: { json in
            let array = json.valueForKey("items") as! [NSDictionary]
            var albumArray = [Album]()
            for obj in array {
                let album = Album(json: obj)
                //album.artist = artist.name
                //album.genres = artist.genres
                albumArray.append(album)
            }
            self.delegate?.albumResults(albumArray)
        })
    }
    
    //MARK: Get Tracks
    func getAlbumTracks(id: String) {
        let url = SpotifyURL.getAlbumsTracks(id)
        let request = createRequest(url, method: "GET")
        createTask(request, completion: { json in
            let array = json.valueForKey("items") as! [NSDictionary]
            var trackArray = [Track]()
            for obj in array {
                let track = Track(json: obj)
                trackArray.append(track)
            }
            self.delegate?.trackResults(trackArray)
        })
    }
    
    func getArtistTopTracks(id: String) {
        let url = SpotifyURL.getArtistTopTracks(id)
        let request = createRequest(url, method: "GET")
        createTask(request, completion: { json in
            let array = json.valueForKey("tracks") as! [NSDictionary]
            var trackArray = [Track]()
            for obj in array {
                let track = Track(json: obj)
                trackArray.append(track)
            }
            self.delegate?.trackResults(trackArray)
        })
    }
}
//MARK: Delegate Declaration
protocol SpotifyAPIDelegate: class {
    func artistResults(artists: [Artist])
    func albumResults(albums: [Album])
    func trackResults(tracks: [Track])
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
        let urlString = baseURL + EndPoints.Artists.rawValue + "/" + id + "/albums"
        return NSURL(string: urlString)!
    }
    
    static func getArtistTopTracks(id: String) -> NSURL {
        //"https://api.spotify.com/v1/artists/3TVXtAsR1Inumwj472S9r4/top-tracks?country=ES"
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
    static func searchArtist(artist: String) -> NSURL {
        let urlString = baseURL + EndPoints.Search.rawValue + "?q=" + artist + "&type=artist"
        return NSURL(string: urlString)!
    }
}