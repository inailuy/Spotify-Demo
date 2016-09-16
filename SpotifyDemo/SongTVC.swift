//
//  SongTVC.swift
//  SpotifyDemo
//
//  Created by inailuy on 9/15/16.
//  Copyright © 2016 yulz. All rights reserved.
//

import Foundation
import UIKit

class SongTVC: UITableViewController {
    var tracks = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(tracks)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("songID")
        let track = tracks[indexPath.row]
        
        let songLabel = cell?.viewWithTag(100) as! UILabel
        let explicitLabel = cell?.viewWithTag(101) as! UILabel
        let durationLabel = cell?.viewWithTag(102) as! UILabel
        
        songLabel.text = String(indexPath.row) + ". " + track.name
        explicitLabel.hidden = !track.explicit.boolValue
        durationLabel.text = track.length()
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(75)
    }
    
}