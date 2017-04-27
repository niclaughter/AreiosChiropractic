//
//  ClientController.swift
//  Chiropractic
//
//  Created by Nicholas Laughter on 1/18/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import Foundation
import UIKit

class ClientController {
    
    static let shared = ClientController()
    
    var clients = [Client]() {
        didSet {
            delegate?.clientsUpdated()
            for client in clients {
                ImageController.shared.fetchImage(forClient: client)
            }
        }
    }
    var delegate: ClientsControllerDelegate?
    
    // MARK: - Functions
    
    init() {
        observeClients {
            NSLog("Practice members being observed.")
        }
    }
    
    func signInClient(withName name: String,
                              kids: String,
                              adultOrChild: AdultOrChild,
                              paymentType: PaymentType,
                              andIdentifier identifier: String,
                              completion: @escaping () -> Void = { _ in }) {
        var client = Client(name: name, kids: kids, adultOrChild: adultOrChild, paymentType: paymentType, identifier: identifier)
        client.save()
        completion()
    }
    
    func observeClients(completion: @escaping () -> Void = { _ in }) {
        defer { completion() }
        let clientsRef = FirebaseController.databaseRef.child(.clientsEndpoint)
        clientsRef.observe(.value, with: { (snapshot) in
            guard let clientsDict = snapshot.value as? [String: JSONDictionary] else { return }
            self.clients = clientsDict.flatMap { Client(dictionary: $1, identifier: $0) }
        })
    }
}

protocol ClientsControllerDelegate {
    func clientsUpdated()
}
