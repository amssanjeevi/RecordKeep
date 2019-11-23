//
//  NavigationController+Theme.swift
//  RecordKeep
//
//  Created by Mohanasundaram on 22/11/19.
//  Copyright © 2019 Task. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func applyNavigationViewTheme(target: UIViewController, title: String, barColor: UIColor = Constants.Color.AppTheme, action: Selector?, rightButtonStyle: UIBarButtonItem.SystemItem?) {
        navigationBar.barTintColor = barColor
        target.navigationItem.title = title
        if let rightButtonStyle = rightButtonStyle {
            target.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: rightButtonStyle, target: target, action: action)
        }
    }
}
