//
//  Client.swift
//  Chiropractic
//
//  Created by Nicholas Laughter on 1/14/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import Foundation
import UIKit

struct Client: FirebaseType, Equatable {
    
    let name: String
    let kids: String
    let adultOrChild: AdultOrChild
    let paymentType: PaymentType
    var identifier: String?
    let signedInDate: Date
    var endpoint: String = .clientsEndpoint
    
    var dictionaryCopy: JSONDictionary {
        return [
            .nameKey: name,
            .kidsKey: kids,
            .adultOrChildKey: adultOrChild.rawValue,
            .paymentTypeKey: paymentType.rawValue,
            .signedInDateKey: signedInDate.timeIntervalSince1970
        ]
    }
    
    init(name: String,
         kids: String,
         adultOrChild: AdultOrChild,
         paymentType: PaymentType,
         identifier: String,
         accountType: AccountType = .user,
         signedInDate: Date = Date()) {
        self.name = name
        self.kids = kids
        self.adultOrChild = adultOrChild
        self.paymentType = paymentType
        self.identifier = identifier
        self.signedInDate = signedInDate
    }
    
    init?(dictionary: JSONDictionary, identifier: String) {
        guard let name = dictionary[.nameKey] as? String,
            let kids = dictionary[.kidsKey] as? String,
            let adultOrChildString = dictionary[.adultOrChildKey] as? String,
            let paymentTypeString = dictionary[.paymentTypeKey] as? String,
            let signedInTimeInterval = dictionary[.signedInDateKey] as? TimeInterval
            else { return nil }
        self.identifier = identifier
        self.name = name
        self.kids = kids
        self.signedInDate = Date(timeIntervalSince1970: signedInTimeInterval)
        
        switch adultOrChildString {
        case AdultOrChild.child.rawValue:
            self.adultOrChild = .child
        default:
            self.adultOrChild = .adult
        }
        
        switch paymentTypeString {
        case PaymentType.wellness.rawValue:
            self.paymentType = .wellness
        case PaymentType.cash.rawValue:
            self.paymentType = .cash
        case PaymentType.hsa.rawValue:
            self.paymentType = .hsa
        case PaymentType.personalInjury.rawValue:
            self.paymentType = .personalInjury
        default:
            self.paymentType = .insurance
        }
    }
}

func ==(lhs: Client, rhs: Client) -> Bool {
    return lhs.identifier == rhs.identifier
}
