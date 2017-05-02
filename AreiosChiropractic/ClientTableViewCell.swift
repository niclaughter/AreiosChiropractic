//
//  ClientTableViewCell.swift
//  Chiropractic
//
//  Created by Nicholas Laughter on 1/17/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import UIKit

class ClientTableViewCell: UITableViewCell {
    
    // MARK: - Properties

    var client: Client? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var clientDetailLabel: UILabel!
    
    // MARK: - Helpers
    
    func updateViews() {
        guard let client = client else { return }
        clientNameLabel.text = client.name
        clientDetailLabel.text = !client.kids.isEmpty ? client.kids : client.adultOrChild.rawValue
    }
}
