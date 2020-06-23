//
//  FormController.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/23/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import UIKit
import Firebase

class FormController: UIViewController {
    
    
    func showErrorPrompt(header: String, message: String) {
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigateToInit() {
        // just push back to init if there is no error and it will handle setting user data
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initViewController = storyboard.instantiateViewController(withIdentifier: "InitViewController")
        initViewController.modalPresentationStyle = .fullScreen
        present(initViewController, animated: true, completion: nil)
    }
}
