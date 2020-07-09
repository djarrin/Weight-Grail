//
//  searchFoodViewController.swift
//  Weight Grail
//
//  Created by David Jarrin on 7/4/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import Foundation
import UIKit

class SearchFoodViewController: UITableViewController, UISearchBarDelegate {
        
    var logMealViewController: LogMealViewController?
    var searchResults: EdamamParsedResponse?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        searchBar.delegate = self
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.searchTextField.text {
            EdamamClient.foodSearchByWord(word: searchText) { (response, error) in
                if let response = response {
                    self.searchResults = response
                    self.tableView.reloadData()
                } else {
                    print(error)
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.hints?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell")!
        let food = searchResults?.hints?[(indexPath as NSIndexPath).row]

        cell.textLabel?.text = food?.food.label
        if var cal = food?.food.nutrients.cal {
            cal = cal.rounded(.up)
            cell.detailTextLabel?.text = "\(cal) Calories"
        } else {
            cell.detailTextLabel?.text = ""
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFood = searchResults?.hints?[(indexPath as NSIndexPath).row]
        logMealViewController?.addMeal(name: selectedFood?.food.label ?? "", nutrientsFacts: selectedFood?.food.nutrients)
        navigationController?.popViewController(animated: true)
    }
    
}
