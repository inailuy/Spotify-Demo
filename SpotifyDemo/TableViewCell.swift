//
//  TableViewCell.swift
//  SpotifyDemo
//
//  Created by inailuy on 9/12/16.
//  Copyright © 2016 yulz. All rights reserved.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
}

extension TableViewCell {
    
    func setCollectionViewDataSourceDelegate<D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>(dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false)
        collectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set {
            collectionView.contentOffset.x = newValue
        }
        
        get {
            return collectionView.contentOffset.x
        }
    }
}