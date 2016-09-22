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
        let albumImageView = cell?.viewWithTag(100) as! UIImageView
        let titleLabel = cell?.viewWithTag(101) as! UILabel
        let detailLabel = cell?.viewWithTag(102) as! UILabel
        
        titleLabel.text = artist.name
        detailLabel.text = artist.followerString()
        if let img = artist.portraitImage() {
            albumImageView.loadImageFromPath(img.url)
            albumImageView.makeImageCircular()
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
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        view.window?.endEditing(true)
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
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        view.window?.endEditing(true)
    }
}
