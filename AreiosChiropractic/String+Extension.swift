//
//  String+Extension.swift
//  Chiropractic
//
//  Created by Nicholas Laughter on 1/14/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import Foundation

extension String {
    
    // MARK: - Capitalizes only the first letter in a String
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
        
    fileprivate func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    /*
     Encryption Keys
     */
    static var encryptionKey: String { get { return "qyhvu7AMbNaWrCZ94Gpg94vVzxVMEt8CQHuPx6VVtWBC8Rbs9SEBf8vJuucVY8jKrnN25KFDzEcSAqSm8WAuNsAw8MNLXphr6CgHzBEGbdZtt9QsR4wyaMwnyeVCSnUf" } }
    
    /*
     Persistence Keys
     */
    static var appResignTimeIntervalKey: String { get { return "appResignTimeInterval" } }
    
    /*
     Model Keys
     */
    // MARK: - Client Keys
    static var nameKey: String { get { return "fhseK3TKAMEsr9k4" } }
    static var kidsKey: String { get { return "4TwtGHwKM3meUUv4" } }
    static var adultOrChildKey: String { get { return "bvh59jJhBxXUKKBZ" } }
    static var paymentTypeKey: String { get { return "T3um2sMdSWYD75hc" } }
    static var signatureDataStringKey: String { get { return "DrLLsHkxxBG3HHDE" } }
    static var signedInDateKey: String { get { return "dmHB3C549xYEdyRT" } }
    static var identifierKey: String { get { return "identifier" } }
    static var signatureDownloadURLKey: String { get { return "4FY2MNEzmNA9dHLE" } }
    
    // MARK: - Account Keys
    static var emailKey: String { get { return "email" } }
    static var accountTypeKey: String { get { return "accountType" } }
    
    /*
     Firebase Keys
     */
    static var clientsEndpoint: String { get { return "clients" } }
    static var accountsEndpoint: String { get { return "accounts" } }
    static var imagesEndpoint: String { get { return "images" } }
    static var signaturesEndpoint: String { get { return "signatures" } }
    
    /*
     URL Strings
     */
    static var homeURLString: String { get { return "http://niclaughter.com/portfolio" } }
    
    /*
     Reuse Identifiers
     */
    static var clientCellKey: String { get { return "clientCell" } }
    
    /*
     Segue Identifiers
     */
    static var toClientDetailSegueKey: String { get { return "toClientDetailSegue" } }
    
    /*
     Storyboard IDs
     */
    static var iPadSignInViewControllerKey: String { get { return "iPadSignInNavigationController" } }
    static var loginSignUpViewControllerKey: String { get { return "loginSignUpViewController" } }
    static var webViewControllerKey: String { get { return "webViewController" } }
    static var adminNavigationControllerKey: String { get { return "adminNavigationController" } }
    
    /*
     User-Facing String Keys
     */
    static var timestampDisplayKey: String { get { return "Timestamp" } }
    static var nameDisplayKey: String { get { return "Name" } }
    static var kidsDisplayKey: String { get { return "Kids" } }
    static var ageDisplayKey: String { get { return "Age" } }
    static var paymentTypeDisplayKey: String { get { return "Payment Type" } }
    static var signatureDisplayKey: String { get { return "Signature" } }
}
