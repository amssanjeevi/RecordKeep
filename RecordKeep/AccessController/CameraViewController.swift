//
//  CameraViewController.swift
//  RecordKeep
//
//  Created by Mohanasundaram on 22/11/19.
//  Copyright © 2019 Task. All rights reserved.
//

import UIKit

protocol ImagePickerDelegate {
    func updateChosenImage(image: UIImage?)
}

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: ImagePickerDelegate!
    
    lazy var imagePicker: UIImagePickerController = {
        return UIImagePickerController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    func showImagePicker(for sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        delegate.updateChosenImage(image: info[UIImagePickerController.InfoKey.originalImage] as? UIImage)
        dismiss(animated: true, completion: nil)
        removeAsChildController()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        removeAsChildController()
    }
}
