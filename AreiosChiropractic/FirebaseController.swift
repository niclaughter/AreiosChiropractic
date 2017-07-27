//
//  FirebaseController.swift
//  Chiropractic
//
//  Created by Nicholas Laughter on 1/16/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import Foundation
import Firebase

class FirebaseController {
    
    static let shared = FirebaseController()
    static let databaseRef = Database.database().reference()
    static let storageRef = Storage.storage().reference()
}

protocol FirebaseType {
    
    var endpoint: String { get }
    var identifier: String? { get set }
    var dictionaryCopy: [String: Any] { get }
    
    init?(dictionary: JSONDictionary, identifier: String)
    
    mutating func save()
    func delete()
}

extension FirebaseType {
    
    mutating func save() {
        var newEndpoint = FirebaseController.databaseRef.child(endpoint)
        if let identifier = identifier {
            newEndpoint = newEndpoint.child(identifier)
        } else {
            newEndpoint = newEndpoint.childByAutoId()
            self.identifier = newEndpoint.key
        }
        newEndpoint.updateChildValues(dictionaryCopy)
    }
    
    func delete() {
        guard let identifier = identifier else { return }
        FirebaseController.databaseRef.child(endpoint).child(identifier).removeValue()
    }
}
