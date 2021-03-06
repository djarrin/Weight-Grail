//
//  ViewController.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/18/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import UIKit
import Firebase

class InitViewController: UITabBarController {

    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    var user: User?
    var displayName = "Anonymous"
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAuth()
    }

    func configureAuth() {
            
        // listen for changes in the authorization state
        _authHandle = Auth.auth().addStateDidChangeListener { (auth: Auth, user: User?) in
            // check if there is a current user
            if let activeUser = user {
                // check if the current app user is the current FIRUser
                if self.user != activeUser {
                    self.user = activeUser
                    let name = user!.email!.components(separatedBy: "@")[0]
                    self.displayName = name
                }
            } else {
                // user must sign in
                self.loginSession()
            }
        }
    }
    
    func loginSession() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController")
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }
        
}

