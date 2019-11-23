//
//  Image+Common.swift
//  RecordKeep
//
//  Created by Mohanasundaram on 23/11/19.
//  Copyright © 2019 Task. All rights reserved.
//

import UIKit

extension UIImage {
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: quality.rawValue)
    }
}

extension UIImageView {
    
    func placeHolderImage(initial: String, bgColor: UIColor) {
        let initialLabel = UILabel()
        initialLabel.frame.size = self.frame.size
        initialLabel.textColor = Constants.Color.White
        initialLabel.text = initial
        initialLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        initialLabel.textAlignment = .center
        initialLabel.backgroundColor = bgColor
        initialLabel.layer.cornerRadius = 50.0
        
        UIGraphicsBeginImageContext(initialLabel.frame.size)
        initialLabel.layer.render(in: UIGraphicsGetCurrentContext()!)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}
