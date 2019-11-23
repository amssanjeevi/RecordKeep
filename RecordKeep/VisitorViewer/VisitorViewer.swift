//
//  VisitorViewer.swift
//  RecordKeep
//
//  Created by admin on 23/11/19.
//  Copyright © 2019 Task. All rights reserved.
//

import UIKit

class VisitorViewer: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var visitorName: UITextView!
    @IBOutlet weak var purposeView: UIView!
    @IBOutlet weak var timeDetailsView: UIView!
    @IBOutlet weak var purposeLabel: UILabel!
    @IBOutlet weak var purposeTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeTextView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Constants.Color.AppTheme
        backgroundView.applyBackgroundBlur()
        bringSubviewToFront(imageView)
        bringSubviewToFront(closeButton)
        visitorName.applyViewBorder()
        visitorName.applyCornerRadius()
        purposeView.applyCornerRadius()
        purposeView.applyViewBorder()
        timeDetailsView.applyCornerRadius()
        timeDetailsView.applyViewBorder()
        purposeLabel.applyViewBorder()
        timeLabel.applyViewBorder()
        purposeLabel.applyLabelStandardTheme()
        timeLabel.applyLabelStandardTheme()
    }
    
    func updateView(data: AnyObject, image: UIImage) {
        imageView.image = image
        backgroundView.image = image
        visitorName.text = data.value(forKey: "name") as? String
        purposeTextView.text = data.value(forKey: "purpose") as? String
        let timeStamp = data.value(forKey: "time") as! String
        let dateAndTime = DatePickerFormatter.sharedInstance.getDate(timeStamp: timeStamp)
        timeTextView.text = dateAndTime
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        slideOutTop { (_) in
            Notifier.sharedInstance.removeNotifier()
            self.removeFromSuperview()
        }
    }
}
