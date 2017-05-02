//
//  OfficeSignInTableViewController.swift
//  Chiropractic
//
//  Created by Nicholas Laughter on 1/23/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import UIKit

class OfficeSignInTableViewController: UITableViewController, SignatureCaptureDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var kidsTextField: UITextField!
    @IBOutlet weak var adultOrChildSelector: UISegmentedControl!
    @IBOutlet weak var paymentTypeTextField: UITextField!
    @IBOutlet weak var signatureView: SignatureCaptureView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var clearFormButton: UIButton!
    @IBOutlet weak var clearSignatureButton: UIButton!
    @IBOutlet weak var paymentTypePickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    // MARK: - User Actions
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        signInClient()
    }
    
    @IBAction func clearSignatureButtonTapped(_ sender: Any) {
        signatureView.clear()
    }
    
    @IBAction func clearFormButtonTapped(_ sender: Any) {
        presentClearFormAlertController()
    }
    
    // MARK: - SignatureCaptureDelegate
    
    func startedDrawing() {
        NSLog("Started drawing")
    }
    
    func finishedDrawing() {
        NSLog("Finished drawing")
    }
    
    // MARK: - UIPickerView DataSource/Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return PaymentType.wellness.rawValue
        case 1:
            return PaymentType.cash.rawValue
        case 2:
            return PaymentType.hsa.rawValue
        case 3:
            return PaymentType.personalInjury.rawValue
        case 4:
            return PaymentType.insurance.rawValue
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            paymentTypeTextField.text = PaymentType.wellness.rawValue
        case 1:
            paymentTypeTextField.text = PaymentType.cash.rawValue
        case 2:
            paymentTypeTextField.text = PaymentType.hsa.rawValue
        case 3:
            paymentTypeTextField.text = PaymentType.personalInjury.rawValue
        case 4:
            paymentTypeTextField.text = PaymentType.insurance.rawValue
        default:
            paymentTypeTextField.text = ""
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PaymentType.count
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            kidsTextField.becomeFirstResponder()
        case kidsTextField:
            textField.resignFirstResponder()
        case paymentTypeTextField:
            textField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == paymentTypeTextField {
            textField.text = PaymentType.wellness.rawValue
        }
    }
    
    // MARK: - Helper Methods
    
    func setUpViews() {
        tableView.tableFooterView = UIView()
        
        clearFormButton.titleLabel?.adjustsFontSizeToFitWidth = true
        clearSignatureButton.titleLabel?.adjustsFontSizeToFitWidth = true
        signInButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        signatureView.delegate = self
        tableView.isScrollEnabled = false
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .softBlue
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        paymentTypeTextField.inputAccessoryView = toolBar
        paymentTypeTextField.inputView = paymentTypePickerView
        
        paymentTypePickerView.selectRow(0, inComponent: 0, animated: false)
        
        headerImageView.animationImages = ImagesHelper.imagesArray
        headerImageView.animationDuration = 30
        headerImageView.startAnimating()
        headerImageView.layer.masksToBounds = true
    }
    
    func clearViews() {
        nameTextField.text = nil
        kidsTextField.text = nil
        adultOrChildSelector.selectedSegmentIndex = 0
        paymentTypeTextField.text = nil
        paymentTypePickerView.selectRow(0, inComponent: 0, animated: false)
        signatureView.clear()
    }
    
    @objc func donePicker() {
        let row = paymentTypePickerView.selectedRow(inComponent: 0)
        paymentTypePickerView.selectRow(row, inComponent: 0, animated: false)
        paymentTypeTextField.resignFirstResponder()
    }
    
    func signInClient() {
        guard let name = nameTextField.text,
            let kids = kidsTextField.text,
            let paymentTypeText = paymentTypeTextField.text,
            let signature = signatureView.getCroppedSignature(),
            !name.isEmpty, !paymentTypeText.isEmpty else {
                presentErrorSigningInAlertController()
                return
        }
        LoaderView.show(title: "Signing in", animated: true)
        let adultOrChild: AdultOrChild = adultOrChildSelector.selectedSegmentIndex == 0 ? .adult : .child
        var paymentType: PaymentType {
            switch paymentTypePickerView.selectedRow(inComponent: 0) {
            case 0:
                return .wellness
            case 1:
                return .cash
            case 2:
                return .hsa
            case 3:
                return .personalInjury
            case 4:
                return .insurance
            default:
                return .cash
            }
        }
        ImageController.shared.saveSignatureImageToDatabase(signature) { (identifier) in
            ClientController.shared.signInClient(withName: name, kids: kids, adultOrChild: adultOrChild, paymentType: paymentType, andIdentifier: identifier)
            self.clearViews()
            self.presentSignInSuccessfulAlertController()
            LoaderView.hide()
        }
    }
    
    func presentSignInSuccessfulAlertController() {
        let alertController = UIAlertController(title: "Sign in successful", message: "Thank you for signing in. You may have a seat if you'd like.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func presentErrorSigningInAlertController() {
        let alertController = UIAlertController(title: "Oops", message: "There was an error with your info. Please try again.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func presentClearFormAlertController() {
        let alertController = UIAlertController(title: "Clear form?", message: "Would you like to reset the whole form?", preferredStyle: .alert)
        let clearFormAction = UIAlertAction(title: "Clear form", style: .destructive) { (_) in
            self.clearViews()
        }
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(clearFormAction)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
}
