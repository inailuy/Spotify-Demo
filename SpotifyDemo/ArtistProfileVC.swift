//
//  ArtistProfileVC.swift
//  SpotifyDemo
//
//  Created by inailuy on 9/10/16.
//  Copyright © 2016 yulz. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

enum CellIdentifier : String {
    case IntroArtist, Albums, TopSongs, SimilarArtist, Followers, More
}

enum TableSection :Int {
    case Intro = 0 , TopSongs, Albums, SimilarArtist, Followers
}

class ArtistProfileVC: UITableViewController {
    var artist :Artist!
    var storedOffsets = [Int: CGFloat]()
    let model = generateRandomData()
    let cellLimit = 5
    
    let primaryColor = UIColor.whiteColor()
    let secondaryColor = UIColor.init(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    
    var selectedIndexPath :NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = artist.name
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(apiResults),
            name: NotificationKey.ArtistResultsKey.rawValue,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(apiResults),
            name: NotificationKey.TrackResultsKey.rawValue,
            object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: Spotify API Delegate
    func apiResults(notification: NSNotification){
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func albumResults(albums: [Album]) {
        print("albumResults")
        print(albums)
    }
    
    func trackResults(tracks: [Track]) {
        print("trackResults")
        print(tracks)
        
    }
    
    //MARK: TableView Delegate/Datasource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var id :String!
        switch indexPath.section {
        case TableSection.Intro.rawValue:
            id = CellIdentifier.IntroArtist.rawValue
            break
        case TableSection.TopSongs.rawValue:
            id = CellIdentifier.TopSongs.rawValue
            if indexPath.row == cellLimit {
                id = CellIdentifier.More.rawValue
            }
            break
        case TableSection.Albums.rawValue:
            id = CellIdentifier.Albums.rawValue
            if indexPath.row == cellLimit {
                id = CellIdentifier.More.rawValue
            }
            break
        case TableSection.SimilarArtist.rawValue:
            id = CellIdentifier.SimilarArtist.rawValue
            break
        case TableSection.Followers.rawValue:
            id = CellIdentifier.Followers.rawValue
            break
        default:
            id = ""
            break
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(id)
        cell!.backgroundColor = UIColor.clearColor()
        cell!.contentView.backgroundColor = primaryColor
        
        setupCell(cell!, indexPath: indexPath)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        if indexPath.section == TableSection.TopSongs.rawValue && indexPath.row < cellLimit {
            // play song
        } else if indexPath.section == TableSection.TopSongs.rawValue && indexPath.row == cellLimit {
            // open more tacks
            performSegueWithIdentifier(Segue.SongTVC.rawValue, sender: nil)
        } else if indexPath.section == TableSection.Albums.rawValue && indexPath.row < cellLimit {
            // open song list vc
            performSegueWithIdentifier(Segue.SongTVC.rawValue, sender: nil)
        } else if indexPath.section == TableSection.Albums.rawValue && indexPath.row == cellLimit {
            // open more albums
            performSegueWithIdentifier(Segue.AlbumTVC.rawValue, sender: nil)
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == TableSection.SimilarArtist.rawValue {
            guard let tableViewCell = cell as? TableViewCell else { return }
            tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        }
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == TableSection.SimilarArtist.rawValue {
            guard let tableViewCell = cell as? TableViewCell else { return }
            storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var value :Int!
        switch section {
        case TableSection.Intro.rawValue:
            value = 1
            break
        case TableSection.TopSongs.rawValue:
            value = artist.topSongs.count > cellLimit ? 6 : artist.topSongs.count
            break
        case TableSection.Albums.rawValue:
            value = artist.albums.count > cellLimit ? 6 : artist.albums.count
            break
        case TableSection.SimilarArtist.rawValue:
            value = 1
            break
        case TableSection.Followers.rawValue:
            value = 1
            break
        default:
            value = 0
            break
        }
        return value
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case TableSection.TopSongs.rawValue, TableSection.Albums.rawValue, TableSection.SimilarArtist.rawValue:
            return 43
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title :String!
        switch section {
        case TableSection.TopSongs.rawValue:
            if artist.topSongs.count == 0 {
                return nil
            }
            title = "Popular Tracks"
            break
        case TableSection.Albums.rawValue:
            if artist.albums.count == 0 {
                return nil
            }
            title = "Albums"
            break
        case TableSection.SimilarArtist.rawValue:
            title = "Similar Artist"
            break
        default:
            return nil
        }
        return createSectionHeaderView(title)
    }
    
    func createSectionHeaderView(title: String) -> UIView {
        let frame = CGRectMake(20, 0, view.bounds.size.width, 55)
        let headerView = UIView(frame: frame)
        let label = UILabel(frame: frame)
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 25.0)
        
        let style = NSParagraphStyle.defaultParagraphStyle().mutableCopy()
        let attrText = NSAttributedString(string: title, attributes: [NSParagraphStyleAttributeName: style])
        label.numberOfLines = 0
        label.attributedText = attrText
        
        headerView.addSubview(label)
        headerView.backgroundColor = secondaryColor
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height :CGFloat!
        
        switch indexPath.section {
        case TableSection.Intro.rawValue:
            height = 150
            break
        case TableSection.TopSongs.rawValue:
            height = artist.topSongs.count > 0 ? 45 : 0
            if indexPath.row == cellLimit {
                    height = 45
            }
            break
        case TableSection.Albums.rawValue:
            height = artist.albums.count > 0 ? 85 : 0
            if indexPath.row == cellLimit {
                height = 45
            }
            break
        case TableSection.SimilarArtist.rawValue:
            height = 95
            break
        case TableSection.Followers.rawValue:
            height = 130
            break
        default:
            height = 0
            break
        }
        return height
    }
    
    func setupCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        switch indexPath.section {
        case TableSection.Intro.rawValue:
            print(indexPath)
            setupIntroCell(cell)
            break
        case TableSection.TopSongs.rawValue:
            if indexPath.row < cellLimit {
              setupTopSongsCell(cell, indexPath: indexPath)
            } else {
                setupSeeAll(cell, string: "Songs")
            }
            
            break
        case TableSection.Albums.rawValue:
            if indexPath.row < cellLimit {
                setupAlbumCell(cell, indexPath: indexPath)
            } else {
                setupSeeAll(cell, string: "Albums")
            }
            break
        default:
            break
        }
    }
    
    func setupIntroCell(cell: UITableViewCell) {
        let backgroundImageView = cell.viewWithTag(100) as! UIImageView
        let artistImageView = cell.viewWithTag(101) as! UIImageView
        let followerLabel = cell.viewWithTag(102) as! UILabel

        if let temp = artist.portraitImage()?.url! {
            backgroundImageView.loadImageFromPath(temp)
        }
        if let temp = artist.portraitImage()?.url! {
            artistImageView.loadImageFromPath(temp)
            artistImageView.makeImageCircular()
        }
        followerLabel.text = String(artist.followerString())
        
    }
    
    func setupTopSongsCell(cell: UITableViewCell, indexPath:NSIndexPath) {
        let track = artist.topSongs[indexPath.row]
        let titleLabel = cell.viewWithTag(100) as! UILabel
        
        let text = String(indexPath.row + 1) + ". " + track.name
        titleLabel.text = text
    }
    
    func setupAlbumCell(cell: UITableViewCell, indexPath:NSIndexPath) {
        let albumImageView = cell.viewWithTag(100) as! UIImageView
        let titleLabel = cell.viewWithTag(101) as! UILabel
        let explicitLabel = cell.viewWithTag(102) as! UILabel
        
        let album = artist.albums[indexPath.row]
        if let temp = album.portraitImage()?.url! {
            albumImageView.loadImageFromPath(temp)
        }
        titleLabel.text = album.name
        if album.explicit == true {
            explicitLabel.hidden = false
        }
    }
    
    func setupSeeAll(cell: UITableViewCell, string: String) {
        let label = cell.viewWithTag(100) as! UILabel
        label.text = "See all " + string
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == Segue.ArtistProfileVC.rawValue {
            let vc = segue.destinationViewController as! ArtistProfileVC
            vc.artist = artist
        } else if segue.identifier == Segue.SongTVC.rawValue {
            let vc = segue.destinationViewController as! SongTVC
            if selectedIndexPath?.section == TableSection.TopSongs.rawValue {
                vc.title = "Top Songs"
                vc.tracks = artist.topSongs
            } else if selectedIndexPath?.section == TableSection.Albums.rawValue {
                let album = artist.albums[selectedIndexPath!.row]
                vc.title = album.name
                vc.tracks = album.tracks
            }
        } else if segue.identifier == Segue.AlbumTVC.rawValue {
            let vc = segue.destinationViewController as! AlbumTVC
            vc.artist = artist
        }
    }
}

extension ArtistProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artist.similarArtists.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        let similarArtist = artist.similarArtists[indexPath.row]
        let iv = cell.viewWithTag(100) as! UIImageView
        iv.makeImageCircular()
        iv.loadImageFromPath(similarArtist.portraitImage()!.url)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        
        let selectedArtist = artist.similarArtists[indexPath.row]
        artist = selectedArtist
        artist?.loadAdditionalResources()
        performSegueWithIdentifier(Segue.ArtistProfileVC.rawValue, sender: nil)
    }
}