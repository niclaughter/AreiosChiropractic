//
//  ClientListViewController.swift
//  Chiropractic
//
//  Created by Nicholas Laughter on 1/17/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import UIKit
import Firebase

class ClientListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ClientsControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var timeframeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var clientListTableView: UITableView!
    
    let viewPrinter = ViewPrinter()
    
    var clientsToDisplay = [Client]() {
        didSet {
            clientListTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        ClientController.shared.delegate = self
        clientListTableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source and delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .clientCellKey) as? ClientTableViewCell ?? ClientTableViewCell()
        let client = clientsToDisplay[indexPath.row]
        cell.client = client
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UI Actions
    
    @IBAction func segmentedControlSegmentChanged(_ sender: Any) {
        switch timeframeSegmentedControl.selectedSegmentIndex {
        case 0:
            getClients(forTimeframe: .today)
        case 1:
            getClients(forTimeframe: .yesterday)
        case 2:
            getClients(forTimeframe: .week)
        case 3:
            getClients(forTimeframe: .month)
        default:
            break
        }
    }
    
    @IBAction func printListButtonTapped(_ sender: Any) {
        if clientsToDisplay.count > 0 {
            viewPrinter.printData(forClients: clientsToDisplay, onPresentingViewController: self)
        } else {
            presentNoClientsAlertController()
        }
    }
    
    // MARK: - Practice Members Controller Delegate
    
    func clientsUpdated() {
        DispatchQueue.main.async {
            if self.clientsToDisplay.count == 0 {
                self.getClients(forTimeframe: .today)
            }
            self.clientListTableView.reloadData()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == .toClientDetailSegueKey {
            guard let destinationViewController = segue.destination as? ClientDetailTableViewController,
                let indexPath = clientListTableView.indexPathForSelectedRow else { return }
            let client = clientsToDisplay[indexPath.row]
            destinationViewController.client = client
            guard let identifier = client.identifier else { return }
            destinationViewController.signatureImage = ImageController.shared.imagesDict[identifier]
        }
    }

    // MARK: - Helper Methods
    
    func getClients(forTimeframe timeframe: Timeframe) {
        let today = Date()
        let calendar = Calendar.current
        var unsortedClients = [Client]()
        switch timeframe {
        case .today:
            unsortedClients = ClientController.shared.clients.filter { calendar.isDateInToday($0.signedInDate) }
        case .yesterday:
            unsortedClients = ClientController.shared.clients.filter { calendar.isDateInYesterday($0.signedInDate) }
        case .week:
            unsortedClients = ClientController.shared.clients.filter { calendar.isDate($0.signedInDate, equalTo: today, toGranularity: .weekOfMonth) }
        case .month:
            unsortedClients = ClientController.shared.clients.filter { calendar.isDate($0.signedInDate, equalTo: today, toGranularity: .month) }
        }
        clientsToDisplay = unsortedClients.sorted(by: { $0.0.signedInDate < $0.1.signedInDate })
    }
    
    func presentNoClientsAlertController() {
        let alertController = UIAlertController(title: "No Practice Members To Print!", message: "There aren't any Practice Members in this timeframe. Please pick another one to print from.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
}
