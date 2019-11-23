//
//  ViewController.swift
//  RecordKeep
//
//  Created by Mohanasundaram on 21/11/19.
//  Copyright © 2019 Task. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var navigationView: UINavigationController!
    private var collectionViewController: CollectionViewController!
    private var newVisitorViewController: NewVisitorViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadLandingPage() {
        Notifier.sharedInstance.showActivityIndicator(title: "DataFetchInfo".localized)
        collectionViewController = CollectionViewController()
        collectionViewController.delegate = self
        navigationView = UINavigationController(rootViewController: collectionViewController)
        navigationView.applyNavigationViewTheme(
            target: collectionViewController,
            title: "VisitorLog".localized,
            action: #selector(CollectionViewController.searchPressed),
            rightButtonStyle: .none
        )
        addAndDisplay(child: navigationView)
    }

}

extension ContainerViewController: NewVisitorEntryDelegate {
    
    func addNewVisitor() {
        newVisitorViewController = NewVisitorViewController()
        newVisitorViewController.delegate = self
        navigationView.pushViewController(newVisitorViewController, animated: true)
        navigationView.applyNavigationViewTheme(
            target: newVisitorViewController,
            title: "NewVisitor".localized,
            action: #selector(NewVisitorViewController.savePressed),
            rightButtonStyle: .save
        )
    }    
}

extension ContainerViewController: ReloadCollectionViewDelegate {
    
    func reloadCollectionView() {
        SyncEngine.sharedInstance.getVisitorDetails { (visitorDetails) in
            self.collectionViewController.dataArray = visitorDetails
            self.collectionViewController.collectionView.reloadData()
        }
    }
}
