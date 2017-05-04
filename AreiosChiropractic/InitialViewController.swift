//
//  InitialViewController.swift
//  Chiropractic
//
//  Created by Nicholas Laughter on 3/2/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import UIKit
import FirebaseAuth
import LocalAuthentication

class InitialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        authenticateUser()
        setUpLoader()
    }
    
    // If biometrics are available, utilizes them to authenticate user
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        let localizedReasonString = "Authentication is required"
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReasonString, reply: { (success, error) in
                if success {
                    NSLog("Authentication successful")
                    self.setUpAppUsage()
                } else {
                    NSLog("Authentication unsuccessful\n\(error ?? NSError())")
                    DispatchQueue.main.sync {
                        context.invalidate()
                    }
                }
            })
        } else {
            setUpAppUsage()
        }
    }
    
    // Forwards app to appropriate ViewController based on user account type
    func setUpAppUsage() {
        if FIRAuth.auth()?.currentUser != nil {
            checkUserAgainstDatabase { (success, _) in
                if success,
                    let currentUser = FIRAuth.auth()?.currentUser {
                    LoaderView.show(title: "Fetching Profile", animated: true)
                    AccountController.shared.fetchAccount(withIdentifier: currentUser.uid, completion: { (accountType) in
                        ViewTransitionManager.transitionToCorrectViewController(fromViewController: self, forAccountType: accountType)
                        LoaderView.hide()
                    })
                } else {
                    ViewTransitionManager.transitionToCorrectViewController(fromViewController: self, forAccountType: .initial)
                }
            }
        } else {
            ViewTransitionManager.transitionToCorrectViewController(fromViewController: self, forAccountType: .initial)
        }
    }
    
    // Retrieves account type from Firebase Database
    func checkUserAgainstDatabase(_ completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        guard let currentUser = FIRAuth.auth()?.currentUser else { return }
        // If user account has been deleted, will return nil for user
        currentUser.getTokenForcingRefresh(true) { (_, error) in
            if let error = error {
                completion(false, error as NSError?)
                print(error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
    
    // MARK: - Loader
    
    func setUpLoader() {
        var config = LoaderView.Config()
        config.size = 150
        config.spinnerColor = .softGray
        config.spinnerLineWidth = 3
        config.foregroundColor = .softBlack
        config.foregroundAlpha = 0.5
        LoaderView.setConfig(config: config)
    }
}
