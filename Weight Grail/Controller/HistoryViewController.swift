//
//  HistoryViewController.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/21/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import UIKit
import Firebase

class HistoryViewController: UITableViewController {

    var ref: DatabaseReference!
    var weights: [DataSnapshot]! = []
    fileprivate var _refHandle: DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "History"
        configureDatabase()
    }
        
    deinit {
        let currentUserID = Auth.auth().currentUser!.uid
        ref.child("users").child(currentUserID).child("weight-log").removeObserver(withHandle: _refHandle)
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
        let currentUserID = Auth.auth().currentUser!.uid
        _refHandle = ref.child("users").child(currentUserID).child("weight-log").observe(.childAdded) { (snapshot: DataSnapshot)in
            self.weights.append(snapshot)
            self.tableView.reloadData()
        }
    }

}

extension HistoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weights.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeightCell")!
        let snapShot = weights[indexPath.row]
        let date = snapShot.key
        let weight = getWeight(snapShot: snapShot)
        
        cell.textLabel?.text = date
        cell.detailTextLabel?.text = "\(weight) lbs"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = weights[indexPath.row]
        
        let hvc = storyboard!.instantiateViewController(withIdentifier: "HistoryDetailViewController") as! HistoryDetailViewController
        hvc.weight = getWeight(snapShot: selected)
        hvc.date = selected.key
        hvc.imagePath = getImagePath(snapShot: selected)
        navigationController?.pushViewController(hvc, animated: true)
    }
    
    func getWeight(snapShot: DataSnapshot) -> Int {
        let weight = snapShot.childSnapshot(forPath: Constants.WeightFields.weight).value as? Int
        if let weight = weight {
            return weight
        }
        return 0
    }
    
    func getImagePath(snapShot: DataSnapshot) -> String? {
        let path = snapShot.childSnapshot(forPath: Constants.WeightFields.imagePath).value as? String
        if let path = path {
            return path
        }
        return nil
    }
    
}
