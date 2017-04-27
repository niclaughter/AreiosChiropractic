//
//  String+Extension.swift
//  Chiropractic
//
//  Created by Nicholas Laughter on 1/14/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    /*
     Encryption Keys
     */
    static var encryptionKey: String { get { return "MyChiro4Kids" } }
    
    /*
     Model Keys
     */
    // MARK: - Client Keys
    static var nameKey: String { get { return "name" } }
    static var kidsKey: String { get { return "kids" } }
    static var adultOrChildKey: String { get { return "adultOrChild" } }
    static var paymentTypeKey: String { get { return "paymentType" } }
    static var signatureDataStringKey: String { get { return "signatureDataString" } }
    static var signedInDateKey: String { get { return "signedInDate" } }
    static var identifierKey: String { get { return "identifier" } }
    static var signatureDownloadURLKey: String { get { return "signatureDownloadURL" } }
    
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
    static var myChiro4KidsURLString: String { get { return "http://mychiro4kids.com" } }
    
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
