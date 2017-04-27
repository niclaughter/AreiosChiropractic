//
//  PrinterLabel.swift
//  Chiropractic
//
//  Created by Nicholas Laughter on 4/14/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import UIKit

class PrinterLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}
