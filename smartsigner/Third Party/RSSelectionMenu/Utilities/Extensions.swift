//
//  AssociatedObjectExtension.swift
//
//  Copyright (c) 2018 Rushi Sangani
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import CoreData

// convert to dictionary
public extension NSObject {
    
    // dictionary
    @objc public func toDictionary() -> [String: AnyObject] {
        
        let propertiesDictionary : NSMutableDictionary = NSMutableDictionary()
        
        // check of object is NSManagedObject
        if let object = self as? NSManagedObject {
            let keys = Array(object.entity.attributesByName.keys)
            propertiesDictionary.setDictionary(object.dictionaryWithValues(forKeys: keys))
        }
        else {
            let model = Mirror(reflecting: self)
            for (name, value) in model.children {
                propertiesDictionary.setValue(value, forKey: name!)
            }
        }
        return propertiesDictionary as! [String: AnyObject]
    }
}

/// Decodable
public extension Decodable {
    
    /// convert model to dictionary
    func toDictionary() -> [String: Any] {
        
        // create dict
        var data = [String: Any]()
        
        // get mirror object and key,value pairs
        let model = Mirror(reflecting: self)
        for (name, value) in model.children {
            data[name!] = value
        }
        return data
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var releaseVersionNumberPretty: String {
        return "v\(releaseVersionNumber ?? "1.0.0") b\(buildVersionNumber ?? "1")"
    }
}
