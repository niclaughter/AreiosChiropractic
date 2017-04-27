//
//  Enums.swift
//  Chiropractic
//
//  Created by Nicholas Laughter on 1/14/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import Foundation
import UIKit

enum AdultOrChild: String {
    case adult = "18+"
    case child = "under 18"
}

enum PaymentType: String {
    case wellness = "Wellness"
    case cash = "Cash"
    case hsa = "H.S.A."
    case personalInjury = "Personal Injury"
    case insurance = "Insurance"
    
    static var count: Int { return PaymentType.insurance.hashValue + 1 }
}

enum AccountType: String {
    case admin = "admin"
    case office = "office"
    case user = "user"
    case initial = "initial"
}

enum Timeframe {
    case today
    case yesterday
    case week
    case month
}
