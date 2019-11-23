//
//  ViewController+Common.swift
//  RecordKeep
//
//  Created by Mohanasundaram on 22/11/19.
//  Copyright © 2019 Task. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addAndDisplay(child viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        view.bringSubviewToFront(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    func removeAsChildController() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
