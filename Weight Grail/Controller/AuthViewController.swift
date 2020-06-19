//
//  AuthViewController.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/19/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromAllNotifications()
    }
    
    func configureAuth() {
        
    }


}

extension AuthViewController {
    func subscribeToNotification(_ name: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
