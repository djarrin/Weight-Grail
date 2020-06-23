//
//  AuthViewController.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/19/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class AuthViewController: FormController, UITextFieldDelegate {
    
    @IBOutlet weak var email: PrimaryTextField!
    @IBOutlet weak var password: PrimaryTextField!
    @IBOutlet weak var loginButton: PrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        setUpTextFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setUpTextFields() {
        email.delegate = self
        password.delegate = self
        email.tag = 0
        password.tag = 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            password.becomeFirstResponder()
        case 1:
            if (email.text != "" && password.text != "") {
                login()
            } else {
                showErrorPrompt(header: "Invalid Inputs", message: "You must have values for both email and password fields.")
            }
        default:
            return true
        }
        return true
    }
    
    @IBAction func login() {
        Auth.auth().signIn(withEmail: email.text ?? "", password: password.text ?? "") { (result, error) in
             guard error == nil else {
               self.showErrorPrompt(header: "Registration Issue", message: error?.localizedDescription ?? "Error registering account")
               return
            }
            
            self.navigateToInit()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        readyToSubmit()
        return true
    }
    
    func readyToSubmit() {
        loginButton.isEnabled = (email.text != "" && password.text != "")
    }


}

extension AuthViewController {
    
    func firebaseLogin(_ credential: AuthCredential) {
        print("should be firing")
        Auth.auth().signIn(with: credential) { (result, error) in
            guard error == nil else {
               self.showErrorPrompt(header: "Registration Issue", message: error?.localizedDescription ?? "Error registering account")
               return
            }
            
            self.navigateToInit()
        }
    }
}
