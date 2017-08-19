//
//  RightImagedButton.swift
//  iOptic
//
//  Created by Santhosh on 04/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

import UIKit


@objc open class RightImagedButton: TextImageButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.imageOnRight = true
        self.layer.borderWidth = 1.0
        self.spacing = 2.0
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 5.0
    }

}
