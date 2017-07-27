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
        FirebaseApp.configure()
        
        // Check is there is a viable internet connection
        do {
            Network.reachability = try Reachability(hostname: "http://www.google.com")
            do {
                try Network.reachability?.start()
            } catch let error as Network.Error {
                NSLog(error.localizedDescription)
            } catch {
                NSLog(error.localizedDescription)
            }
        } catch {
            NSLog(error.localizedDescription)
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Checks if the TimeInterval for now is 15 seconds greater than the TimeInterval for when the app was resigned
        let timeIntervalSinceResigned = UserDefaults.standard.double(forKey: .appResignTimeIntervalKey)
        let currentTimeInterval = Date().timeIntervalSince1970
        NSLog("\nTime interval since resigned:\n\(timeIntervalSinceResigned)\nTime interval now:\n\(currentTimeInterval)")
        // If 15 seconds have passed since the app resigned, reloads to InitialViewController
        if timeIntervalSinceResigned + 15 < currentTimeInterval {
            window?.rootViewController = InitialViewController(nibName: nil, bundle: nil)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Saves TimeInterval when resigned
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: .appResignTimeIntervalKey)
    }
}
