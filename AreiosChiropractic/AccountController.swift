//
//  AccountController.swift
//  Chiropractic
//
//  Created by Nicholas Laughter on 1/18/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import Foundation
import Firebase

class AccountController {
    
    static let shared = AccountController()
    
    var account: Account?
    
    // Saves account info in Firebase Database to allow schema customization
    func createAccount(withEmail email: String, andIdentifier identifier: String) {
        var account = Account(email: email, identifier: identifier)
        account.save()
    }
    
    // Checks account type against Firebase Database copy to establish starting point for usage
    func fetchAccount(withIdentifier identifier: String? = nil, completion: @escaping (AccountType) -> Void) {
        guard let identifier = identifier else {
            completion(.initial)
            return
        }
        let accountRef = FirebaseController.databaseRef.child(.accountsEndpoint).child(identifier)
        accountRef.observeSingleEvent(of: .value, with: { (data) in
            guard let accountDict = data.value as? [String: Any] else {
                completion(.initial)
                return
            }
            guard let account = Account(dictionary: accountDict, identifier: identifier) else { return }
            completion(account.accountType)
        })
    }
}
