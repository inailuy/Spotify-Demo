//
//  SearchVC.swift
//  SpotifyDemo
//
//  Created by inailuy on 9/10/16.
//  Copyright © 2016 yulz. All rights reserved.
//

import Foundation
import UIKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var artistsArray = [Artist]()
    var selectedArtist :Artist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Discover"
        SpotifyAPI.sharedInstance.getArtists("lil", withCompletion: { artistArray in
            self.artistsArray = artistArray
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.tableView.reloadData()
            }
        })
    }
    
    //MARK: TableView Delegate/Datasource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellId")
        let artist = artistsArray[indexPath.row]
        
        cell?.textLabel?.text = artist.name
        cell?.detailTextLabel?.text = artist.followers.stringValue + " followers"
        
        if let img = artist.portraitImage() {
            cell?.imageView?.image = UIImage()
            cell?.imageView?.loadImageFromPath(img.url)
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedArtist = artistsArray[indexPath.row]
        selectedArtist?.loadAdditionalResources()
        performSegueWithIdentifier(Segue.ArtistProfileVC.rawValue, sender: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistsArray.count
    }
    
    //MARK: SeachBar Delegate
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            return
        }
        
        SpotifyAPI.sharedInstance.getArtists(searchBar.text!, withCompletion: { artistArray in
            self.artistsArray = artistArray
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.tableView.reloadData()
            }
        })
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
        print(searchBar.text)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        print(searchBar.text)
    }
    
    //MARK: Spotify API Delegate
    func artistResults(notification: NSNotification){
        artistsArray = notification.object as! [Artist]
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == Segue.ArtistProfileVC.rawValue {
            let vc = segue.destinationViewController as! ArtistProfileVC
            vc.artist = selectedArtist
        }
    }
}
