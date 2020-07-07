//
//  LogMealViewController.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/25/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import BarcodeScanner

class LogMealViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var databaseRef: DatabaseReference!
    let mealPickerData = ["Breakfast", "Lunch", "Dinner", "Snack", "Desert"]
    var selectedMeal = "Breakfast"
    var nutrients: Nutrients?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var mealPicker: UIPickerView!
    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var scanBarCodeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealPicker.delegate = self
        mealPicker.dataSource = self
        configureDatabaseRef()
        scanBarCodeButton.isHidden = !UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    @IBAction func searchByName() {
        let logMealViewController = self
        let searchByNameController = self.storyboard!.instantiateViewController(withIdentifier: "SearchFoodViewController") as! SearchFoodViewController
        searchByNameController.logMealViewController = logMealViewController
        self.navigationController?.pushViewController(searchByNameController, animated: true)
    }
    
    func addMeal(name: String, nutrientsFacts: Nutrients?) {
        mealLabel.text = name
        nutrients = nutrientsFacts
    }
    
    @IBAction func searchByBarcode() {
        let vc = BarcodeScannerViewController()
        vc.codeDelegate = self
        vc.errorDelegate = self
        vc.dismissalDelegate = self
        
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func logMeal() {
        print("selectedMeal \(selectedMeal)")
        print("nutrients \(nutrients)")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let dateString = formatter.string(from: datePicker.date)
        let basePath = "users/\(Auth.auth().currentUser!.uid)/meal-log/\(dateString)/\(selectedMeal)"
        
        databaseRef.child("\(basePath)/cal").setValue(nutrients?.cal)
        databaseRef.child("\(basePath)/fat").setValue(nutrients?.fat)
        databaseRef.child("\(basePath)/name").setValue(mealLabel.text)
        
        navigationController?.popViewController(animated: true)
    }
    
    func configureDatabaseRef() {
        databaseRef = Database.database().reference()
    }
    
    
}

extension LogMealViewController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
         print(code)
        EdamamClient.foodSearchByBarcode(barcode: code) { (response, error) in
            if let response = response {
                let firstFood = response.hints?[0]
                self.addMeal(name: firstFood?.food.label ?? "", nutrientsFacts: firstFood?.food.nutrients ?? nil)
            } else {
                print(error?.localizedDescription)
            }
            controller.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
      print(error)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
      controller.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mealPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mealPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedMeal = mealPickerData[row]
    }
}
