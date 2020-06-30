//
//  FoodObject.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/26/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import Foundation

class Food: Codable {
    let foodId: String
    let label: String
    let category: String
    let categoryLabel: String
    let servingsPerContainer: Double
    let nutrients: Nutrients
}

class Nutrients: Codable {
    let cal: Double
    let procnt: Double
    let fat: Double
    let chocdf: Double
    let fibtg: Double
    
    
    enum CodingKeys: String, CodingKey {
        case cal = "ENERC_KCAL"
        case procnt = "PROCNT"
        case fat = "FAT"
        case chocdf = "CHOCDF"
        case fibtg = "FIBTG"
    }
}

class Measure: Codable {
    let uri: String
    let label: String
}
