//
//  Student.swift
//  StudentBookAPI
//
//  Created by Justin Carver on 8/31/16.
//  Copyright © 2016 Justin Carver. All rights reserved.
//

import Foundation

struct Student {
    
    static let kName = "name"
    
    let name: String
}

extension Student {
    
    var dictionaryRep: [String: AnyObject] {
        return [Student.kName: name]
    }
    
    var jsonData: NSData? {
        return try? NSJSONSerialization.dataWithJSONObject(dictionaryRep, options: .PrettyPrinted)
    }
    
    init?(dictionary: [String: AnyObject]) {
        guard let name = dictionary[Student.kName] as? String else { return nil }
        
        self.name = name
    }
}