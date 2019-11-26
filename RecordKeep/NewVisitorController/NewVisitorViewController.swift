//
//  NewVisitorViewController.swift
//  RecordKeep
//
//  Created by Mohanasundaram on 22/11/19.
//  Copyright © 2019 Task. All rights reserved.
//

import Foundation
import UIKit

protocol ReloadCollectionViewDelegate {
    func reloadCollectionView()
}

enum VisitorViewType {
    case Add
    case View
}

class NewVisitorViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var visitorNameField: UITextField!
    @IBOutlet weak var purposeView: UIView!
    @IBOutlet weak var timeDetailsView: UIView!
    @IBOutlet weak var purposeTextView: UITextView!
    @IBOutlet weak var timeOfVisitField: UITextField!
    @IBOutlet weak var purposeLabel: UILabel!
    @IBOutlet weak var timeOfVisitLabel: UILabel!
    
    var delegate: ReloadCollectionViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.applyRoundRadius()
        addImageButton.applyRoundRadius()
        imageView.applyViewBorder()
        visitorNameField.applyViewBorder()
        visitorNameField.applyCornerRadius()
        purposeView.applyCornerRadius()
        purposeView.applyViewBorder()
        timeDetailsView.applyCornerRadius()
        timeDetailsView.applyViewBorder()
        purposeLabel.applyViewBorder()
        timeOfVisitLabel.applyViewBorder()
        purposeLabel.applyLabelStandardTheme()
        timeOfVisitLabel.applyLabelStandardTheme()
        addImageButton.applyAddImageButtonTheme()
    }
    
    @IBAction func addImagePressed(_ sender: UIButton) {
        listImageProvidingWays()
    }
    
    @objc func savePressed() {
        guard let name = visitorNameField.text, name.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
            showMandtoryAlert(for: "VisitorName".localized)
            return
        }
        guard let purpose = purposeTextView.text, purpose.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
            showMandtoryAlert(for: "Purpose".localized)
            return
        }
        guard let time = timeOfVisitField.text, time.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
            showMandtoryAlert(for: "VisitingTime".localized)
            return
        }
        let timeStamp = DatePickerFormatter.sharedInstance.getTimeStamp(dateString: time, dateFormat: Constants.DateFormat.FormatTwo)
        let postData: [String: AnyObject] = ["name": name as AnyObject,
                                             "purpose": purpose as AnyObject,
                                             "time": timeStamp as AnyObject]
        SyncEngine.sharedInstance.saveVisitorDetails(visitorDetails: postData, visitorImage: imageView.image) { (_) in
            Notifier.sharedInstance.removeNotifier()
            self.delegate.reloadCollectionView()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func showMandtoryAlert(for field: String) {
        Notifier().showAlert(
            alertTitle: "EmptyField".localized,
            message: String(format: "MandatoryField".localized, field),
            firstButtonTitle: "Okay".localized,
            secondButtonTitle: nil,
            firstAction: nil,
            secondAction:  nil
        )
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension NewVisitorViewController {
    
    func listImageProvidingWays() {
        let bottomSheet = UIAlertController(title: "AddImage".localized, message: "ChooseMethod".localized, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "OpenCamera".localized, style: .default) { (action) in
            self.showImagePicker(for: .camera)
        }
        let imagePickerAction = UIAlertAction(title: "ChooseImage".localized, style: .default) { (action) in
            self.showImagePicker(for: .photoLibrary)
        }
        let deleteAction = UIAlertAction(title: "Delete".localized, style: .destructive) { (action) in
            self.removeImage()
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { (action) in
            
        }
        bottomSheet.addAction(cameraAction)
        bottomSheet.addAction(imagePickerAction)
        bottomSheet.addAction(deleteAction)
        bottomSheet.addAction(cancelAction)
        popoverStyle(bottomSheet: bottomSheet)
        present(bottomSheet, animated: true, completion: nil)
    }
    
    private func showImagePicker(for sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        PermissionRequester.sharedInstance.grantPermission(for: .Camera) { (isGranted) in
            DispatchQueue.main.async {
                let cameraController = CameraViewController()
                cameraController.delegate = self
                self.addAndDisplay(child: cameraController)
                self.addCameraControllerConstraints(viewController: cameraController)
                cameraController.showImagePicker(for: sourceType)
            }
        }
     }
    
    private func removeImage() {
        imageView.image = nil
        addImageButton.isSelected = true
    }
    
    private func popoverStyle(bottomSheet: UIViewController) {
        guard UIDevice.current.userInterfaceIdiom == .pad else { return }
        bottomSheet.modalPresentationStyle = .popover
        let presentationController = bottomSheet.popoverPresentationController
        presentationController?.sourceView = addImageButton
        presentationController?.sourceRect = CGRect(x: 0, y: 0, width: addImageButton.frame.size.width, height: addImageButton.frame.size.width)
        presentationController?.permittedArrowDirections = .up
    }
}

extension NewVisitorViewController: ImagePickerDelegate {
    
    func updateChosenImage(image: UIImage?) {
        guard let image = image else { return }
        imageView.image = image
        addImageButton.isSelected = false
    }
}

extension NewVisitorViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == timeOfVisitField {
            timeOfVisitField.inputAccessoryView = view.standardTextFieldToolBar(
                target: self,
                doneAction: #selector(toolBarDone),
                cancelAction: #selector(toolBarCancel)
            )
            timeOfVisitField.inputView = DatePickerFormatter.sharedInstance.getDatePicker(startDate: Date(), endDate: nil, currentDate: Date(), style: .dateAndTime)
            timeOfVisitField.inputView!.backgroundColor = Constants.Color.White
        }
    }
    
    @objc func toolBarDone() {
        let datePicker = timeOfVisitField.inputView as! UIDatePicker
        timeOfVisitField.text = " " + DatePickerFormatter.sharedInstance.formatDate(inputDate: datePicker.date, outputFormat: Constants.DateFormat.FormatTwo)
        timeOfVisitField.endEditing(true)
    }
    
    @objc func toolBarCancel() {
        timeOfVisitField.endEditing(true)
    }
    
    @objc func dateChanged() {
        timeOfVisitField.endEditing(true)
    }
}
