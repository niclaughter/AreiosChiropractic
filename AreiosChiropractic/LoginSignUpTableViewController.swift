//
//  LoginSignUpTableViewController.swift
//  Chiropractic
//
//  Created by Nicholas Laughter on 1/17/17.
//  Copyright © 2017 Nicholas Laughter. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginSignUpTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var LogInSignUpStateButton: UIButton!
    @IBOutlet weak var LogInSignUpButton: UIButton!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var repeatPasswordCell: UITableViewCell!
    
    // MARK: - Properties
    
    var signUpState = true
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        headerImageView.layer.masksToBounds = true
    }
    
    // MARK: - TextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            passwordTextField.becomeFirstResponder()
        case 1:
            repeatPasswordTextField.becomeFirstResponder()
        case 2:
            resignFirstResponder()
            registerUser()
        default:
            break
        }
        return true
    }
    
    // MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // If not requesting sign up, repeat password field goes away
        if !signUpState && section == 2 {
            return 0
        }
        return super.tableView(tableView, heightForHeaderInSection: section)
    }
    
    // MARK: - UI Functions
    
    // Changes UI based on if requesting sign up or log in
    @IBAction func LogInSignUpStateButtonTapped(_ sender: Any) {
        signUpState = !signUpState
        repeatPasswordCell.isHidden = !signUpState
        if signUpState {
            LogInSignUpStateButton.setTitle("Click here to log in", for: .normal)
            LogInSignUpButton.setTitle("Register", for: .normal)
        } else {
            LogInSignUpStateButton.setTitle("Click here to sign up", for: .normal)
            LogInSignUpButton.setTitle("Sign In", for: .normal)
        }
        tableView.reloadData()
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        if signUpState {
            registerUser()
        } else {
            signInUser()
        }
    }
    
    // MARK: - Firebase Functions
    
    func registerUser() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text, password == repeatPasswordTextField.text else {
                displayAlertController()
                return
        }
        LoaderView.show(title: "Registering", animated: true)
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            self.handle(error: error)
            self.handle(user: user)
            LoaderView.hide()
        })
    }
    
    func signInUser() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text, !password.isEmpty else {
                displayAlertController()
                return
        }
        LoaderView.show(title: "Logging In", animated: true)
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            self.handle(error: error)
            self.handle(user: user)
            LoaderView.hide()
        })
    }
    
    // Displays a UIAlertController handling an error
    func handle(error: Error?) {
        if let error = error {
            displayAlertController(withErrorMessage: error.localizedDescription)
        }
    }
    
    // Based on state, takes user info and registers or authenticates, then handles transition
    func handle(user: User?) {
        guard let user = user,
            let email = user.email else { return }
        var accountType: AccountType = .user
        if signUpState {
            AccountController.shared.createAccount(withEmail: email, andIdentifier: user.uid)
            ViewTransitionManager.transitionToCorrectViewController(fromViewController: self, forAccountType: accountType)
        } else {
            AccountController.shared.fetchAccount(withIdentifier: user.uid, completion: { (returnedAccountType) in
                accountType = returnedAccountType
                ViewTransitionManager.transitionToCorrectViewController(fromViewController: self, forAccountType: accountType)
            })
        }
    }
    
    // MARK: - UIAlertController
    
    func displayAlertController(withErrorMessage errorMessage: String = "Please try again.") {
        let alertController = UIAlertController(title: "Oops!", message: "There was a problem.\n\(errorMessage)", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
}
