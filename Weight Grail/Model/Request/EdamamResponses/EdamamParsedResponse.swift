//
//  EdamamParsedResponse.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/26/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import Foundation

struct EdamamParsedResponse: Codable {
    let text: String?
    let parsed: [ParsedObject]?
    let hints: [HintsObject]?
}
