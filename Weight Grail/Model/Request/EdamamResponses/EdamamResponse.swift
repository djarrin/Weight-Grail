//
//  EdamamResponse.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/26/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import Foundation

struct EdamamResponse: Codable {
    // incase of error, not available when no error is there
    let status: String?
    let message: String?
}

extension EdamamResponse: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
