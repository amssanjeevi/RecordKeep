//
//  SyncEngine.swift
//  RecordKeep
//
//  Created by Mohanasundaram on 23/11/19.
//  Copyright © 2019 Task. All rights reserved.
//

import UIKit
import Firebase

class SyncEngine {
    
    static let sharedInstance = SyncEngine()
    
    lazy var dbReference = {
        return Database.database().reference(fromURL: "https://recordkeep-91864.firebaseio.com/")
    }()
    
    func getVisitorDetails(completionHandler: @escaping ([AnyObject]) -> Void) {
        guard Reachability.sharedInstance.isReachable() else { return }
        let childrenPath = "visitors"
        dbReference.child(childrenPath).queryOrdered(byChild: "time").observeSingleEvent(of: .value) { (snapShot) in
            guard snapShot.exists() else { return }
            let dataDict = snapShot.value as! [String: AnyObject]
            let visitorDetailsArray = Array(dataDict.values)
            completionHandler(visitorDetailsArray)
            Notifier.sharedInstance.removeNotifier()
        }
    }
    
    func getImage(from Url: String, completion: @escaping (UIImage)->Void, failure: @escaping () -> Void) {
        Storage.storage().reference(forURL: Url).getData(maxSize: 1*1024*1024) { (data, error) in
            guard error == nil else {
                failure()
                return
            }
            guard let data = data else {
                failure()
                return
            }
            guard let image = UIImage(data: data) else {
                failure()
                return
            }
            completion(image)
        }
    }
    
    func savetoStorage(image: UIImage?, uniqueId: String, completionHandler: @escaping (String?) -> Void, failureHandler: @escaping (String) -> Void) {
        guard let image = image else {
            completionHandler(nil)
            return
        }
        guard let compressedImage = image.jpeg(.low) else {
            alertFailure(title: "CompressionFailed".localized, message: "CompressionFailureInfo".localized)
            return
        }
        let path = "visitors/" + uniqueId
        let storage = Storage.storage().reference().child(path)
        storage.putData(compressedImage, metadata: nil) { (meta, error) in
            guard error == nil else {
                failureHandler(error!.localizedDescription)
                return
            }
            
            storage.downloadURL(completion: { (downloadUrl, error) in
                guard error == nil else {
                    failureHandler(error!.localizedDescription)
                    return
                }
                guard let downloadUrl = downloadUrl else {
                    failureHandler("InvalidDownloadUrl".localized)
                    return
                }
                completionHandler(downloadUrl.absoluteString)
            })
        }
    }
    
    func saveToDatabase(postData: AnyObject, completionHandler: @escaping (String?) -> Void, failureHandler: @escaping (String) -> Void) {
        let dbReference = Database.database().reference(fromURL: "https://recordkeep-91864.firebaseio.com/")
        guard let key = dbReference.childByAutoId().key else { return }
        let childUpdates = ["/visitors/\(key)": postData]
        dbReference.updateChildValues(childUpdates) { (error, _) in
            guard error == nil else {
                failureHandler(error!.localizedDescription)
                return
            }
            completionHandler(nil)
        }

    }
    
    func saveVisitorDetails(visitorDetails: [String: AnyObject], visitorImage: UIImage?, completionHandler: @escaping (String?) -> Void) {
        guard Reachability.sharedInstance.isReachable() else { return }
        Notifier.sharedInstance.showActivityIndicator(title: "Saving...")
        savetoStorage(image: visitorImage, uniqueId: NSUUID().uuidString, completionHandler: { (downloadUrl) in
            var visitorDetails = visitorDetails
            visitorDetails.updateValue(downloadUrl as AnyObject, forKey: "imageUrl")
            self.saveToDatabase(postData: visitorDetails as AnyObject, completionHandler: completionHandler, failureHandler: { (failureReason) in
                self.alertFailure(title: "SaveFailed".localized, message: failureReason)
            })
        }) { (failureReason) in
            self.alertFailure(title: "SaveFailed".localized, message: failureReason)
        }
    }
    
    private func alertFailure(title: String, message: String) {
        Notifier.sharedInstance.removeNotifier()
        Notifier.sharedInstance.showAlert(
            alertTitle: title,
            message: message,
            firstButtonTitle: "Okay".localized,
            secondButtonTitle: nil,
            firstAction: nil,
            secondAction:  nil
        )
    }
}
