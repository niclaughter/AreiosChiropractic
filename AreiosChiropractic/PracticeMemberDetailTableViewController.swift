//
//  ClientDetailTableViewController.swift
//  Chiropractic
//
//  Created by Nicholas Laughter on 3/1/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import UIKit

class ClientDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var kidsNamesLabel: UILabel!
    @IBOutlet weak var adultOrChildLabel: UILabel!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var timeCheckedInLabel: UILabel!
    @IBOutlet weak var signatureImageView: UIImageView!
    
    let dateHelper = DateHelper()
    
    var client: Client? {
        didSet {
            if !isViewLoaded {
                loadView()
            }
            updateViewsForClient()
        }
    }
    
    var signatureImage: UIImage? {
        didSet {
            if !isViewLoaded {
                loadView()
            }
            updateViewForSignatureImage()
        }
    }
    
    func updateViewsForClient() {
        guard let client = client else { return }
        nameLabel.text = client.name
        kidsNamesLabel.text = !client.kids.isEmpty ? client.kids : "No kids"
        adultOrChildLabel.text = client.adultOrChild.rawValue
        paymentTypeLabel.text = client.paymentType.rawValue
        timeCheckedInLabel.text = dateHelper.dateFormatter.string(from: client.signedInDate)
    }
    
    func updateViewForSignatureImage() {
        guard let signatureImage = signatureImage else { return }
        signatureImageView.image = signatureImage
    }
}
