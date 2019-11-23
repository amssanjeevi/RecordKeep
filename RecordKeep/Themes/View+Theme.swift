//a
//  View+Theme.swift
//  RecordKeep
//
//  Created by Mohanasundaram on 22/11/19.
//  Copyright © 2019 Task. All rights reserved.
//

import UIKit

extension UIView {
    
    func applyWhiteContainerTheme() {
        backgroundColor = Constants.Color.White
    }
    
    func applyViewBorder() {
        layer.borderWidth = 2
        layer.borderColor = Constants.Color.Border.cgColor
    }
    
    func applyRoundRadius() {
        clipsToBounds = true
        layer.cornerRadius = frame.size.height/2
    }
    
    func applyCornerRadius() {
        clipsToBounds = true
        layer.cornerRadius = 5
    }
    
    func scale(to xTimes: CGFloat) {
        transform = CGAffineTransform(scaleX: xTimes, y: xTimes)
    }
    
    func applyBackgroundBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}

extension UILabel {
    
    func applyLabelStandardTheme() {
        textColor = Constants.Color.White
        textAlignment = .center
        backgroundColor = Constants.Color.CellBackground
    }
}

extension UIButton {
    
    func applyAddImageButtonTheme() {
        backgroundColor = Constants.Color.Clear
        setImage(UIImage(named: "EditIcon"), for: .selected)
        isSelected = true
    }
}
