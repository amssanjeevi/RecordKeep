//
//  Encoder.swift
//  RecordKeep
//
//  Created by Mohanasundaram on 23/11/19.
//  Copyright © 2019 Task. All rights reserved.
//

import Foundation

class Encoder {
    
    class func jsonStringWithObject(obj: AnyObject) -> String? {
        do {
            let jsonData  = try JSONSerialization.data(withJSONObject: obj, options: JSONSerialization.WritingOptions(rawValue: 0))
            let stringData = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
            return stringData as String?
        }
        catch { print(error.localizedDescription) }
        return nil
    }
}
