//
//  PrimaryTextField.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/22/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import UIKit

class PrimaryTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var placeholderColor: UIColor = .lightGray

    override var placeholder: String? {
        didSet {
            let attributes = [ NSAttributedString.Key.foregroundColor: placeholderColor ]
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: attributes)
        }
    }
    
}

