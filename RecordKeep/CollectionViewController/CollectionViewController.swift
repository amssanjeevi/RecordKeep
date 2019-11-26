//
//  CollectionViewController.swift
//  RecordKeep
//
//  Created by Mohanasundaram on 22/11/19.
//  Copyright © 2019 Task. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol NewVisitorEntryDelegate {
    func addNewVisitor()
}

class CollectionViewController: UICollectionViewController {
    
    private let ImageAndDetailCellIdentifier = "CollectionCellWithImageAndDetailView"
    
    var dataArray: [AnyObject] = []
    var delegate: NewVisitorEntryDelegate!
    var visitorView: VisitorViewer!
    
    init() {
        super.init(nibName: "CollectionViewController", bundle: nil)
        SyncEngine.sharedInstance.getVisitorDetails { (visitorDetails) in
            self.dataArray = visitorDetails.sorted { ($0.value(forKey: "time") as! String) > ($1.value(forKey: "time") as! String) }
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: ImageAndDetailCellIdentifier, bundle: nil), forCellWithReuseIdentifier: ImageAndDetailCellIdentifier)
        setCollectionViewFlowLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func searchPressed() {
        print("searchPressed")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageAndDetailCellIdentifier, for: indexPath) as! CollectionCellWithImageAndDetailView
        if indexPath.row == 0 { cell.applyAddIconTheme() }
        else {
            let dataObject = dataArray[indexPath.row - 1]
            cell.updateViewWithData(visitorData: dataObject)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionCellWithImageAndDetailView
        if indexPath.row == 0 { delegate.addNewVisitor() }
        else {
            showVisitor(dataObject: dataArray[indexPath.row-1], image: cell.imageView.image!)
        }
        
    }
    
    override public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! CollectionCellWithImageAndDetailView
        cell.startPressedAnimate()
    }
    
    override public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! CollectionCellWithImageAndDetailView
        cell.endPressedAnimate()
    }
}

extension CollectionViewController {
    
    func setCollectionViewFlowLayout() {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.itemSize = getOptimalCellSize()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.reloadData()
    }
    
    private func getOptimalCellSize() -> CGSize {
        let aspectRatio: CGFloat = 1.4375
        let numberOfCellsPerRow: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 3 : 4
        let spacingConstant: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 30 : 60
        let width = (collectionView.frame.size.width - spacingConstant)/numberOfCellsPerRow
        let optimalSize = CGSize(width: width, height: width * aspectRatio)
        return optimalSize
    }
}

extension CollectionViewController {
    
    func showVisitor(dataObject: AnyObject, image: UIImage){
        let overlay = Notifier.sharedInstance.addScreenOverlay()
        view.bringSubviewToFront(overlay)
        visitorView = UINib(nibName: "VisitorViewer", bundle: Bundle(identifier: "com.task.RecordKeep"))
                      .instantiate(withOwner: nil, options: nil)[0] as? VisitorViewer
        overlay.addSubview(visitorView)
        visitorView.slideInFromTop()
        overlay.addVisitorViewConstraints(view: visitorView)
        visitorView.applyViewBorder()
        visitorView.applyCornerRadius()
        visitorView.updateView(data: dataObject, image: image)
    }
}
