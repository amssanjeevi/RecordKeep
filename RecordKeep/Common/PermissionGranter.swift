//
//  PermissionGranter.swift
//  RecordKeep
//
//  Created by Mohanasundaram on 22/11/19.
//  Copyright © 2019 Task. All rights reserved.
//

import UIKit
import AVFoundation

enum PermissionType {
    case Camera
    case Storage
}

class PermissionRequester {
    
    static var sharedInstance = PermissionRequester()
    
    func grantPermission(for type: PermissionType, on success: @escaping (Bool) -> Void) {
        switch type {
            case .Camera: requestCameraPermission(on: success)
            case .Storage:
                return
        }
    }
    
    private func requestCameraPermission(on success: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (isGranted) in
                    if isGranted { success(true) }
                    else { self.notifyPermissionIsMust() }
                }
            case .restricted: notifyPermissionIsMust()
            case .denied: notifyPermissionIsMust()
            case .authorized: success(true)
        }
    }
    
    private func notifyPermissionIsMust() {
        Notifier().showAlert(
            alertTitle: "NoPermission".localized,
            message: "PermissionReason".localized,
            firstButtonTitle: "Okay".localized,
            secondButtonTitle: "ShowSettings".localized,
            firstAction: { },
            secondAction:  {
                let settingsUrl = URL(string: UIApplication.openSettingsURLString)
                UIApplication.shared.openURL(settingsUrl!)
            }
        )
    }
}
