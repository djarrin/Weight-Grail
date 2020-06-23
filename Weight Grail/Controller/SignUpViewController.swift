//
//  SignUpViewController.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/23/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: FormController, UITextFieldDelegate {
    @IBOutlet weak var email: PrimaryTextField!
    @IBOutlet weak var password: PrimaryTextField!
    @IBOutlet weak var signUpButton: PrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readyToSubmit()
        setUpTextFields()
    }
    
    @IBAction func signUp() {
        Auth.auth().createUser(withEmail: email.text ?? "", password: password.text ?? "") { (result, error) in
            guard error == nil else {
                self.showErrorPrompt(header: "Registration Issue", message: error?.localizedDescription ?? "Error registering account")
                return
            }
            
            self.navigateToInit()
        }
    }
    
    @IBAction func backToSignUp() {
        dismiss(animated: true, completion: nil)
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
                signUp()
            } else {
                showErrorPrompt(header: "Invalid Inputs", message: "You must have values for both email and password fields.")
            }
        default:
            return true
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        readyToSubmit()
        return true
    }
    
    func readyToSubmit() {
        signUpButton.isEnabled = (email.text != "" && password.text != "")
    }
}
