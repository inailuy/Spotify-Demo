//
//  AudioController.swift
//  SpotifyDemo
//
//  Created by inailuy on 9/19/16.
//  Copyright © 2016 yulz. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class AudioController {
    var player :AVPlayer!
    static let sharedInstance = AudioController()
    
    func playPreview(URLString:String) {        
        let url = NSURL(string: URLString)
        player = AVPlayer(URL: url!)
        player.play()
    }
}