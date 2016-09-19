//
//  AlbumTVC.swift
//  SpotifyDemo
//
//  Created by inailuy on 9/15/16.
//  Copyright © 2016 yulz. All rights reserved.
//

import Foundation
import UIKit

class AlbumTVC: UICollectionViewController {
    var artist = Artist()
    var selectedAlbum :Album?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = artist.name
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artist.albums.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("albumID", forIndexPath: indexPath)
        
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.layer.masksToBounds = true
        
        let color = Float(0.96)
        cell.contentView.backgroundColor = UIColor.init(colorLiteralRed: color, green: color, blue: color, alpha: 1.0)
        
        let album = artist.albums[indexPath.row]
        let albumImageView = cell.viewWithTag(100) as! UIImageView
        let titleLabel = cell.viewWithTag(101) as! UILabel
        albumImageView.makeCornersRound()

        albumImageView.loadImageFromPath(album.portraitImage()!.url)
        titleLabel.text = album.name
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedAlbum = artist.albums[indexPath.row]
        performSegueWithIdentifier(Segue.SongTVC.rawValue, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == Segue.SongTVC.rawValue {
            let vc = segue.destinationViewController as! SongTVC
            vc.title = selectedAlbum!.name
            vc.tracks = selectedAlbum!.tracks
        }
    }
}