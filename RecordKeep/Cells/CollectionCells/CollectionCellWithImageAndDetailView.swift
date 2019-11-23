//
//  File.swift
//  RecordKeep
//
//  Created by Mohanasundaram on 22/11/19.
//  Copyright © 2019 Task. All rights reserved.
//

import UIKit

class CollectionCellWithImageAndDetailView: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyWhiteContainerTheme()
        applyViewBorder()
        applyCornerRadius()
    }
    
    func updateViewWithData(visitorData: AnyObject) {
        let visitorName = visitorData.value(forKey: "name") as! String
        let imageUrl = visitorData.value(forKey: "imageUrl") as? String
        updateDetailStackWithInfo(details: [visitorName])
        updateImageView(imageUrl: imageUrl, name: visitorName)
    }
    
    func applyAddIconTheme() {
        imageView.image = UIImage(named: "AddIcon")
        updateDetailStackWithInfo(details: ["NewVisitor".localized])
    }
    
    private func updateDetailStackWithInfo(details: [String]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for detail in details {
            let label = UILabel()
            label.text = " \(detail)"
            label.applyLabelStandardTheme()
            stackView.addArrangedSubview(label)
        }
    }
    
    private func updateImageView(imageUrl: String?, name: String) {
        guard let imageUrl = imageUrl else {
            imageView.placeHolderImage(initial: String(name.first!), bgColor: Constants.ColorArray[name.count%10])
            return
        }
        SyncEngine.sharedInstance.getImage(from: imageUrl, completion: { (visitorImage) in
            DispatchQueue.main.async {
                self.imageView.image = visitorImage
            }
        }) {
            DispatchQueue.main.async {
                self.imageView.placeHolderImage(initial: String(name.first!), bgColor: Constants.ColorArray[name.count%10])
            }
        }
    }
}
