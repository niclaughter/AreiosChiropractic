//
//  AppDelegate.swift
//  AreiosChiropractic
//
//  Created by Nicholas Laughter on 4/26/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        return true
    }
}
