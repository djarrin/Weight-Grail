//
//  ViewController.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/18/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class InitViewController: UIViewController {

    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    var user: User?
    var displayName = "Anonymous"
    
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
                    self.signedInStatus(isSignedIn: true)
                    let name = user!.email!.components(separatedBy: "@")[0]
                    self.displayName = name
                }
            } else {
                // user must sign in
                self.signedInStatus(isSignedIn: false)
                self.loginSession()
            }
        }
    }
    
    func loginSession() {
        let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
        present(authViewController, animated: true, completion: nil)
    }
        
    func signedInStatus(isSignedIn: Bool) {

        
        if isSignedIn {
            
//            subscribeToKeyboardNotifications()
//            configureDatabase()
//            configureStorage()
//            configureRemoteConfig()
//            fetchConfig()
        }
    }


}

