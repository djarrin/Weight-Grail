//
//  AccountViewController.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/23/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Account"
    }
    
    @IBAction func logout(){
        do {
           try Auth.auth().signOut()
        } catch {
            // TODO:: put an alert here saying logout failed
        }
    }

}
