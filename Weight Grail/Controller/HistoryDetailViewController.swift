//
//  HistoryDetailViewController.swift
//  Weight Grail
//
//  Created by David Jarrin on 7/8/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class HistoryDetailViewController: UITableViewController {
    
    var date: String!
    var imagePath: String?
    var weight: Int!
    var storageRef: StorageReference!
    var dbRef: DatabaseReference!
    
    @IBOutlet weak var HistoryImage: UIImageView!
    @IBOutlet weak var WeightValueLabel: UILabel!
    @IBOutlet weak var CalorieValueLabel: UILabel!
    @IBOutlet weak var loadingIndicatior: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Weight Detial"
        downloadImage()
        WeightValueLabel.text = "\(String(describing: weight!)) lbs"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCalorieCount()
    }
    
    func setCalorieCount() {
        dbRef = Database.database().reference()
        let currentUserID = Auth.auth().currentUser!.uid
        dbRef.child("users").child(currentUserID).child(Constants.mealBase).child(date).observeSingleEvent(of: .value) { (snapshot) in
            var totalCalories = 0.0
            for meal in snapshot.children.allObjects as! [DataSnapshot] {
                let mealCal = meal.childSnapshot(forPath: Constants.MealFields.cal).value as? Double
                if let mealCal = mealCal {
                    totalCalories += mealCal
                }
            }
            self.CalorieValueLabel.text = "\(totalCalories.rounded())"
        }
    }
    
    func downloadImage() {
        if let imagePath = imagePath {
            storageRef = Storage.storage().reference(withPath: imagePath)
            storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
              if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
              } else {
                let image = UIImage(data: data!)
                self.HistoryImage.image = image
              }
              self.loadingIndicatior.stopAnimating()
            }
        } else {
            loadingIndicatior.stopAnimating()
        }
    }
    
}
