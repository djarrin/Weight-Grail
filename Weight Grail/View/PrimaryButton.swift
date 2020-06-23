//
//  PrimaryButton.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/22/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import UIKit

class PrimaryButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        backgroundColor = UIColor.orangeSunset
        tintColor = UIColor.greenOlive
        
        //shadow effects
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 10.0
        layer.masksToBounds = false
    }
}

