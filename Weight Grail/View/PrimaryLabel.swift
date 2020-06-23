//
//  PrimaryLabel.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/22/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import UIKit

class PrimaryLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        textColor = UIColor.orangeSunset
    }
}
