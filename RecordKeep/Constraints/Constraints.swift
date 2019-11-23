//
//  Constraints.swift
//  RecordKeep
//
//  Created by Mohanasundaram on 22/11/19.
//  Copyright © 2019 Task. All rights reserved.
//

import SnapKit
import UIKit

extension NewVisitorViewController {
    
    func addCameraControllerConstraints(viewController: UIViewController) {
        viewController.view.snp.makeConstraints { (make) in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
    }
}

extension UIView {
    
    func spinnerConstraints(spinner: UIView, label: UIView) {
        spinner.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.centerX.equalTo(snp.centerX)
            make.top.equalTo(snp.top).offset(30)
        }
        label.snp.makeConstraints { (make) in
            make.width.equalTo(snp.width)
            make.height.equalTo(30)
            make.centerX.equalTo(snp.centerX)
            make.top.equalTo(spinner.snp.bottom).offset(20)
        }
    }
    
    func spinnerBackGroundConstraints(background: UIView) {
        background.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY)
        }
    }
    
    func addVisitorViewConstraints(view: UIView) {
        view.snp.makeConstraints { (make) in
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY)
            make.width.equalTo(snp.width).multipliedBy(0.95)
            make.height.equalTo(snp.height).multipliedBy(0.8)
        }
    }
}
