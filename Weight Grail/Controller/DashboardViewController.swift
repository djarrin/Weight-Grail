//
//  DashboardViewController.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/21/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import UIKit
import Charts
import Firebase

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var lastDateLogged: UILabel!
    @IBOutlet weak var lastWeightLogged: UILabel!
    @IBOutlet weak var lastCalorieLogged: UILabel!
    
    var ref: DatabaseReference!
    var weights: [DataSnapshot]! = []
    var meals: [DataSnapshot]! = []
    fileprivate var _weightRefHandle: DatabaseHandle!
    fileprivate var _mealRefHandle: DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Dashboard"
        lineChart.noDataText = "No weights have been logged"
        configureDatabase()
    }

    deinit {
        let currentUserID = Auth.auth().currentUser!.uid
        ref.child("users").child(currentUserID).child(Constants.weightBase).removeObserver(withHandle: _weightRefHandle)
        ref.child("users").child(currentUserID).child(Constants.mealBase).removeObserver(withHandle: _mealRefHandle)
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
        let currentUserID = Auth.auth().currentUser?.uid
        if let currentUserID = currentUserID {
            _weightRefHandle = ref.child("users").child(currentUserID).child(Constants.weightBase).observe(.childAdded) { (snapshot: DataSnapshot)in
                self.weights.append(snapshot)
                self.setChartData()
                self.setLastWeightLoggedData()
            }
            _mealRefHandle = ref.child("users").child(currentUserID).child(Constants.mealBase).observe(.childAdded) { (snapshot: DataSnapshot)in
                self.meals.append(snapshot)
                self.setLastMealLoggedData()
            }
        }
    }
    
    func setLastWeightLoggedData() {
        if weights.count > 0 {
            let lastWeight = weights[weights.count-1]
            let lastWeightValue = lastWeight.childSnapshot(forPath: Constants.WeightFields.weight).value as! Double
            lastDateLogged.text = lastWeight.key
            lastWeightLogged.text = "\(lastWeightValue) lbs"
        }
    }
    
    func setLastMealLoggedData() {
        var totalCalories = 0.0
        for meal in meals[meals.count-1].children.allObjects as! [DataSnapshot] {
            let mealCal = meal.childSnapshot(forPath: Constants.MealFields.cal).value as? Double
            if let mealCal = mealCal {
                totalCalories += mealCal
            }
        }
        lastCalorieLogged.text = "\(totalCalories) Calories"
    }
    
    func setChartData() {
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<weights.count {
            let weight = weights[i].childSnapshot(forPath: Constants.WeightFields.weight).value as! Double
            let value = ChartDataEntry(x: Double(i), y: weight)
            lineChartEntry.append(value)
        }
        
        //Add data to line
        let line = LineChartDataSet(entries: lineChartEntry, label: "Weights")
        
        //Configure line appearance
        line.colors = [.blueSky]
        line.drawCirclesEnabled = false
        line.mode = .cubicBezier
        
        let data = LineChartData()
        data.addDataSet(line)
        
        lineChart.data = data
        
        //Configure chart
        lineChart.rightAxis.enabled = false
        lineChart.xAxis.enabled = false
        lineChart.chartDescription?.text = "Weights (lbs) over time"
    }
}
