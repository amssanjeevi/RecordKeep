//
//  View+Common.swift
//  RecordKeep
//
//  Created by Mohanasundaram on 23/11/19.
//  Copyright © 2019 Task. All rights reserved.
//

import UIKit

extension UIView {
    
    func keyboardAppears() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            
        }, completion: nil)
    }
    
    func keyboardDisappears() {
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            
        }, completion: nil)
    }
    
    func standardTextFieldToolBar(target: AnyObject?, doneAction: Selector?, cancelAction: Selector?) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done".localized, style: .plain, target: target, action: doneAction)
        let cancelButton = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: target, action: cancelAction)
        toolBar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        return toolBar
    }
    
    func slideInFromTop() {
        frame.origin.y = -UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { () -> Void in
            self.frame.origin.y = 0
        }, completion: nil)
    }
    
    func slideOutTop(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
            self.frame.origin.y = -UIScreen.main.bounds.height
        }, completion: completion)
    }
}
