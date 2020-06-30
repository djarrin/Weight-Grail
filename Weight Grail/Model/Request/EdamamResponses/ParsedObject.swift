//
//  ParsedObject.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/30/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import Foundation

class ParsedObject: Codable {
    let food: Food
    let measure: Measure?
    let quantity: Double
}
