//
//  DateHelper.swift
//  Chiropractic
//
//  Created by Nicholas Laughter on 4/14/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import Foundation

struct DateHelper {
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
}
