//
//  AppDelegate.swift
//  SpotifyDemo
//
//  Created by inailuy on 9/8/16.
//  Copyright © 2016 yulz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let barButtonAppearance = [NSFontAttributeName : UIFont(name: helveticaLightFont, size: 16)!]
        let navBarApearance = [NSFontAttributeName : UIFont(name: helveticaMediumFont, size: 33)!,
                               NSForegroundColorAttributeName: UIColor.blackColor()]
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAppearance, forState: .Normal)
        UINavigationBar.appearance().titleTextAttributes = navBarApearance
 
        return true
    }
}