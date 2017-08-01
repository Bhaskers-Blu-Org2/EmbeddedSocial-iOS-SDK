//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class BundleHelper {
    
    func getCurrentBundle() -> Bundle {
        return Bundle(for: type(of: self))
    }
    
}

class Templates {
    
    open static var bundle = BundleHelper().getCurrentBundle()
    
    class func load(name: String, values: [String: Any] = [:]) -> [String: Any] {
        let path = Templates.bundle.path(forResource: name, ofType: "json")!

        let content = try! NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
        
        var mergedValues = APIConfig.values
        mergedValues.update(other: values)

        var json = try! JSONSerialization.jsonObject(with: content.data(using: .utf8)!, options: []) as! [String: Any]
        
        for (key, value) in mergedValues {
            let parts = key.components(separatedBy: "->")
            if parts.count > 1 {
                var temp = json[parts[0]] as! [String: Any]
                temp[parts[1]] = value
                json[parts[0]] = temp
            } else {
                json[parts[0]] = value
            }
        }
        
        return json
    }
    
}