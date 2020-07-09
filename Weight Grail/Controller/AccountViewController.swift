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
            let alert = UIAlertController(title: "Error", message: "Unable to logout", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
